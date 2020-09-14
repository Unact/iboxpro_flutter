import Flutter
import UIKit

public class SwiftIboxproFlutterPlugin: NSObject, FlutterPlugin {
  private static let apiError = -1
  private let methodChannel: FlutterMethodChannel
  private let paymentControllerDelegate: IboxproFlutterDelegate
  private let paymentController: PaymentController
  private static var deviceName = ""

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "iboxpro_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftIboxproFlutterPlugin(channel)

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public required init(_ channel: FlutterMethodChannel) {
    self.methodChannel = channel
    self.paymentController = PaymentController.instance()!
    self.paymentControllerDelegate = IboxproFlutterDelegate(
      methodChannel: channel,
      paymentController: self.paymentController
    )

    self.paymentController.setDelegate(paymentControllerDelegate)
    super.init()
  }

  public func adjustPayment(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]

    DispatchQueue.global(qos: .background).async {
      let res = self.paymentController.adjust(
        withTrId: (params["id"] as! String),
        signature: (params["signature"] as! FlutterStandardTypedData).data,
        receiptEmail: params["receiptEmail"] as? String,
        receiptPhone: params["receiptPhone"] as? String
      )
      let arguments = self.checkResult(res)

      self.methodChannel.invokeMethod("onPaymentAdjust", arguments: arguments)
    }
  }

  public func adjustReversePayment(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]

    DispatchQueue.global(qos: .background).async {
      let res = self.paymentController.reverseAdjust(
        withTrId: (params["id"] as! String),
        signature: (params["signature"] as! FlutterStandardTypedData).data,
        receiptEmail: params["receiptEmail"] as? String,
        receiptPhone: params["receiptPhone"] as? String
      )
      let arguments = self.checkResult(res)

      self.methodChannel.invokeMethod("onReversePaymentAdjust", arguments: arguments)
    }
  }

  public func cancel() {
    self.paymentController.disable()
  }

  public func info(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]

    DispatchQueue.global(qos: .background).async {
      let res = self.paymentController.history(withTransactionID: (params["id"] as! String))
      var arguments = self.checkResult(res)

      if (arguments["errorCode"] as! Int == 0 && !res!.transactions()!.isEmpty) {
        let transactionItem = res!.transactions().first as! TransactionItem
        let formattedData = SwiftIboxproFlutterPlugin.formatTransactionItem(transactionItem)

        arguments["transaction"] = formattedData
      }

      self.methodChannel.invokeMethod("onInfo", arguments: arguments)
    }
  }

  public func login(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]

    DispatchQueue.global(qos: .background).async {
      self.paymentController.setEmail((params["email"] as! String), password: (params["password"] as! String))
      let res = self.paymentController.authentication()
      let arguments = self.checkResult(res)

      self.methodChannel.invokeMethod("onLogin", arguments: arguments)
    }
  }

  public func startPayment(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]
    let inputType = TransactionInputType(
      rawValue: TransactionInputType.RawValue(params["inputType"] as! Int)
    )
    let amount = (params["amount"] as! NSNumber).doubleValue
    let description = params["description"] as! String
    let email = params["receiptEmail"] as? String
    let phone = params["receiptPhone"] as? String
    let singleStepAuth = params["singleStepAuth"] as! Bool
    let ctx = PaymentContext.init()

    ctx.inputType = inputType
    ctx.currency = CurrencyType_RUB
    ctx.amount = amount
    ctx.description = description
    ctx.receiptMail = email
    ctx.receiptPhone = phone

    paymentController.setPaymentContext(ctx)
    paymentController.enable()
    paymentController.setSingleStepAuthentication(singleStepAuth)
  }

  public func startReversePayment(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]
    let amount = (params["amount"] as! NSNumber).doubleValue
    let email = params["receiptEmail"] as? String
    let phone = params["receiptPhone"] as? String
    let singleStepAuth = params["singleStepAuth"] as! Bool

    DispatchQueue.global(qos: .background).async {
      let res = self.paymentController.history(withTransactionID: (params["id"] as! String))
      let arguments = self.checkResult(res)

      if (arguments["errorCode"] as! Int == 0 && !res!.transactions()!.isEmpty) {
        let transactionItem = (res!.transactions().first as! TransactionItem)

        if (
          transactionItem.reverseMode() == TransactionReverseMode_NONE ||
          transactionItem.reverseMode() == TransactionReverseMode_AUTO_REVERSE
        ) {
          self.methodChannel.invokeMethod("onReverseReject", arguments: arguments)
          return
        }

        let ctx = ReversePaymentContext.init()
        ctx.currency = CurrencyType_RUB
        ctx.amountReverse = amount
        ctx.receiptMail = email
        ctx.receiptPhone = phone
        ctx.transaction = transactionItem

        self.paymentController.setPaymentContext(ctx)
        self.paymentController.enable()
        self.paymentController.setSingleStepAuthentication(singleStepAuth)
      } else {
        self.methodChannel.invokeMethod("onHistoryError", arguments: arguments)
      }
    }
  }

  public func startSearchBTDevice(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]
    let readerType = PaymentControllerReaderType_P17

    SwiftIboxproFlutterPlugin.deviceName = params["deviceName"] as! String

    self.paymentController.setReaderType(readerType)
    self.paymentController.search4BTReaders(with: readerType)
  }

  public func stopSearchBTDevice() {
    self.paymentController.stopSearch4BTReaders()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "adjustPayment":
      adjustPayment(call)
      return result(nil)
    case "adjustReversePayment":
      adjustReversePayment(call)
      return result(nil)
    case "cancel":
      cancel()
      return result(nil)
    case "info":
      info(call)
      return result(nil)
    case "login":
      login(call)
      return result(nil)
    case "startPayment":
      startPayment(call)
      return result(nil)
    case "startReversePayment":
      startReversePayment(call)
      return result(nil)
    case "startSearchBTDevice":
      startSearchBTDevice(call)
      return result(nil)
    case "stopSearchBTDevice":
      stopSearchBTDevice()
      return result(nil)
    default:
      return result(FlutterMethodNotImplemented)
    }
  }

  private func checkResult(_ res: APIResult?) -> [String:Any?] {
    var arguments = [
      "errorMessage": nil
    ] as [String:Any?]

    if (res != nil && res!.valid()) {
      arguments["errorCode"] = Int(res!.errorCode())
    } else {
      arguments["errorCode"] = SwiftIboxproFlutterPlugin.apiError
    }

    return arguments
  }

  public static func formatTransactionItem(_ transactionItem: TransactionItem) -> [String:Any] {
    let card = transactionItem.card()

    return [
      "id": transactionItem.id(),
      "rrn": transactionItem.rrn(),
      "emvData": transactionItem.emvData(),
      "date": transactionItem.date(),
      "currencyID": transactionItem.currencyID(),
      "descriptionOfTransaction": transactionItem.descriptionOfTransaction(),
      "stateDisplay": transactionItem.stateDisplay(),
      "invoice": transactionItem.invoice(),
      "approvalCode": transactionItem.approvalCode(),
      "operation": transactionItem.operation(),
      "cardholderName": transactionItem.cardholderName(),
      "terminalName": transactionItem.terminalName(),
      "amount": transactionItem.amount(),
      "amountNetto": transactionItem.amountNetto(),
      "feeTotal": transactionItem.feeTotal(),
      "latitude": transactionItem.latitude(),
      "longitude": transactionItem.longitude(),
      "state": transactionItem.state(),
      "subState": transactionItem.subState(),
      "inputType": Int(transactionItem.inputType().rawValue),
      "displayMode": Int(transactionItem.displayMode().rawValue),
      "acquirerID": transactionItem.acquirerID(),
      "card": [
        "iin": card?.iin(),
        "expiration": card?.expiration(),
        "panMasked": card?.panMasked(),
        "panEnding": card?.panEnding(),
        "binID": card?.binID()
      ]
    ]
  }

  internal class IboxproFlutterDelegate: NSObject, PaymentControllerDelegate {
    private let methodChannel: FlutterMethodChannel
    private let paymentController: PaymentController

    public required init(methodChannel: FlutterMethodChannel, paymentController: PaymentController) {
      self.methodChannel = methodChannel
      self.paymentController = paymentController
    }

    public func disable() {
      self.paymentController.disable()
    }

    public func paymentControllerStartTransaction(_ transactionId: String!) {
      let arguments: [String:String] = [
        "id": transactionId
      ]

      methodChannel.invokeMethod("onPaymentStart", arguments: arguments)
    }

    public func paymentControllerDone(_ transactionData: TransactionData!) {
      let arguments: [String:Any] = [
        "requiredSignature": transactionData.requiredSignature,
        "transaction": SwiftIboxproFlutterPlugin.formatTransactionItem(transactionData.transaction!)
      ]

      disable()

      methodChannel.invokeMethod("onPaymentComplete", arguments: arguments)
    }

    public func paymentControllerError(_ error: PaymentControllerErrorType, message: String?) {
      let arguments: [String:Any] = [
        "nativeErrorType": Int(error.rawValue),
        "errorMessage": message != nil ? message! : ""
      ]

      disable()

      methodChannel.invokeMethod("onPaymentError", arguments: arguments)
    }

    public func paymentControllerReaderEvent(_ event: PaymentControllerReaderEventType) {
      let arguments: [String:Int] = [
        "nativeReaderEventType": Int(event.rawValue)
      ]

      methodChannel.invokeMethod("onReaderEvent", arguments: arguments)
    }

    public func paymentControllerRequestBTDevice(_ devices: [Any]!) {
      let device = (devices as! [BTDevice]).first(where: { $0.name() == SwiftIboxproFlutterPlugin.deviceName })

      if (device != nil) {
        self.paymentController.setBTDevice(device)
        self.paymentController.save(device)
        self.paymentController.stopSearch4BTReaders()

        methodChannel.invokeMethod("onReaderSetBTDevice", arguments: nil)
      }
    }

    public func paymentControllerRequestCardApplication(_ applications: [Any]!) {}
    public func paymentControllerScheduleStepsStart() {}
    public func paymentControllerScheduleStepsCreated(_ scheduleSteps: [Any]!) {}
  }
}
