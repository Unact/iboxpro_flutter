import Flutter
import UIKit

public class SwiftIboxproFlutterPlugin: NSObject, FlutterPlugin {
  private static let apiError = -1
  private let methodChannel: FlutterMethodChannel
  private let paymentControllerDelegate: IboxproFlutterDelegate
  private let paymentController: PaymentController

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
        withTrId: (params["trId"] as! String),
        signature: (params["signature"] as! FlutterStandardTypedData).data,
        receiptEmail: params["receiptEmail"] as? String,
        receiptPhone: params["receiptPhone"] as? String
      )
      let arguments = [
        "errorCode": res != nil && res!.valid() ? Int(res!.errorCode()) : SwiftIboxproFlutterPlugin.apiError
      ]

      self.methodChannel.invokeMethod("onPaymentAdjust", arguments: arguments)
    }
  }

  public func getBTDevice(_ call: FlutterMethodCall) -> [String:String?] {
    let savedDevice = paymentControllerDelegate.savedDevice
    let arguments: [String:String?] = [
      "deviceId": savedDevice?.id(),
      "deviceName": savedDevice?.name()
    ]

    return arguments
  }

  public func info(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]

    DispatchQueue.global(qos: .background).async {
      let res = self.paymentController.history(withTransactionID: (params["trId"] as! String))
      let errorCode = res != nil && res!.valid() ? Int(res!.errorCode()) : SwiftIboxproFlutterPlugin.apiError
      var arguments = [
        "errorCode": errorCode
        ] as [String:Any]

      if errorCode == 0 {
        let transactionItem = res!.transactions().first as! TransactionItem
        let formattedData = SwiftIboxproFlutterPlugin.formatTransactionItem(transactionItem)

        arguments.merge(formattedData) { (current, _) in current }
      }

      self.methodChannel.invokeMethod("onInfo", arguments: arguments)
    }
  }

  public func login(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]

    DispatchQueue.global(qos: .background).async {
      self.paymentController.setEmail((params["email"] as! String), password: (params["password"] as! String))
      let res = self.paymentController.authentication()
      let arguments = [
        "errorCode": res != nil && res!.valid() ? Int(res!.errorCode()) : SwiftIboxproFlutterPlugin.apiError
      ]

      self.methodChannel.invokeMethod("onLogin", arguments: arguments)
    }
  }

  public func setRequestTimeout(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]
    let timeout = params["timeout"] as! Double

    paymentController.setRequestTimeOut(timeout)
  }

  public func startPayment(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]
    let currencyType = CurrencyType(
      rawValue: CurrencyType.RawValue(params["currencyType"] as! Int)
    )
    let inputType = TransactionInputType(
      rawValue: TransactionInputType.RawValue(params["inputType"] as! Int)
    )
    let amount = params["amount"] as! Double
    let description = params["description"] as! String
    let email = params["receiptEmail"] as? String
    let phone = params["receiptPhone"] as? String
    let singleStepAuth = params["singleStepAuth"] as! Bool
    let ctx = PaymentContext.init()

    ctx.inputType = inputType
    ctx.currency = currencyType
    ctx.amount = amount
    ctx.description = description
    ctx.receiptMail = email
    ctx.receiptPhone = phone

    paymentController.setPaymentContext(ctx)
    paymentController.enable()
    paymentController.setSingleStepAuthentication(singleStepAuth)
  }

  public func startSearchBTDevice(_ call: FlutterMethodCall) {
    let params = call.arguments as! [String: Any]
    let readerType = PaymentControllerReaderType(
      rawValue: PaymentControllerReaderType.RawValue(params["readerType"] as! Int)
    )

    paymentController.setReaderType(readerType)
    paymentController.search4BTReaders(with: readerType)
  }

  public func stopSearchBTDevice(_ call: FlutterMethodCall) {
    paymentController.stopSearch4BTReaders()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "adjustPayment":
      adjustPayment(call)
      return result(nil)
    case "getBTDevice":
      return result(getBTDevice(call))
    case "info":
      info(call)
      return result(nil)
    case "login":
      login(call)
      return result(nil)
    case "setRequestTimeout":
      setRequestTimeout(call)
      return result(nil)
    case "startPayment":
      startPayment(call)
      return result(nil)
    case "startSearchBTDevice":
      startSearchBTDevice(call)
      return result(nil)
    case "stopSearchBTDevice":
      stopSearchBTDevice(call)
      return result(nil)
    default:
      return result(FlutterMethodNotImplemented)
    }
  }

  public static func formatTransactionItem(_ transactionItem: TransactionItem) -> [String:Any] {
    let card = transactionItem.card()

    return [
      "id": transactionItem.id(),
      "emvData": transactionItem.emvData(),
      "date": transactionItem.date(),
      "currencyID": transactionItem.currencyID(),
      "descriptionOfTransaction": transactionItem.descriptionOfTransaction(),
      "stateDisplay": transactionItem.stateDisplay(),
      "stateLine1": transactionItem.stateLine1(),
      "stateLine2": transactionItem.stateLine2(),
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
      "reverseMode": Int(transactionItem.reverseMode().rawValue),
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
    public var savedDevice: BTDevice?

    public required init(methodChannel: FlutterMethodChannel, paymentController: PaymentController) {
      self.methodChannel = methodChannel
      self.paymentController = paymentController
    }

    public func paymentControllerStartTransaction(_ transactionId: String!) {
      let arguments: [String:String] = [
        "id": transactionId
      ]

      methodChannel.invokeMethod("onPaymentStart", arguments: arguments)
    }

    public func paymentControllerDone(_ transactionData: TransactionData!) {
      let arguments: [String:Any] = [
        "id": transactionData.id,
        "requiredSignature": transactionData.requiredSignature,
        "transaction": SwiftIboxproFlutterPlugin.formatTransactionItem(transactionData.transaction!)
      ]

      paymentController.disable()

      methodChannel.invokeMethod("onPaymentComplete", arguments: arguments)
    }

    public func paymentControllerError(_ error: PaymentControllerErrorType, message: String?) {
      let arguments: [String:Any] = [
        "errorType": Int(error.rawValue),
        "errorMessage": message != nil ? message! : ""
      ]

      paymentController.disable()

      methodChannel.invokeMethod("onPaymentError", arguments: arguments)
    }

    public func paymentControllerReaderEvent(_ event: PaymentControllerReaderEventType) {
      let arguments: [String:Int] = [
        "readerEventType": Int(event.rawValue)
      ]

      methodChannel.invokeMethod("onReaderEvent", arguments: arguments)
    }

    public func paymentControllerRequestBTDevice(_ devices: [Any]!) {
      let device = (devices as! [BTDevice]).first

      paymentController.setBTDevice(device)
      paymentController.save(device)
      paymentController.stopSearch4BTReaders()

      savedDevice = device

      methodChannel.invokeMethod("onReaderSetBTDevice", arguments: nil)
    }

    public func paymentControllerRequestCardApplication(_ applications: [Any]!) {}
    public func paymentControllerScheduleStepsStart() {}
    public func paymentControllerScheduleStepsCreated(_ scheduleSteps: [Any]!) {}
  }
}
