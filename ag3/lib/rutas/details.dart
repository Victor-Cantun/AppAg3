import 'package:ag3/rutas/home.dart';
import 'package:flutter/material.dart';
import 'package:ag3/rutas/home.dart';

class DetailPage extends StatelessWidget {
  final Service services;

  DetailPage(this.services);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del servicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: const <Widget>[
                Text("FECHA:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("15/10/2021"),
                ),
              ],
            ),
            Row(
              children: const <Widget>[
                Text("AGENCIA:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("RIVERA TRANSFER"),
                ),
              ],
            ),
            Row(
              children: const <Widget>[
                Text("TIPO DEL SERVICIO:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("LLEGADA"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("AEROLINEA:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("ALASKA AIRLINES"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("TERMINAL",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("2"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("NUMERO DEL VUELO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("DY 778"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("HORA DE VUELO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("10:45"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("DESTINO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("ALAYA TULUM"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("PASAJERO:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("JOHN VALDEZ"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("NUMERO DE PASAJEROS",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("2"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("PICK UP",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("9:30"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("UNIDAD SOLICITADA",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("SUBURBAM"),
                )
              ],
            ),
            Row(
              children: const <Widget>[
                Text("SERVICIO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(
                  child: Text("LOCAL"),
                )
              ],
            ),
          ],
          //child: Text(services.origin),
        ),
      ),
    );
  }
}
