import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:stream_transform/stream_transform.dart';

import 'events.dart';
import 'types.dart';
import 'entities/entities.dart';

/// Класс для связи с терминалом 2can
/// Дублирует функционал PaymentConroller
/// Класс не имеет возможности работать параллельно в связи с нижележащей имплементацией библиотеки iboxpro
class PaymentController {
  static final MethodChannel _channel = MethodChannel('iboxpro_flutter')
    ..setMethodCallHandler(_handleMethodCall);
  static final StreamController<PaymentEvent> _streamController =
      StreamController<PaymentEvent>.broadcast();

  /// Поток с событиями успешного входа в систему
  static Stream<PaymentLoginEvent> get onLogin =>
      _streamController.stream.whereType<PaymentLoginEvent>();

  /// Поток с событиями начала оплаты с карты (установлена успешная связь между картой и терминалом)
  static Stream<PaymentStartEvent> get onPaymentStart =>
      _streamController.stream.whereType<PaymentStartEvent>();

  /// Поток с событиями завершения оплаты, с данными оплаты и флагом requiredSignature
  static Stream<PaymentCompleteEvent> get onPaymentComplete =>
      _streamController.stream.whereType<PaymentCompleteEvent>();

  /// Поток с событиями завершения операции дополнения оплаты
  static Stream<PaymentAdjustEvent> get onPaymentAdjust =>
      _streamController.stream.whereType<PaymentAdjustEvent>();

  /// Поток с событиями завершения операции дополнения возврата оплаты
  static Stream<PaymentAdjustReverseEvent> get onPaymentAdjustReverse =>
      _streamController.stream.whereType<PaymentAdjustReverseEvent>();

  /// Поток с событиями любой ошибки оплаты
  static Stream<PaymentErrorEvent> get onPaymentError =>
      _streamController.stream.whereType<PaymentErrorEvent>();

  /// Поток с событиями получения информации об оплате
  static Stream<PaymentInfoEvent> get onInfo =>
      _streamController.stream.whereType<PaymentInfoEvent>();

  /// Поток с событиями установки связи и выполнения команд на терминале
  static Stream<PaymentReaderEvent> get onReader =>
      _streamController.stream.whereType<PaymentReaderEvent>();

  /// Поток с событиями установки связи с терминалом
  static Stream<PaymentReaderSetDeviceEvent> get onReaderSetDevice =>
      _streamController.stream.whereType<PaymentReaderSetDeviceEvent>();

  /// Поток с событиями отказа операции возврата оплаты
  static Stream<PaymentRejectReverseEvent> get onRejectReverse =>
      _streamController.stream.whereType<PaymentRejectReverseEvent>();

  /// Производит логин в систему
  static Future<void> login(
      {required String email, required String password}) async {
    await _channel
        .invokeMethod('login', {'email': email, 'password': password});
  }

  /// Начинает операцию принятия оплаты терминалом
  ///
  /// [inputType] вид оплаты, все возможные значения в [InputType]
  /// Важно: Если вход в систему не осуществлен или нет связи с терминалом,
  /// то операция не начнется, при этом ошибки никакой не будет
  static Future<void> startPayment(
      {required double amount,
      required int inputType,
      required String description,
      bool singleStepAuth = true,
      String? receiptEmail,
      String? receiptPhone}) async {
    await _channel.invokeMethod('startPayment', {
      'amount': amount,
      'inputType': inputType,
      'description': description,
      'singleStepAuth': singleStepAuth,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию возврата оплаты терминалом
  ///
  /// [inputType] вид оплаты, все возможные значения в [InputType]
  /// Важно: Если вход в систему не осуществлен или нет связи с терминалом,
  /// то операция не начнется, при этом ошибки никакой не будет
  static Future<void> startReversePayment(
      {required String id,
      required double amount,
      required String description,
      bool singleStepAuth = true,
      String? receiptEmail,
      String? receiptPhone}) async {
    await _channel.invokeMethod('startReversePayment', {
      'id': id,
      'amount': amount,
      'description': description,
      'singleStepAuth': singleStepAuth,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию добавления подписи к оплате терминала
  static Future<void> adjustPayment(
      {required String id,
      required Uint8List signature,
      String? receiptEmail,
      String? receiptPhone}) async {
    await _channel.invokeMethod('adjustPayment', {
      'id': id,
      'signature': signature,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию добавления подписи к оплате терминала
  static Future<void> adjustReversePayment(
      {required String id,
      required Uint8List signature,
      String? receiptEmail,
      String? receiptPhone}) async {
    await _channel.invokeMethod('adjustReversePayment', {
      'id': id,
      'signature': signature,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию по получению информации об оплате
  static Future<void> info({required String id}) async {
    await _channel.invokeMethod('info', {'id': id});
  }

  /// Прерывает операцию принятия оплаты терминалом
  static Future<void> cancel() async {
    await _channel.invokeMethod('cancel');
  }

  /// Начинает операцию поиска терминала с указанным наименованием
  static Future<void> startSearchBTDevice({required String deviceName}) async {
    await _channel
        .invokeMethod('startSearchBTDevice', {'deviceName': deviceName});
  }

  /// Завершает операцию поиска терминала
  static Future<void> stopSearchBTDevice() async {
    await _channel.invokeMethod('stopSearchBTDevice');
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onInfo':
        Map<dynamic, dynamic> arguments = call.arguments;

        _streamController.add(PaymentInfoEvent(
            Result(errorCode: arguments['errorCode']),
            arguments['transaction'] != null
                ? Transaction.fromMap(arguments['transaction'])
                : null));

        break;
      case 'onLogin':
        _streamController.add(
            PaymentLoginEvent(Result(errorCode: call.arguments['errorCode'])));

        break;
      case 'onPaymentStart':
        _streamController.add(PaymentStartEvent(call.arguments['id']));

        break;
      case 'onPaymentError':
        Map<dynamic, dynamic> arguments = call.arguments;
        int type = Platform.isAndroid
            ? ErrorType.fromAndroidType(arguments['nativeErrorType'])
            : ErrorType.fromIosType(arguments['nativeErrorType']);

        _streamController.add(PaymentErrorEvent(PaymentError(
            type: type,
            nativeType: call.arguments['nativeErrorType'],
            message: call.arguments['errorMessage'])));

        break;
      case 'onPaymentComplete':
        _streamController.add(PaymentCompleteEvent(
            Transaction.fromMap(call.arguments['transaction']),
            call.arguments['requiredSignature']));

        break;
      case 'onPaymentAdjust':
        _streamController.add(
            PaymentAdjustEvent(Result(errorCode: call.arguments['errorCode'])));

        break;
      case 'onReaderSetBTDevice':
        _streamController
            .add(PaymentReaderSetDeviceEvent(call.arguments['name']));

        break;
      case 'onReaderEvent':
        Map<dynamic, dynamic> arguments = call.arguments;
        int type = Platform.isAndroid
            ? ReaderEventType.fromAndroidType(
                arguments['nativeReaderEventType'])
            : ReaderEventType.fromIosType(arguments['nativeReaderEventType']);

        _streamController.add(PaymentReaderEvent(ReaderEvent(
            type: type, nativeType: arguments['nativeReaderEventType'])));

        break;
      case 'onReversePaymentAdjust':
        _streamController.add(PaymentAdjustReverseEvent(
            Result(errorCode: call.arguments['errorCode'])));

        break;
      case 'onReverseReject':
        _streamController.add(PaymentRejectReverseEvent());

        break;
      default:
        throw MissingPluginException();
    }
  }
}
