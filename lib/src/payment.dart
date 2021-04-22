import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'types.dart';
import 'entities/entities.dart';

/// Класс для связи с терминалом 2can
/// Дублирует функционал PaymentConroller на ios
/// Класс не имеет возможности работать параллельно в связи с нижележащей имплементацией библиотеки iboxpro
class PaymentController {
  static final MethodChannel _channel = MethodChannel('iboxpro_flutter')..setMethodCallHandler(_handleMethodCall);

  static Function(String)? _onPaymentStart;
  static Function(PaymentError)? _onPaymentError;
  static Function(Transaction, bool)? _onPaymentComplete;
  static Function()? _onReaderSetBTDevice;
  static Function(ReaderEvent)? _onReaderEvent;
  static Function(Result)? _onLogin;
  static Function(Result, Transaction?)? _onInfo;
  static Function(Result)? _onPaymentAdjust;
  static Function(Result)? _onHistoryError;
  static Function()? _onReverseReject;
  static Function(Result)? _onReversePaymentAdjust;

  /// Производит логин в систему
  /// [onLogin] вызывается при завершении операции с результатом операции
  static Future<void> login({
    required String email,
    required String password,
    required Function(Result) onLogin
  }) async {
    _onLogin = onLogin;

    await _channel.invokeMethod('login', {
      'email': email,
      'password': password
    });
  }

  /// Начинает операцию принятия оплаты терминалом
  ///
  /// [inputType] вид оплаты, все возможные значения в [InputType]
  ///
  /// [onPaymentStart] вызывается когда началась оплата с карты (установлена успешная связь между картой и терминалом)
  ///
  /// [onPaymentError] вызывается при любой ошибке оплаты
  ///
  /// [onPaymentComplete] вызывается по завершению оплаты, с данными оплаты и флагом requiredSignature,
  /// если флаг установлен то требуется вызывать метод [PaymentController.adjustPayment]
  ///
  /// [onReaderEvent] вызывается при установки связи и выполнения команд на терминале
  ///
  /// Важно: Если вход в систему не осуществлен или нет связи с терминалом,
  /// то операция не начнется, при этом ошибки никакой не будет
  static Future<void> startPayment({
    required double amount,
    required int inputType,
    required String description,
    bool singleStepAuth = false,
    String? receiptEmail,
    String? receiptPhone,
    required Function(String) onPaymentStart,
    required Function(PaymentError) onPaymentError,
    required Function(Transaction, bool) onPaymentComplete,
    required Function(ReaderEvent) onReaderEvent
  }) async {
    _onPaymentStart = onPaymentStart;
    _onPaymentError = onPaymentError;
    _onPaymentComplete = onPaymentComplete;
    _onReaderEvent = onReaderEvent;

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
  ///
  /// [onPaymentStart] вызывается когда началась оплата с карты (установлена успешная связь между картой и терминалом)
  ///
  /// [onPaymentError] вызывается при любой ошибке оплаты
  ///
  /// [onPaymentComplete] вызывается по завершению оплаты, с данными оплаты и флагом requiredSignature,
  /// если флаг установлен то требуется вызывать метод [PaymentController.adjustPayment]
  ///
  /// [onReaderEvent] вызывается при установки связи и выполнения команд на терминале
  ///
  //////
  /// [onHistoryError] вызывается при ошибке получения информации о транзакции
  ///
  /// Важно: Если вход в систему не осуществлен или нет связи с терминалом,
  /// то операция не начнется, при этом ошибки никакой не будет
  static Future<void> startReversePayment({
    required String id,
    required double amount,
    required int inputType,
    required String description,
    bool singleStepAuth = false,
    String? receiptEmail,
    String? receiptPhone,
    required Function(String) onPaymentStart,
    required Function(PaymentError) onPaymentError,
    required Function(Transaction, bool) onPaymentComplete,
    required Function(ReaderEvent) onReaderEvent,
    required Function(Result) onHistoryError,
    required Function() onReverseReject
  }) async {
    _onPaymentStart = onPaymentStart;
    _onPaymentError = onPaymentError;
    _onPaymentComplete = onPaymentComplete;
    _onReaderEvent = onReaderEvent;
    _onHistoryError = onHistoryError;
    _onReverseReject = onReverseReject;

    await _channel.invokeMethod('startReversePayment', {
      'id': id,
      'amount': amount,
      'inputType': inputType,
      'description': description,
      'singleStepAuth': singleStepAuth,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию добавления подписи к оплате терминала
  ///
  /// [onPaymentAdjust] вызывается по завершению операции с результатом операции
  static Future<void> adjustPayment({
    required String id,
    required Uint8List signature,
    String? receiptEmail,
    String? receiptPhone,
    required Function(Result) onPaymentAdjust
  }) async {
    _onPaymentAdjust = onPaymentAdjust;
    await _channel.invokeMethod('adjustPayment', {
      'id': id,
      'signature': signature,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию добавления подписи к оплате терминала
  ///
  /// [onPaymentAdjust] вызывается по завершению операции с результатом операции
  static Future<void> adjustReversePayment({
    required String id,
    required Uint8List signature,
    String? receiptEmail,
    String? receiptPhone,
    required Function(Result) onReversePaymentAdjust
  }) async {
    _onReversePaymentAdjust = onReversePaymentAdjust;
    await _channel.invokeMethod('adjustReversePayment', {
      'id': id,
      'signature': signature,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию по получению информации об оплате
  ///
  /// [onInfo] вызывается по завершению операции с результатом операции
  static Future<void> info({
    required String id,
    required Function(Result, Transaction?) onInfo
  }) async {
    _onInfo = onInfo;
    await _channel.invokeMethod('info', {
      'id': id
    });
  }

  /// Прерывает операцию принятия оплаты терминалом
  static Future<void> cancel() async {
    await _channel.invokeMethod('cancel');
  }

  /// Начинает операцию поиска терминала с указанным наименованием
  ///
  /// [onReaderSetBTDevice] вызывается по завершению операции с результатом операции
  static Future<void> startSearchBTDevice({
    required String deviceName,
    required Function() onReaderSetBTDevice
  }) async {
    _onReaderSetBTDevice = onReaderSetBTDevice;

    await _channel.invokeMethod('startSearchBTDevice', {
      'deviceName': deviceName
    });
  }

  /// Завершает операцию поиска терминала
  static Future<void> stopSearchBTDevice() async {
    await _channel.invokeMethod('stopSearchBTDevice');
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onHistoryError':
        if (_onHistoryError != null) {
          _onHistoryError!(Result(errorCode: call.arguments['errorCode']));
        }

        break;
      case 'onInfo':
        if (_onInfo != null) {
          Map<dynamic, dynamic> arguments = call.arguments;
          _onInfo!(
            Result(errorCode: arguments['errorCode']),
            arguments['transaction'] != null ? Transaction.fromMap(arguments['transaction']) : null
          );
        }

        break;
      case 'onLogin':
        if (_onLogin != null) {
          _onLogin!(Result(errorCode: call.arguments['errorCode']));
        }

        break;
      case 'onPaymentStart':
        if (_onPaymentStart != null) {
          _onPaymentStart!(call.arguments['id']);
        }

        break;
      case 'onPaymentError':
        if (_onPaymentError != null) {
          Map<dynamic, dynamic> arguments = call.arguments;
          int type = Platform.isAndroid ?
            ErrorType.fromAndroidType(arguments['nativeErrorType']) :
            ErrorType.fromIosType(arguments['nativeErrorType']);

          _onPaymentError!(PaymentError(
            type: type,
            nativeType: call.arguments['nativeErrorType'],
            message: call.arguments['errorMessage']
          ));
        }

        break;
      case 'onPaymentComplete':
        if (_onPaymentComplete != null) {
          _onPaymentComplete!(Transaction.fromMap(call.arguments['transaction']), call.arguments['requiredSignature']);
        }

        break;
      case 'onPaymentAdjust':
        if (_onPaymentAdjust != null) {
          _onPaymentAdjust!(Result(errorCode: call.arguments['errorCode']));
        }

        break;
      case 'onReaderSetBTDevice':
        if (_onReaderSetBTDevice != null) {
          _onReaderSetBTDevice!();
        }

        break;
      case 'onReaderEvent':
        if (_onReaderEvent != null) {
          Map<dynamic, dynamic> arguments = call.arguments;
          int type = Platform.isAndroid ?
            ReaderEventType.fromAndroidType(arguments['nativeReaderEventType']) :
            ReaderEventType.fromIosType(arguments['nativeReaderEventType']);
          _onReaderEvent!(ReaderEvent(type: type, nativeType: arguments['nativeReaderEventType']));
        }

        break;
      case 'onReversePaymentAdjust':
        if (_onReversePaymentAdjust != null) {
          _onReversePaymentAdjust!(Result(errorCode: call.arguments['errorCode']));
        }

        break;
      case 'onReverseReject':
        if (_onReverseReject != null) {
          _onReverseReject!();
        }

        break;
      default:
        throw MissingPluginException();
    }
  }
}
