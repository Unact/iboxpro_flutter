import 'entities/entities.dart';

class PaymentEvent {
  PaymentEvent();
}

class PaymentErrorEvent extends PaymentEvent {
  final PaymentError error;

  PaymentErrorEvent(this.error);
}

class PaymentLoginEvent extends PaymentEvent {
  final Result result;

  PaymentLoginEvent(this.result);
}

class PaymentStartEvent extends PaymentEvent {
  final String id;

  PaymentStartEvent(this.id);
}

class PaymentCompleteEvent extends PaymentEvent {
  final Transaction transaction;
  final bool requiredSignature;

  PaymentCompleteEvent(this.transaction, this.requiredSignature);
}

class PaymentAdjustEvent extends PaymentEvent {
  final Result result;

  PaymentAdjustEvent(this.result);
}

class PaymentAdjustReverseEvent extends PaymentEvent {
  final Result result;

  PaymentAdjustReverseEvent(this.result);
}

class PaymentInfoEvent extends PaymentEvent {
  final Result result;
  final Transaction? transaction;

  PaymentInfoEvent(this.result, this.transaction);
}

class PaymentReaderEvent extends PaymentEvent {
  final ReaderEvent readerEvent;

  PaymentReaderEvent(this.readerEvent);
}

class PaymentReaderSetDeviceEvent extends PaymentEvent {
  final String deviceName;

  PaymentReaderSetDeviceEvent(this.deviceName);
}

class PaymentRejectReverseEvent extends PaymentEvent {
  PaymentRejectReverseEvent();
}
