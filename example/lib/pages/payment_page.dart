import 'dart:async';
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
   static List<Map<String, dynamic>> paymentTypes = [
    {'name': 'NFC', 'value': InputType.nfc},
    {'name': 'Link', 'value': InputType.link}
  ];

  final GlobalKey<SignatureState> _sign = GlobalKey<SignatureState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _id;
  bool _requiredSignature = false;
  String _paymentProgressText = 'Оплата не проводилась';
  double? _amount = 50;
  bool _inProgress = false;
  Map<String, dynamic> _paymentType = paymentTypes.first;

  late StreamSubscription<PaymentErrorEvent> _onPaymentErrorSubscription;
  late StreamSubscription<PaymentStartEvent> _onPaymentStartSubscription;
  late StreamSubscription<PaymentReaderEvent> _onReaderSubscription;
  late StreamSubscription<PaymentCompleteEvent> _onPaymentCompleteSubscription;
  late StreamSubscription<PaymentInfoEvent> _onInfoSubscription;
  late StreamSubscription<PaymentAdjustEvent> _onPaymentAdjustSubscription;

  @override
  void initState() {
    super.initState();

    _onPaymentErrorSubscription = PaymentController.onPaymentError.listen((event) {
      PaymentError error = event.error;

      setState(() {
        String fullErrorType = '${error.type}/${error.nativeType}';

        _inProgress = false;
        _showSnackBar('Ошибка(${error.message}) $fullErrorType');
      });
    });
    _onPaymentStartSubscription = PaymentController.onPaymentStart.listen((event) {
      setState(() {
        _id = event.id;
        _paymentProgressText = 'Начало операции оплаты';
      });
    });
    _onReaderSubscription = PaymentController.onReader.listen((event) {
      ReaderEvent readerEvent = event.readerEvent;

      setState(() {
        String fullReaderEventType = '${readerEvent.type}/${readerEvent.nativeType}';
        _paymentProgressText = 'Состояние терминала - $fullReaderEventType';
      });
    });
    _onPaymentCompleteSubscription = PaymentController.onPaymentComplete.listen((event) {
      setState(() {
        _inProgress = false;
        _paymentProgressText = !event.transaction.isNotFinished ? 'Оплата завершена успешно' : 'Ожидание оплаты';
        _id = event.transaction.id;
        _requiredSignature = event.requiredSignature;
        print(event.transaction.toMap());
      });
    });
    _onInfoSubscription = PaymentController.onInfo.listen((event) {
      setState(() {
        _inProgress = false;
      });

      if (event.result.errorCode == 0) {
        if (event.transaction != null) {
          print(event.transaction!.toMap());
        } else {
          _showSnackBar('Оплата не найдена');
        }

        return;
      }

      _showSnackBar('Ошибка ${event.result.errorCode}');
    });
    _onPaymentAdjustSubscription = PaymentController.onPaymentAdjust.listen((event) {
      if (event.result.errorCode == 0) {
        _showSnackBar('Подпись добавлена');
        setState(() {
          _inProgress = false;
          _requiredSignature = false;
        });
      } else {
        _showSnackBar('Ошибка ${event.result.errorCode}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _onPaymentErrorSubscription.cancel();
    _onPaymentStartSubscription.cancel();
    _onReaderSubscription.cancel();
    _onPaymentCompleteSubscription.cancel();
    _onInfoSubscription.cancel();
    _onPaymentAdjustSubscription.cancel();
  }

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
          DropdownButton(
            value: _paymentType,
            items: paymentTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e['name'])
              );
            }).toList(),
            onChanged: (Map<String, dynamic>? value) => setState(() { _paymentType = value!; })
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
                  inputType: _paymentType['value'],
                  description: 'Тестовая оплата',
                  singleStepAuth: true
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

          await PaymentController.adjustPayment(id: _id!, signature: await getSignatureData());
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
                await PaymentController.info(id: _id!);
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
