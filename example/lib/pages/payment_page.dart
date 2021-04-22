import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:iboxpro_flutter/iboxpro_flutter.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPage createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  final GlobalKey<SignatureState> _sign = GlobalKey<SignatureState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _id;
  bool _requiredSignature = false;
  String _paymentProgressText = 'Оплата не проводилась';
  double? _amount = 50;
  bool _inProgress = false;

  Future<Uint8List> getSignatureData() async {
    SignatureState? sign = _sign.currentState;
    ByteData? data = (await (await sign!.getData()).toByteData(format: ImageByteFormat.png));

    return data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  List<Widget> _buildPaymentPart(BuildContext context) {
    return [
      Column(
        children: [
          TextField(
            maxLines: 1,
            decoration: InputDecoration(labelText: 'ID'),
            controller: TextEditingController(text: _id),
            onChanged: (value) => _id = value,
          ),
          TextFormField(
            maxLines: 1,
            decoration: InputDecoration(labelText: 'Сумма оплаты'),
            initialValue: _amount.toString(),
            onChanged: (val) => _amount = double.tryParse(val),
          ),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              child: Text('Оплатить'),
              onPressed: () async {
                setState(() {
                  _id = null;
                  _paymentProgressText = 'Ожидание';
                  _inProgress = true;
                });

                await PaymentController.startPayment(
                  amount: _amount!,
                  inputType: InputType.NFC,
                  description: 'Тестовая оплата',
                  singleStepAuth: true,
                  onPaymentError: (PaymentError error) {
                    setState(() {
                      String fullErrorType = '${error.type}/${error.nativeType}';

                      _inProgress = false;
                      _showSnackBar('Ошибка(${error.message}) $fullErrorType');
                    });
                  },
                  onPaymentStart: (String val) {
                    setState(() {
                      _id = val;
                      _paymentProgressText = 'Начало операции оплаты';
                    });
                  },
                  onReaderEvent: (ReaderEvent event) {
                    setState(() {
                      String fullReaderEventType = '${event.type}/${event.nativeType}';
                      _paymentProgressText = 'Состояние терминала - $fullReaderEventType';
                    });
                  },
                  onPaymentComplete: (Transaction transaction, bool requiredSignature) {
                    setState(() {
                      _inProgress = false;
                      _showSnackBar('Оплата завершена успешно');
                      _id = transaction.id;
                      _requiredSignature = requiredSignature;
                      print(transaction);
                    });
                  }
                );
              },
            )
          ),
          !_inProgress ? Container() : SizedBox(
            width: 150,
            child: ElevatedButton(
              child: Text('Отмена'),
              onPressed: () async {
                await PaymentController.cancel();
                setState(() {
                  _id = null;
                  _paymentProgressText = 'Ожидание';
                  _inProgress = false;
                });
              }
            )
          )
        ]
      )
    ];
  }

  List<Widget> _buildPaymentSignaturePart(BuildContext context) {
    if (!_requiredSignature)
      return [Container()];

    return [
      ElevatedButton(
        child: Text('Добавить подпись'),
        onPressed: () async {
          setState(() {
            _inProgress = true;
          });

          await PaymentController.adjustPayment(
            id: _id!,
            signature: await getSignatureData(),
            onPaymentAdjust: (Result result) {
              if (result.errorCode == 0) {
                _showSnackBar('Подпись добавлена');
                setState(() {
                  _inProgress = false;
                  _requiredSignature = false;
                });
              } else {
                _showSnackBar('Ошибка ${result.errorCode}');
              }
            }
          );
      }),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
        ),
        child: SizedBox(
          height: 200,
          width: 200,
          child: Signature(key: _sign, strokeWidth: 5)
        )
      )
    ];
  }

  List<Widget> _buildPaymentInfoPart(BuildContext context) {
    if (_id == null)
      return [Container()];

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              child: Text('Информация об оплате'),
              onPressed: () async {
                setState(() {
                  _inProgress = true;
                });
                await PaymentController.info(
                  id: _id!,
                  onInfo: (Result result, Transaction? transaction) {
                    setState(() {
                      _inProgress = false;
                    });

                    if (result.errorCode == 0) {
                      if (transaction != null) {
                        print(transaction.toMap());
                      } else {
                        _showSnackBar('Оплата не найдена');
                      }

                      return;
                    }

                    _showSnackBar('Ошибка ${result.errorCode}');
                  }
                );
              }
            )
          )
        ]
      )
    ];
  }

  List<Widget> _buildStatusPart(BuildContext context) {
    if (!_inProgress) return [Container()];

    return [
      Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          children: <Widget>[
            Text('Статус оплаты'),
            SizedBox(height: 10),
            Text(_paymentProgressText, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10)
          ]
        )
      )
    ];
  }

  List<Widget> _buildProgressPart(BuildContext context) {
    if (!_inProgress) return [Container()];

    return [
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white70,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          )
        )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Оплата'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: _buildPaymentPart(context)
            ..addAll(_buildProgressPart(context))
            ..addAll(_buildStatusPart(context))
            ..addAll(_buildPaymentSignaturePart(context))
            ..addAll(_buildPaymentInfoPart(context))
        )
      ),
    );
  }
}
