import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';

const String STA_DEFAULT_SSID = "chair";
const String STA_DEFAULT_PASSWORD = "password";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouse&Cheese',
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> connetti() async {
    WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
        password: STA_DEFAULT_PASSWORD,
        joinOnce: true,
        security: NetworkSecurity.WPA);
  }

  Future<void> sendCommand(forward, backward, left, right, stop) async {
    var url = 'http://192.168.4.1/data/?sensor_reading={"forward":"'+forward.toString()+'",'+'"backward":"'+backward.toString()+'","left":"'+left.toString()+'","right":"'+right.toString()+'","stop":"'+stop.toString()+'"}';
    try {
      var result = await http.get(url);
      if (result.body != "OK") {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('Error: you are probably not be connected to the chair.'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Try to connect',
                onPressed: () {
                  connetti();
                },
              ),
            ));
      }
    } catch (error) {
      _scaffoldKey.currentState.showSnackBar(
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
      key: _scaffoldKey,
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
            OutlineButton(
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
