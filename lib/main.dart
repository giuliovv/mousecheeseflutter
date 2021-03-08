import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:udp/udp.dart';

const String STA_DEFAULT_SSID = "chair";
const String STA_DEFAULT_PASSWORD = "password";
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouse&Cheese',
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mouse & Cheese'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> connetti() async {
    WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
        password: STA_DEFAULT_PASSWORD,
        joinOnce: true,
        security: NetworkSecurity.WPA);
  }

  Future<void> sendCommand(forward, backward, left, right, stop) async {
    var multicastEndpoint2 = Endpoint.multicast(InternetAddress("192.168.4.2"), port: Port(4210));
    var multicastEndpoint3 = Endpoint.multicast(InternetAddress("192.168.4.3"), port: Port(4210));
    var sender = await UDP.bind(Endpoint.any(port: Port(65000)));
    var stringToSend = '{"forward":"'+forward.toString()+'",'+'"backward":"'+backward.toString()+'","left":"'+left.toString()+'","right":"'+right.toString()+'","stop":"'+stop.toString()+'"}';
    try {
      await sender.send(stringToSend.codeUnits,
          multicastEndpoint2);
      await sender.send(stringToSend.codeUnits,
          multicastEndpoint3);
    } catch (error) {
      scaffoldMessengerKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Error: ' + error.toString()),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Try to connect',
              onPressed: () {
                connetti();
              },
            ),
          ));
    }
    sender.close();
  }

  @override
  void initState() {
    super.initState();
    // NOTE: Calling this function here would crash the app.
    connetti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Mouse&Cheese",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 100.0),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
              tooltip: 'Forward',
              onPressed: () {
                sendCommand(1,0,0,0,0);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                  tooltip: 'Left',
                  onPressed: () {
                    sendCommand(0,0,1,0,0);
                  },
                ),
                SizedBox(width: 50.0),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  tooltip: 'Right',
                  onPressed: () {
                    sendCommand(0,0,0,1,0);
                  },
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
              tooltip: 'Backward',
              onPressed: () {
                sendCommand(0,1,0,0,0);
              },
            ),
            SizedBox(height: 50.0),
            OutlinedButton(
              onPressed: () {
                sendCommand(0,0,0,0,1);
              },
              child: Text(
                  "Stop",
                  style: TextStyle(
                    color: Colors.white,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
