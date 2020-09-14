import 'package:meta/meta.dart';

class PaymentError {
  int type;
  int nativeType;
  String message;

  PaymentError({
    @required this.type,
    @required this.nativeType,
    @required this.message
  });
}
