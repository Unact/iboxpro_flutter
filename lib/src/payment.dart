import 'types.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// Класс для связи с терминалом 2can
/// Дублирует функционал PaymentConroller на ios
/// Класс не имеет возможности работать параллельно в связи с нижележащей имплементацией библиотеки iboxpro
class PaymentController {
  static final MethodChannel _channel = MethodChannel('iboxpro_flutter')..setMethodCallHandler(_handleMethodCall);

  static Function(Map<dynamic, dynamic>) _onPaymentStart;
  static Function(Map<dynamic, dynamic>) _onPaymentError;
  static Function(Map<dynamic, dynamic>) _onPaymentComplete;
  static Function() _onReaderSetBTDevice;
  static Function(Map<dynamic, dynamic>) _onReaderEvent;
  static Function(Map<dynamic, dynamic>) _onLogin;
  static Function(Map<dynamic, dynamic>) _onInfo;
  static Function(Map<dynamic, dynamic>) _onPaymentAdjust;

  /// Производит логин в систему
  /// [onLogin] вызывается при завершении операции с результатом операции
  static Future<void> login({
    @required String email,
    @required String password,
    Function(Map<dynamic, dynamic>) onLogin
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
    @required double amount,
    @required int inputType,
    @required String description,
    bool singleStepAuth = false,
    String receiptEmail,
    String receiptPhone,
    Function(Map<dynamic, dynamic>) onPaymentStart,
    Function(Map<dynamic, dynamic>) onPaymentError,
    Function(Map<dynamic, dynamic>) onPaymentComplete,
    Function(Map<dynamic, dynamic>) onReaderEvent
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

  /// Начинает операцию добавления подписи к оплате терминала
  ///
  /// [onPaymentAdjust] вызывается по завершению операции с результатом операции
  static Future<void> adjustPayment({
    @required String trId,
    @required Uint8List signature,
    String receiptEmail,
    String receiptPhone,
    Function(Map<dynamic, dynamic>) onPaymentAdjust
  }) async {
    _onPaymentAdjust = onPaymentAdjust;
    await _channel.invokeMethod('adjustPayment', {
      'trId': trId,
      'signature': signature,
      'receiptEmail': receiptEmail,
      'receiptPhone': receiptPhone
    });
  }

  /// Начинает операцию по получению информации об оплате
  ///
  /// [onInfo] вызывается по завершению операции с результатом операции
  static Future<void> info({
    @required String trId,
    Function(Map<dynamic, dynamic>) onInfo
  }) async {
    _onInfo = onInfo;
    await _channel.invokeMethod('info', {
      'trId': trId
    });
  }

  /// Прерывает операцию принятия оплаты терминалом
  ///
  /// [onInfo] вызывается по завершению операции с результатом операции
  static Future<void> cancel() async {
    await _channel.invokeMethod('cancel');
  }

  /// Начинает операцию поиска терминала
  ///
  /// [onReaderSetBTDevice] вызывается по завершению операции с результатом операции
  ///
  /// Важно: [iOS] Всегда выбирает первый найденный терминал
  static Future<void> startSearchBTDevice({
    @required String deviceAddress,
    Function() onReaderSetBTDevice
  }) async {
    _onReaderSetBTDevice = onReaderSetBTDevice;

    await _channel.invokeMethod('startSearchBTDevice', {
      'deviceAddress': deviceAddress
    });
  }

  /// Завершает операцию поиска терминала
  static Future<void> stopSearchBTDevice() async {
    await _channel.invokeMethod('stopSearchBTDevice');
  }

  /// Устанавливает таймаут для операций с АПИ iboxpro
  static Future<void> setRequestTimeout({
    @required int timeout
  }) async {
    await _channel.invokeMethod('setRequestTimeout', {
      'timeout': timeout
    });
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onLogin':
        if (_onLogin != null) {
          _onLogin(call.arguments);
        }

        break;
      case 'onInfo':
        if (_onInfo != null) {
          _onInfo(call.arguments);
        }

        break;
      case 'onPaymentStart':
        if (_onPaymentStart != null) {
          _onPaymentStart(call.arguments);
        }

        break;
      case 'onPaymentError':
        if (_onPaymentError != null) {
          Map<dynamic, dynamic> arguments = call.arguments;
          arguments['errorType'] = Platform.isAndroid ?
            ErrorType.fromAndroidType(arguments['nativeErrorType']) :
            ErrorType.fromIosType(arguments['nativeErrorType']);

          _onPaymentError(call.arguments);
        }

        break;
      case 'onPaymentComplete':
        if (_onPaymentComplete != null) {
          _onPaymentComplete(call.arguments);
        }

        break;
      case 'onPaymentAdjust':
        if (_onPaymentAdjust != null) {
          _onPaymentAdjust(call.arguments);
        }

        break;
      case 'onReaderSetBTDevice':
        if (_onReaderSetBTDevice != null) {
          _onReaderSetBTDevice();
        }

        break;
      case 'onReaderEvent':
        if (_onReaderEvent != null) {
          Map<dynamic, dynamic> arguments = call.arguments;
          arguments['readerEventType'] = Platform.isAndroid ?
            ReaderEventType.fromAndroidType(arguments['nativeReaderEventType']) :
            ReaderEventType.fromIosType(arguments['nativeReaderEventType']);

          _onReaderEvent(call.arguments);
        }

        break;
      default:
        throw MissingPluginException();
    }
  }
}
