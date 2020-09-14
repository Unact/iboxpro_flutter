import 'package:meta/meta.dart';

import 'card.dart';

class Transaction {
  String id;
  String rrn;
  Map<dynamic, dynamic> emvData;
  String date;
  String currencyID;
  String descriptionOfTransaction;
  String stateDisplay;
  String invoice;
  String approvalCode;
  String operation;
  String cardholderName;
  String terminalName;
  double amount;
  double amountNetto;
  double feeTotal;
  double latitude;
  double longitude;
  int state;
  int subState;
  int inputType;
  int displayMode;
  String acquirerID;
  Card card;

  Transaction({
    @required this.id,
    @required this.rrn,
    @required this.emvData,
    @required this.date,
    @required this.currencyID,
    @required this.descriptionOfTransaction,
    @required this.stateDisplay,
    @required this.invoice,
    @required this.approvalCode,
    @required this.operation,
    @required this.cardholderName,
    @required this.terminalName,
    @required this.amount,
    @required this.amountNetto,
    @required this.feeTotal,
    @required this.latitude,
    @required this.longitude,
    @required this.state,
    @required this.subState,
    @required this.inputType,
    @required this.displayMode,
    @required this.acquirerID,
    @required this.card,
  });

  static Transaction fromMap(dynamic map) {
    return Transaction(
      id: map['id'],
      rrn: map['rrn'],
      emvData: map['emvData'],
      date: map['date'],
      currencyID: map['currencyID'],
      descriptionOfTransaction: map['descriptionOfTransaction'],
      stateDisplay: map['stateDisplay'],
      invoice: map['invoice'],
      approvalCode: map['approvalCode'],
      operation: map['operation'],
      cardholderName: map['cardholderName'],
      terminalName: map['terminalName'],
      amount: map['amount'],
      amountNetto: map['amountNetto'],
      feeTotal: map['feeTotal'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      state: map['state'],
      subState: map['subState'],
      inputType: map['inputType'],
      displayMode: map['displayMode'],
      acquirerID: map['acquirerID'],
      card: map['card'] != null ? Card.fromMap(map['card']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rrn': rrn,
      'emvData': emvData,
      'date': date,
      'currencyID': currencyID,
      'descriptionOfTransaction': descriptionOfTransaction,
      'stateDisplay': stateDisplay,
      'invoice': invoice,
      'approvalCode': approvalCode,
      'operation': operation,
      'cardholderName': cardholderName,
      'terminalName': terminalName,
      'amount': amount,
      'amountNetto': amountNetto,
      'feeTotal': feeTotal,
      'latitude': latitude,
      'longitude': longitude,
      'state': state,
      'subState': subState,
      'inputType': inputType,
      'displayMode': displayMode,
      'acquirerID': acquirerID,
      'card': card != null ? card.toMap() : null,
    };
  }

  @override
  String toString() => 'Transaction { id: $id }';
}
