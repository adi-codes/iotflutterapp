import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  connect() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    var subscription = flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        String s = "LE-Bose SoundSport Free";
        if (r.device.name == s) {
          print("connected1");
          await r.device.connect();
          print("connected2");
        }
      }
    });
  }

  FlutterBlue flutterBlue = FlutterBlue.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RaisedButton(
        onPressed: () {
          connect();
        },
      ),
    );
  }
}
