import 'package:meta/meta.dart';

class Card {
  String iin;
  String binID;
  String expiration;
  String panMasked;
  String panEnding;

  Card({
    @required this.iin,
    @required this.binID,
    @required this.expiration,
    @required this.panMasked,
    @required this.panEnding,
  });

  static Card fromMap(dynamic map) {
    return Card(
      iin: map['iin'],
      binID: map['binID'],
      expiration: map['expiration'],
      panMasked: map['panMasked'],
      panEnding: map['panEnding'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iin': iin,
      'binID': binID,
      'expiration': expiration,
      'panMasked': panMasked,
      'panEnding': panEnding,
    };
  }
}
