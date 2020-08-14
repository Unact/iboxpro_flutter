package com.unact.iboxpro_flutter

import android.app.Activity
import android.os.Handler
import ibox.pro.sdk.external.PaymentContext
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import ibox.pro.sdk.external.PaymentController
import ibox.pro.sdk.external.PaymentControllerListener
import ibox.pro.sdk.external.PaymentResultContext
import ibox.pro.sdk.external.entities.TransactionItem
import java.util.*
import kotlin.collections.HashMap

class IboxproFlutterPlugin: MethodCallHandler {
  private var currentActivity: Activity
  private var methodChannel: MethodChannel
  private var paymentController: PaymentController
  private var paymentControllerListener: IboxproFlutterPluginListener
  private var searchDevice: Boolean = false
  private var paymentContext: PaymentContext
  private var isSingleStepEMV: Boolean = false
  private var deviceName: String = ""

  constructor(activity: Activity, channel: MethodChannel) {
    currentActivity = activity
    methodChannel = channel
    paymentController = PaymentController.getInstance()
    paymentControllerListener = IboxproFlutterPluginListener(this)
    paymentContext = PaymentContext()

    paymentController.setPaymentControllerListener(paymentControllerListener)
  }

  companion object {
    const val apiError = -1
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "iboxpro_flutter")
      channel.setMethodCallHandler(IboxproFlutterPlugin(registrar.activity(), channel))
    }

    fun formatTransactionItem(transactionItem: TransactionItem): HashMap<String, Any> {
      var result = HashMap<String, Any>()
      var resultCard = HashMap<String, Any?>()
      var card = transactionItem.card

      result["id"] = transactionItem.id
      result["rrn"] = transactionItem.rrn
      result["emvData"] = transactionItem.emvData
      result["date"] = transactionItem.date.toString()
      result["currencyID"] = transactionItem.currencyId
      result["descriptionOfTransaction"] = transactionItem.description
      result["stateDisplay"] = transactionItem.stateDisplay
      result["invoice"] = transactionItem.invoice
      result["approvalCode"] = transactionItem.approvalCode
      result["operation"] = transactionItem.operation
      result["cardholderName"] = transactionItem.cardholderName
      result["terminalName"] = transactionItem.terminalName
      result["amount"] = transactionItem.amount
      result["amountNetto"] = transactionItem.json["AmountNetto"]
      result["feeTotal"] = transactionItem.json["FeeTotal"]
      result["latitude"] = transactionItem.latitude
      result["longitude"] = transactionItem.longitude
      result["state"] = transactionItem.state
      result["subState"] = transactionItem.json["Substate"]
      result["inputType"] = transactionItem.inputType.value
      result["displayMode"] = transactionItem.displayMode.ordinal
      result["reverseMode"] = transactionItem.json["ReverseMode"]
      result["acquirerID"] = transactionItem.json["AcquirerID"]
      result["card"] = resultCard
      resultCard["iin"] = card?.iin
      resultCard["expiration"] = card?.exp
      resultCard["panMasked"] = card?.panMasked
      resultCard["panEnding"] = card?.panEnding
      resultCard["binID"] = card?.bin

      return result
    }

    fun methodFromInputType(inputType: PaymentController.PaymentInputType): PaymentController.PaymentMethod {
      return if (
        inputType != PaymentController.PaymentInputType.SWIPE &&
        inputType != PaymentController.PaymentInputType.CHIP &&
        inputType != PaymentController.PaymentInputType.NFC &&
        inputType != PaymentController.PaymentInputType.MANUAL
      ) {
        PaymentController.PaymentMethod.valueOf(inputType.toString())
      } else {
        PaymentController.PaymentMethod.CARD
      }
    }
  }

  private fun adjustPayment(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>
    val res = paymentController.adjust(
      currentActivity,
      params["trId"] as String,
      params["receiptPhone"] as? String,
      params["receiptEmail"] as? String,
      params["signature"] as ByteArray
    )
    val arguments = HashMap<String, Any>()
    arguments["errorCode"] = if (res != null && res.isValid) res.errorCode else apiError

    methodChannel.invokeMethod("onPaymentAdjust", arguments)
  }

  private fun cancel() {
    disable()
  }

  private fun info(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>
    val res = paymentController.getTransactionByID(currentActivity, params["trId"] as String)
    val errorCode = if (res != null && res.isValid) res.errorCode else apiError
    val arguments = HashMap<String, Any>()

    arguments["errorCode"] = errorCode

    if (errorCode == 0 && res.transactions.isNotEmpty()) {
      val transactionItem = res.transactions.first()
      val formattedData = formatTransactionItem(transactionItem)

      arguments.putAll(formattedData)
    }

    methodChannel.invokeMethod("onInfo", arguments)
  }

  private fun login(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>

    paymentController.setCredentials(params["email"].toString(), params["password"].toString())
    val res = paymentController.auth(currentActivity)
    val arguments = HashMap<String, Any>()
    arguments["errorCode"] = if (res != null && res.isValid) res.errorCode else apiError

    methodChannel.invokeMethod("onLogin", arguments)
  }

  private fun startPayment(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>
    val inputType = PaymentController.PaymentInputType.fromValue(params["inputType"] as Int)
    val amount = params["amount"] as Double
    val description = params["description"] as String
    val email = params["receiptEmail"] as? String
    val phone = params["receiptPhone"] as? String
    val singleStepAuth = params["singleStepAuth"] as Boolean

    paymentContext.reset()

    paymentContext.method = methodFromInputType(inputType)
    paymentContext.currency = PaymentController.Currency.RUB
    paymentContext.amount = amount
    paymentContext.description = description
    paymentContext.receiptEmail = email
    paymentContext.receiptPhone = phone

    isSingleStepEMV = singleStepAuth

    paymentController.enable()
  }

  private fun startSearchBTDevice(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>

    if (searchDevice) return

    deviceName = params["deviceName"] as String
    searchDevice = true
    searchBTDevice()
  }

  private fun stopSearchBTDevice() {
    if (!searchDevice) return

    searchDevice = false
  }

  private fun disable() {
    paymentController.disable()
    paymentController.setReaderType(currentActivity, null, null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "adjustPayment" -> {
        adjustPayment(call)
        result.success(null)
      }
      "cancel" -> {
        cancel()
        result.success(null)
      }
      "info" -> {
        info(call)
        result.success(null)
      }
      "login" -> {
        login(call)
        result.success(null)
      }
      "setRequestTimeout" -> {
        result.success(null)
      }
      "startPayment" -> {
        startPayment(call)
        result.success(null)
      }
      "startSearchBTDevice" -> {
        startSearchBTDevice(call)
        result.success(null)
      }
      "stopSearchBTDevice" -> {
        stopSearchBTDevice()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun beginPayment() {
    paymentController.startPayment(currentActivity, paymentContext)
    paymentController.isSingleStepEMV = isSingleStepEMV
  }

  private fun searchBTDevice() {
    if (!searchDevice) return

    Handler().postDelayed({
      val devices = paymentController.getBluetoothDevices(currentActivity)

      if (devices.isNotEmpty()) {
        var device = devices.find { it.name == deviceName }

        if (device != null) {
          searchDevice = false
          paymentController.setReaderType(currentActivity, PaymentController.ReaderType.P17, device.address)
          methodChannel.invokeMethod("onReaderSetBTDevice", null)
        }
      }

      searchBTDevice()
    }, 100)
  }

  internal class IboxproFlutterPluginListener: PaymentControllerListener {
    private var plugin: IboxproFlutterPlugin

    constructor(iboxproFlutterPlugin: IboxproFlutterPlugin) {
      plugin = iboxproFlutterPlugin
    }

    override fun onFinished(transactionData: PaymentResultContext) {
      val arguments = HashMap<String, Any>()

      arguments["id"] = transactionData.tranId
      arguments["requiredSignature"] = transactionData.isRequiresSignature
      arguments["transaction"] = formatTransactionItem(transactionData.transactionItem)

      plugin.disable()

      plugin.methodChannel.invokeMethod("onPaymentComplete", arguments)
    }

    override fun onTransactionStarted(transactionId: String) {
      val arguments = HashMap<String, Any>()

      arguments["id"] = transactionId

      plugin.methodChannel.invokeMethod("onPaymentStart", arguments)
    }

    override fun onReaderEvent(event: PaymentController.ReaderEvent) {
      val arguments = HashMap<String, Any>()

      arguments["nativeReaderEventType"] = event.ordinal

      when(event) {
        PaymentController.ReaderEvent.DISCONNECTED,
        PaymentController.ReaderEvent.INIT_FAILED,
        PaymentController.ReaderEvent.EJECT_CARD_TIMEOUT,
        PaymentController.ReaderEvent.PAYMENT_CANCELED,
        PaymentController.ReaderEvent.EJECT_CARD,
        PaymentController.ReaderEvent.BAD_SWIPE,
        PaymentController.ReaderEvent.LOW_BATTERY,
        PaymentController.ReaderEvent.CARD_TIMEOUT,
        PaymentController.ReaderEvent.PIN_TIMEOUT -> plugin.disable()
        PaymentController.ReaderEvent.INIT_SUCCESSFULLY -> plugin.beginPayment()
      }

      plugin.methodChannel.invokeMethod("onReaderEvent", arguments)
    }

    override fun onError(error: PaymentController.PaymentError, message: String?) {
      val arguments = HashMap<String, Any>()

      arguments["nativeErrorType"] = error.ordinal
      arguments["errorMessage"] = message ?: ""

      plugin.disable()

      plugin.methodChannel.invokeMethod("onPaymentError", arguments)
    }

    override fun onSelectInputType(p0: MutableList<PaymentController.PaymentInputType>?): PaymentController.PaymentInputType {
      return PaymentController.PaymentInputType.OTHER
    }
    override fun onSelectApplication(p0: MutableList<String>?): Int { return 0 }
    override fun onCancellationTimeout(): Boolean { return false }
    override fun onScheduleCreationFailed(p0: PaymentController.PaymentError?, p1: String?): Boolean { return false}
    override fun onConfirmSchedule(p0: MutableList<MutableMap.MutableEntry<Date, Double>>?, p1: Double): Boolean { return false }
    override fun onPinEntered() {}
    override fun onReturnPowerOnNFCResult(p0: Boolean) {}
    override fun onFinishMifareCard(p0: Boolean) {}
    override fun onAutoConfigUpdate(p0: Double) {}
    override fun onOperateMifareCard(p0: Hashtable<String, String>?) {}
    override fun onReadMifareCard(p0: Hashtable<String, String>?) {}
    override fun onWriteMifareCard(p0: Boolean) {}
    override fun onReturnNFCApduResult(p0: Boolean, p1: String?, p2: Int) {}
    override fun onAutoConfigFinished(p0: Boolean, p1: String?, p2: Boolean) {}
    override fun onBatteryState(p0: Double) {}
    override fun onSwitchedToCNP() {}
    override fun onPinRequest() {}
    override fun onVerifyMifareCard(p0: Boolean) {}
    override fun onTransferMifareData(p0: String?) {}
    override fun onSearchMifareCard(p0: Hashtable<String, String>?) {}
    override fun onReturnPowerOffNFCResult(p0: Boolean) {}
  }
}
