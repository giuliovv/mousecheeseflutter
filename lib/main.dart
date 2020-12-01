import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> sendCommand(forward, backward, left, right, stop) async {
    var url = 'http://192.168.4.1/data/?sensor_reading={"forward":"'+forward+'",'+'"backward":"'+backward+'","left":"'+left+'","right":"'+right+'","stop":"'+stop+'"}';
    var result = await http.get(url);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
          ],
        ),
      ),
    );
  }
}
