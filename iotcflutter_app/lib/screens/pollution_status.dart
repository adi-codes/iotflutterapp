import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PollutionStatus extends StatefulWidget {
  @override
  _PollutionStatusState createState() => _PollutionStatusState();
}

class _PollutionStatusState extends State<PollutionStatus> {
  Position position;
  int aqi = 0;
  bool clicked = false;
  String city='';
  String name='';
  String country='';
  String temp=' ';
  String pressure='';
  String humidity=' ';

  void sendApi() async {
    LocationPermission permission = await requestPermission();
    print("permission.toString() : ${permission.index}");
    if(permission.toString() != "denied")
      position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    var url3 = "https://api.ambeedata.com/latest/by-city?city=chennai";
//    var url4 = "http://api.airpollutionapi.com/1.0/aqi?lat=${position.latitude}&lon=${position.longitude}&APPID=tiftmn0de7s76c7m7diptaftev";
    var url5 = "http://api.airvisual.com/v2/nearest_city?lat=${position.latitude}&lon=${position.longitude}&key=6fac6137-fe25-4b41-8b9f-04f8b18fbf43";
    var response = await http.get(url5);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
//      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $jsonResponse');
      print(jsonResponse["data"]["current"]["pollution"]["aqius"]);
      print(jsonResponse["data"]["country"]);
      print(jsonResponse["data"]["city"]);
      print(jsonResponse["data"]["current"]["weather"]["tp"]);
      setState(() {
        aqi = jsonResponse["data"]["current"]["pollution"]["aqius"];
        name= jsonResponse["data"]["name"];
        city= jsonResponse["data"]["city"];
        country =jsonResponse["data"]["country"];
        temp =(jsonResponse["data"]["current"]["weather"]["tp"]).toString();
        pressure =(jsonResponse["data"]["current"]["weather"]["pr"]).toString();
        humidity =(jsonResponse["data"]["current"]["weather"]["hu"]).toString();
        });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title:
      Text(
          'AIR QUALITY INDEX')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.3,
          ),
          if(!clicked)
            Center(
              child: RaisedButton(
                child: Text("Pollution status"),
                onPressed: (){
                  sendApi();
                  setState(() {
                    clicked = true;
                  });
                },
              ),
            ),

          if(clicked && aqi != 0)
            Center(
              child: Column(
                children: [
                  Container(

                    child: Text(
                      "The pollution AQI at your location is:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      aqi.toString(),
                      style: TextStyle(
                        fontSize: 50,

                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      city,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      city,
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      country,
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),
                 SizedBox(height: 20),
                 Container(
                    child: Text(
                     'Temperature: '+temp.toString()+'° Celcius',
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Air pressure: '+pressure.toString()+' hPa',
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Humidity: '+humidity.toString()+' %',
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),
                  /*
                  Container(
                    child: Text(
                      state,
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'country',
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ),

                  */
                ],
              ),
            )
        ],
      ),
    );
  }
}

