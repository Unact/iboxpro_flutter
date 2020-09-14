import 'package:meta/meta.dart';

class ReaderEvent {
  int type;
  int nativeType;

  ReaderEvent({
    @required this.type,
    @required this.nativeType
  });
}
