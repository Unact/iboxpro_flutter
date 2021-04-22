import 'package:flutter/material.dart';

import 'package:iboxpro_flutter/iboxpro_flutter.dart';
import 'package:iboxpro_flutter_example/pages/payment_page.dart';
import 'package:iboxpro_flutter_example/pages/reverse_payment_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _loginEmail = '';
  String _password = '';
  String _deviceName = '';

  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  List<Widget> _buildLoginPart(BuildContext context) {
    return [
      TextFormField(
        initialValue: _loginEmail,
        maxLines: 1,
        decoration: InputDecoration(labelText: 'Логин'),
        onChanged: (val) => _loginEmail = val
      ),
      TextFormField(
        initialValue: _password,
        obscureText: true,
        maxLines: 1,
        decoration: InputDecoration(labelText: 'Пароль'),
        onChanged: (val) => _password = val
      ),
      ElevatedButton(
        child: Text('Войти'),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) => Center(child: CircularProgressIndicator())
          );

          await PaymentController.login(
            email: _loginEmail,
            password: _password,
            onLogin: (Result result) {
              Navigator.pop(context);

              if (result.errorCode == 0) {
                _showSnackBar('Успешно вошли в систему');
              } else {
                _showSnackBar('Произошла ошибка');
              }
            }
          );
        },
      )
    ];
  }

  List<Widget> _buildSearchDevicePart(BuildContext context) {
    return [
      TextFormField(
        initialValue: _deviceName,
        maxLines: 1,
        decoration: InputDecoration(labelText: 'Имя терминала'),
        onChanged: (val) => _deviceName = val
      ),
      ElevatedButton(
        child: Text('Подключиться к терминалу'),
        onPressed: () async {
          await PaymentController.startSearchBTDevice(
            deviceName: _deviceName,
            onReaderSetBTDevice: () async {
              _showSnackBar('Успешно установлена связь с терминалом');
            }
          );
        },
      ),
      ElevatedButton(
        child: Text('Перестать искать терминал'),
        onPressed: () async {
          await PaymentController.stopSearchBTDevice();
          _showSnackBar('Поиск отключен');
        },
      )
    ];
  }

  List<Widget> _buildPaymentPart(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          ElevatedButton(
            child: Text('Оплатить'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage())),
          ),
          ElevatedButton(
            child: Text('Вернуть'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReversePaymentPage())),
          )
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('IboxproFlutter'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: _buildLoginPart(context)
            ..addAll(_buildSearchDevicePart(context))
            ..addAll(_buildPaymentPart(context))
        )
      ),
    );
  }
}
