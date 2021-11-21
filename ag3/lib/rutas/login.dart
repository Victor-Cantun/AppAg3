import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'dart:convert';

void main() {
  runApp(LogIn());
}

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SMAPAC",
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      theme: ThemeData(accentColor: Colors.white70),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SharedPreferences sharedPreferences;

  bool _isLoading = false;
  late String nameValue;
  late String lastnameValue;

  final formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  bool _isVisible = false;

  void _toggle() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMAPAC',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      routes: const <String, WidgetBuilder>{},
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 60),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/logo.png',
                                    width: 200,
                                  ),
                                ],
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  child: const Text(
                                    'Inicio de sesión',
                                    style: TextStyle(fontSize: 20),
                                  )),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.email),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minHeight: 32,
                                              minWidth: 32,
                                            ),
                                            labelText: "Correo electrónico"),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Se requiere un correo electrónico';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        obscureText: !_isVisible,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.security),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minHeight: 32,
                                              minWidth: 32,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(_isVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () => _toggle(),
                                            ),
                                            labelText: "Password"),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Se requiere un password';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 60),
                              InkWell(
                                  onTap: () {
                                    if (formkey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      signIn(emailController.text,
                                          passwordController.text);
                                    }
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            'Iniciar',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(5, 171, 232, 1),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        )),
                                  )),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  signIn(String email, pass) async {
    //declara SharedPreferenes dentro de una clase asyn
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass, 'device_name': 'iphone'};
    var jsonResponse = null;

    String url = "";

    var response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/login/operator"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        //Guarda el token en el sharedPreferencez
        prefs.setString("token", jsonResponse['token']);
        prefs.setString("email", email);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }
}
