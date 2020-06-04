import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:menuapp/models/auth_result.dart';
import 'package:menuapp/screens/select_table.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

String SERVER_URL = '';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  final _ipaddressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hasLoggedIn();
  }

  void hasLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool status = sharedPreferences.getBool('login') ?? false;

    if (status) {
      // daha önceden login olmuş, bu bilgileri al ve giriş yap
      _ipaddressController.text = sharedPreferences.getString('ipaddress');
      _usernameController.text = sharedPreferences.getString('username');
      _passwordController.text = sharedPreferences.getString('password');

      // post içinde loading işlemleri var
      postRequest(_usernameController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _ipaddressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  postRequest(String username, String password) async {
    setState(() {
      isLoading = true;
    });

    Map data = {
      'username': username,
      'password': password,
    };

    var body = json.encode(data);
    var response = await http.post(
        'https://telgrafla.com/api/index.php?q=login',
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));

      AuthResult result = AuthResult.fromJson(responseData);

      if (result.status == 1) {
        // login başarılı

        // kullanıcıyı kaydet
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setBool('login', true);
        sharedPreferences.setString('ipaddress', _ipaddressController.text);
        sharedPreferences.setString('username', _usernameController.text);
        sharedPreferences.setString('password', _passwordController.text);

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: SelectTablePage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Giriş başarısız!",
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            );
          },
        );
      }
    } else {
      throw Exception('Failed to load login information');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: SafeArea(
          child: this.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Bilgiler kontrol ediliyor...',
                          style: TextStyle(fontSize: 20))
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Oturum Aç",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: new InputDecoration(
                            hintText: '192.168.1.x',
                            labelText: 'IP Adres / URL',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Sunucu ip adresini girin';
                            }
                            return null;
                          },
                          controller: _ipaddressController,
                        ),
                        TextFormField(
                          decoration: new InputDecoration(
                            hintText: 'Kullanıcı adı',
                            labelText: 'Kullanıcı adı',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Kullanıcı adınızı girin';
                            }
                            return null;
                          },
                          controller: _usernameController,
                        ),
                        TextFormField(
                          decoration: new InputDecoration(
                            hintText: 'Şifre',
                            labelText: 'Şifre',
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => Form.of(context).save(),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Şifrenizi girin';
                            }
                            return null;
                          },
                          controller: _passwordController,
                        ),
                        SizedBox(height: 25),
                        Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: 1.75,
                          child: ButtonTheme(
                            minWidth: 225,
                            height: 40,
                            child: RaisedButton(
                                onPressed: () {
                                  postRequest(_usernameController.text,
                                      _passwordController.text);
                                },
                                color: Colors.pink,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("Giriş Yap",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              'v1.0',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
