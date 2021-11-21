import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:ag3/rutas/login.dart';
import 'package:ag3/rutas/home.dart';
import 'package:ag3/rutas/details.dart';

void main() => runApp(Home());

class Service {
  //int idservice;
  String idservice, origin, pickup;

  Service(this.idservice, this.origin, this.pickup);
  Service.fromJson(Map<String, dynamic> json)
      : idservice = json['register']['id'].toString(),
        origin = json['register']['origin'].toString(),
        pickup = json['register']['pickup'].toString();
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SMAPAC",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(accentColor: Colors.white70),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mytoken = "";
  String email = "";
  String name = "";

  late List<Service> services;
  ////SharedPreferences prefs = await SharedPreferences.getInstance();
  @override
  void initState() {
    checkLoginStatus();
    services = [];
    _loadServices();
    super.initState();
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //sharedPreferences = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LogIn()),
          (Route<dynamic> route) => false);
    }

    setState(() {
      mytoken = prefs.getString("token").toString();
      email = prefs.getString("email").toString();
      showUser();
    });
  }

  showUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Map data = {'email': email};
    var jsonResponse = null;
    String url = "http://127.0.0.1:8000/api/operator/me";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $mytoken'
    };
    final msg = jsonEncode({"email": email});

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      //print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      setState(() {
        name = jsonResponse['data']['name'] +
            " " +
            jsonResponse['data']['paterno'];
      });
      //print('Response: ${name}');
      //if (jsonResponse != null) {}
    }
  }

  void _loadServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = "";
    var myjson = null;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $mytoken'
    };
    //final msg = jsonEncode({"email": email});

    final myresponse = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/services"),
      headers: headers,
    );

    if (myresponse.statusCode == 200) {
      myjson = json.decode(myresponse.body);
      //print('my json body: ${myresponse.body}');
      List<Service> _services = [];
      for (var jsonService in myjson['data']) {
        _services.add(Service.fromJson(jsonService));
        //print('$jsonService');
      }
      //print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      setState(() {
        services = _services;
      });
      //print('Response: ${name}');
      //if (jsonResponse != null) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    //var mytoken2 = mytoken;
    //String email = "cantundominguez@gmail.com";
    // String name = "Victor Cantún";

    return Scaffold(
      appBar: AppBar(
        title: const Text("AG3", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              salir();

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => LogIn()),
                  (Route<dynamic> route) => false);
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          // print("hola ${services[index].origin} ");
          return GestureDetector(
            child: Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 236, 235, 1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(height: 120),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Origin: ${services[index].origin}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )),
                              Text('Destino',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )),
                              Text('PickUp',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )),
                              Text('Hora de salida',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                          flex: 2,
                        ),
                        Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const <Widget>[
                                Text('estatus',
                                    style: TextStyle(
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                            flex: 2)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(services[index])));
            },
          );
        },
        itemCount: services.length,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
            ),
            ListTile(
              title: Text("Servicios"),
              onTap: () {},
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  salir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.commit();
  }
}
