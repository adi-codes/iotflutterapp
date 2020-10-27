import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'pollution_status.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:iotcflutter_app/customizedNotification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firebaseReference = FirebaseDatabase.instance.reference();

  String t='';
  int _counter = 10;
  String formattedDate='';
  String formattedNow='';
  int chk=1;
  int perc=50;
  int f=0;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState(){
    super.initState();
    _messaging.getToken().then((value) {
      print(value);
    });
    checkConn();
    _messaging.subscribeToTopic("pushNotifications");
  }
  /*
  Future<void> getCounterValue() async {
    Map<dynamic, dynamic> m = new HashMap();
    m = (await firebaseReference.child("var").once()).value;
    setState(() {
      _counter = m["var"];
    });
  }*/

  void _incrementCounter() {
    setState(() {
      _counter=10;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('IOT Counter App'),
          actions: [
            RaisedButton.icon(onPressed: checkConn, icon:Icon(Icons.refresh) , label:Text(''),padding: EdgeInsets.all(6),color: Colors.blue,),

          ],
          centerTitle: true,
        ),
        body: Column(

          children:[ StreamBuilder(
              stream: firebaseReference.child("var").onValue,
              builder: (context, snapshot) {
                firebaseReference.once().then((DataSnapshot dataSnapshot){
                  formattedDate=dataSnapshot.value['time']['lastused'];
                });
                firebaseReference.once().then((DataSnapshot datSnapshot){
                  perc=datSnapshot.value['bat']['perc'];
                });
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data.snapshot.value != null) {
                  _counter=snapshot.data.snapshot.value['val'];
                  String s=snapshot.data.snapshot.value['val'].toString();

                  if(t!=s && _counter!=10) {
                    t = s;
                    DateTime now= DateTime.now();
                    formattedDate = DateFormat('kk:mm:ss (d/M/y)').format(now);
                    firebaseReference.child('time').set({'lastused':formattedDate});

                  }
                  DateTime now= DateTime.now();
                  formattedNow = DateFormat('kk:mm:ss').format(now);

                  return SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal:10.0),
                            child:Container(
                              height:1.0,
                              width:520.0,
                              color:Colors.black,)
                        ),
                        Text(
                          //if()
                          'LAST USED: '+formattedDate,
                          style: TextStyle(
                            fontSize:20.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold
                          ),

                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:10.0),
                          child:Container(
                            height:1.0,
                            width:520.0,
                            color:Colors.black,)
                        ),
                        chk==0 ?
                          Text(
                            ' INHALER NOT CONNECTED',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        :Text(
                              ' INHALER CONNECTED',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal:10.0),
                            child:Container(
                              height:1.0,
                              width:520.0,
                              color:Colors.black,)
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Column(
                            children: [
                              Text('Remaining:',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),),
                              Container(
                                //margin: const EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent)),
                                child: Text(
                                    s.toString(),
                                    style:TextStyle(
                                        fontSize: 150.0,
                                        color: Colors.green
                                    )

                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 40.0),
                              Column(
                                children: [
                                  Text('Used:',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  Container(
                                    //margin: const EdgeInsets.all(9.0),
                                   // padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blueAccent)),
                                    child:
                                        Text(
                                          (10-snapshot.data.snapshot.value['val']).toString(),
                                        style:TextStyle(
                                          fontSize: 150.0,
                                          ),
                                        ),
                                  ),

                                ],

                              ),

                            ]
                          ),
                        SizedBox(height: 40.0),
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal:10.0),
                            child:Container(
                              height:1.0,
                              width:520.0,
                              color:Colors.black,)
                        ),

                        _counter <= 2?
                          Container(
                            child: Text("WARNING LOW COUNT!!!",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                                ),),
                          )
                            :Container(
                          child: Text("SUFFICIENT COUNT",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold
                            ),),
                        ),
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal:10.0),
                            child:Container(
                              height:1.0,
                              width:520.0,
                              color:Colors.black,)
                        ),

                        RaisedButton(
                          child: Text("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t RESET\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"),
                          onPressed: ()  {
                            setState(() {
                              _counter = 10;
                              firebaseReference.child("var").set({"val": 10});

                            });
                          },
                        ),
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal:10.0),
                            child:Container(
                              height:1.0,
                              width:520.0,
                              color:Colors.black,)
                        ),

                        RaisedButton(
                          child: Text("CHECK POLLUTION STATUS"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PollutionStatus()),
                            );
                          },
                        ),
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal:10.0),
                            child:Container(
                              height:1.0,
                              width:540.0,
                              color:Colors.black,)
                        ),
                        Text(
                          "BATTERY: "+perc.toString()+"%",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                       /* RaisedButton(
                          child: Text("TURN ON NOTIFICATIONS"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (CustomizedNotification())
                              ),
                            );
                          },
                        ),
                        */

                      ],
                    ),
                  );
                } else
                  return Container();
              }),]
        ),
        /*floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          backgroundColor: Colors.blue,
          onPressed: () async {
            await getCounterValue();
            _incrementCounter();
            await increaseCount();
          },
          */
        ),
    );

  }

  Future<void> reset() async {
    await firebaseReference.child("var").set({"val": 10});
    //firebaseReference.child("CounterValue").set({"count":_counter});
  }

  Future<void> increaseCount() async {
    await firebaseReference.child("var").set({"val": _counter});
  }
  Future<void> checkConn() async{
    await firebaseReference.child("chk").set({"f": 0});
    await firebaseReference.child("ch").set({"c": 1});
    await Future.delayed(const Duration(seconds: 5), (){});
    await firebaseReference.once().then((DataSnapshot dataSnapshot){
      f=dataSnapshot.value['chk']['f'];
    });
    print('checking...');
    if(f==1) {
      setState(() {chk = 1;});
      print('Inhaler connected!');
    }
    else
      setState(() {chk = 0;});
    await firebaseReference.child("ch").set({"c": 0});

    f=0;

  }
  
}
