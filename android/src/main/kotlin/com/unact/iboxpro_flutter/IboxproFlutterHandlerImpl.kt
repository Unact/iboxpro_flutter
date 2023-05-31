@file:Suppress("UNCHECKED_CAST")

package com.unact.iboxpro_flutter

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Handler
import androidx.annotation.NonNull
import ibox.pro.sdk.external.PaymentContext
import ibox.pro.sdk.external.ReversePaymentContext
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import ibox.pro.sdk.external.PaymentController
import ibox.pro.sdk.external.PaymentControllerListener
import ibox.pro.sdk.external.PaymentResultContext
import ibox.pro.sdk.external.entities.APIResult
import ibox.pro.sdk.external.entities.TransactionItem
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import java.util.*
import kotlin.collections.HashMap

class IboxproFlutterHandlerImpl: MethodCallHandler {
  private var methodChannel: MethodChannel
  private var currentActivity: Context
  private var paymentController: PaymentController
  private var paymentControllerListener: IboxproFlutterPluginListener
  private var searchDevice: Boolean = false
  private var paymentContext: PaymentContext? = null
  private var reversePaymentContext: ReversePaymentContext? = null
  private var isSingleStepEMV: Boolean = false
  private var deviceName: String = ""

  constructor(activity: Context, channel: MethodChannel) {
    currentActivity = activity
    methodChannel = channel
    paymentController = PaymentController.getInstance()
    paymentControllerListener = IboxproFlutterPluginListener(this)

    paymentController.setPaymentControllerListener(paymentControllerListener)
  }

  companion object {
    const val apiError = -1

    fun formatTransactionItem(transactionItem: TransactionItem): HashMap<String, Any?> {
      val result = HashMap<String, Any?>()
      val resultCard = HashMap<String, Any?>()
      val card = transactionItem.card

      resultCard["iin"] = card?.iin
      resultCard["expiration"] = card?.exp
      resultCard["panMasked"] = card?.panMasked
      resultCard["panEnding"] = card?.panEnding
      resultCard["binID"] = card?.bin

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
      result["acquirerID"] = transactionItem.json["AcquirerID"]
      result["isNotFinished"] = transactionItem.json["IsNotFinished"]
      result["canCancel"] = transactionItem.json["CanCancel"]
      result["canReturn"] = transactionItem.json["CanReturn"]
      result["externalPaymentData"] = transactionItem.externalPayment.qr.map {
        val res = HashMap<String, Any?>()
        res["title"] = it.key
        res["value"] = it.value
        res
      }
      result["card"] = resultCard

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
      params["id"] as String,
      params["receiptPhone"] as? String,
      params["receiptEmail"] as? String,
      params["signature"] as ByteArray
    )
    val arguments = checkResult(res)

    methodChannel.invokeMethod("onPaymentAdjust", arguments)
  }

  private fun adjustReversePayment(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>
    val res = paymentController.adjustReverse(
      currentActivity,
      params["id"] as String,
      params["receiptPhone"] as? String,
      params["receiptEmail"] as? String,
      params["signature"] as ByteArray
    )
    val arguments = checkResult(res)

    methodChannel.invokeMethod("onReversePaymentAdjust", arguments)
  }

  private fun cancel() {
    disable()
  }

  private fun info(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>
    val res = paymentController.getTransactionByID(currentActivity, params["id"] as String)
    val arguments = checkResult(res)

    if (arguments["errorCode"] == 0) {
      var transactionItem : TransactionItem? = null
      if (res.transactions.isNotEmpty()) transactionItem = res.transactions.first()
      if (res.inProcessTransactions.isNotEmpty()) transactionItem = res.inProcessTransactions.first()

      if (transactionItem != null) {
        val formattedData = formatTransactionItem(transactionItem)

        arguments["transaction"] = formattedData
      }
    }

    methodChannel.invokeMethod("onInfo", arguments)
  }

  private fun login(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>

    paymentController.setCredentials(params["email"].toString(), params["password"].toString())
    val res = paymentController.auth(currentActivity)
    val arguments = checkResult(res)

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

    paymentContext = PaymentContext()
    paymentContext?.method = methodFromInputType(inputType)
    paymentContext?.currency = PaymentController.Currency.RUB
    paymentContext?.amount = amount
    paymentContext?.description = description
    paymentContext?.receiptEmail = email
    paymentContext?.receiptPhone = phone

    isSingleStepEMV = singleStepAuth

    paymentController.enable()
    if (paymentContext!!.method != PaymentController.PaymentMethod.CARD) beginPayment()
  }

  private fun startReversePayment(call: MethodCall) {
    val params = call.arguments as HashMap<String, Any>
    val inputType = PaymentController.PaymentInputType.fromValue(params["inputType"] as Int)
    val amount = params["amount"] as Double
    val email = params["receiptEmail"] as? String
    val phone = params["receiptPhone"] as? String
    val singleStepAuth = params["singleStepAuth"] as Boolean
    val res = paymentController.getTransactionByID(currentActivity, params["id"] as String)
    val arguments = checkResult(res)

    if (arguments["errorCode"] != 0) {
      methodChannel.invokeMethod("onInfoError", arguments)
      return
    }

    var transactionItem : TransactionItem? = null
    var action : PaymentController.ReverseAction? = null
    if (res.transactions.isNotEmpty()) transactionItem = res.transactions.first()
    if (res.inProcessTransactions.isNotEmpty()) transactionItem = res.inProcessTransactions.first()

    if (transactionItem == null) {
      methodChannel.invokeMethod("onInfoError", arguments)
      return
    }

    if (
      transactionItem.canCancel() ||
      transactionItem.canCancelPartial() ||
      transactionItem.canCancelCNP() ||
      transactionItem.canCancelCNPPartial()
    ) {
      action = PaymentController.ReverseAction.CANCEL
    }

    if (transactionItem.canReturn() || transactionItem.canReturnPartial()) {
      action = PaymentController.ReverseAction.RETURN
    }

    if (action == null) {
      methodChannel.invokeMethod("onReverseReject", arguments)
      return
    }

    reversePaymentContext = ReversePaymentContext()
    reversePaymentContext?.action = action
    reversePaymentContext?.transactionID = transactionItem.id
    reversePaymentContext?.currency = PaymentController.Currency.RUB
    reversePaymentContext?.returnAmount = amount
    reversePaymentContext?.receiptEmail = email
    reversePaymentContext?.receiptPhone = phone

    isSingleStepEMV = singleStepAuth

    paymentController.enable()
    if (methodFromInputType(inputType) != PaymentController.PaymentMethod.CARD) beginPayment()
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
    paymentContext = null
    reversePaymentContext = null
    paymentController.disable()
    paymentController.setReaderType(currentActivity, null, null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "adjustPayment" -> {
        adjustPayment(call)
        result.success(null)
      }
      "adjustReversePayment" -> {
        adjustReversePayment(call)
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
      "startPayment" -> {
        startPayment(call)
        result.success(null)
      }
      "startReversePayment" -> {
        startReversePayment(call)
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

  private fun checkResult(res: APIResult): HashMap<String, Any?> {
    val arguments = HashMap<String, Any?>()

    if (res.isValid) {
      arguments["errorCode"] = res.errorCode
      arguments["errorMessage"] = res.errorMessage
    } else {
      arguments["errorCode"] = apiError
      arguments["errorMessage"] = null
    }

    return arguments
  }

  private fun beginPayment() {
    if (reversePaymentContext != null) {
      paymentController.reversePayment(currentActivity, reversePaymentContext)
    } else {
      paymentController.startPayment(currentActivity, paymentContext)
    }

    paymentController.isSingleStepEMV = isSingleStepEMV
  }

  @SuppressLint("MissingPermission")
  private fun searchBTDevice() {
    if (!searchDevice) return

    Handler().postDelayed({
      val devices = paymentController.getBluetoothDevices(currentActivity)

      if (devices.isNotEmpty()) {
        val device = devices.find { it.name == deviceName }

        if (device != null) {
          val arguments = HashMap<String, Any>()

          arguments["name"] = device.name

          searchDevice = false
          paymentController.setReaderType(currentActivity, PaymentController.ReaderType.P17, device.address)
          methodChannel.invokeMethod("onReaderSetBTDevice", arguments)
        }
      }

      searchBTDevice()
    }, 100)
  }

  internal class IboxproFlutterPluginListener: PaymentControllerListener {
    private var handler: IboxproFlutterHandlerImpl

    constructor(iboxproFlutterHandlerImpl: IboxproFlutterHandlerImpl) {
      handler = iboxproFlutterHandlerImpl
    }

    override fun onFinished(transactionData: PaymentResultContext) {
      val arguments = HashMap<String, Any>()

      arguments["requiredSignature"] = transactionData.isRequiresSignature
      arguments["transaction"] = formatTransactionItem(transactionData.transactionItem)

      handler.disable()

      handler.methodChannel.invokeMethod("onPaymentComplete", arguments)
    }

    override fun onTransactionStarted(transactionId: String) {
      val arguments = HashMap<String, Any>()

      arguments["id"] = transactionId

      handler.methodChannel.invokeMethod("onPaymentStart", arguments)
    }

    override fun onReaderEvent(event: PaymentController.ReaderEvent, params: MutableMap<String, String>?) {
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
        PaymentController.ReaderEvent.PIN_TIMEOUT -> handler.disable()
        PaymentController.ReaderEvent.INIT_SUCCESSFULLY -> handler.beginPayment()
        PaymentController.ReaderEvent.CONNECTED,
        PaymentController.ReaderEvent.START_INIT,
        PaymentController.ReaderEvent.SWIPE_CARD,
        PaymentController.ReaderEvent.EMV_TRANSACTION_STARTED,
        PaymentController.ReaderEvent.NFC_TRANSACTION_STARTED,
        PaymentController.ReaderEvent.WAITING_FOR_CARD -> {}
      }

      handler.methodChannel.invokeMethod("onReaderEvent", arguments)
    }

    override fun onError(error: PaymentController.PaymentError, message: String?) {
      val arguments = HashMap<String, Any>()

      arguments["nativeErrorType"] = error.ordinal
      arguments["errorMessage"] = message ?: ""

      handler.disable()

      handler.methodChannel.invokeMethod("onPaymentError", arguments)
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
