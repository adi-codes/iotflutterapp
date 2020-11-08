import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'Patient.dart';
class DoctorPatient extends StatefulWidget {
  String UserId;
  DoctorPatient({this.UserId});
  @override
  _DoctorPatientState createState() => _DoctorPatientState(UserId: UserId);
}

class _DoctorPatientState extends State<DoctorPatient> {
  String UserId;
  _DoctorPatientState({this.UserId});
  int d=0;
  String formattedNow=' ';
  int chk=0;

  final firebaseReference = FirebaseDatabase.instance.reference().child('user');
  String name='';
  int age=0;
  String t = '';
  int _counter = 10;
  String formattedDate = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(UserId);
    print(UserId);
    getvals();

  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value)));
  }
  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Patient details'),
          centerTitle: true,
        ),
        body: Column(

            children: [
              Container(
                child:Text(
                  'Name:'+name,
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              ),
              Container(
                child:Text(
                  'Age:'+age.toString(),
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              StreamBuilder(
                  stream: firebaseReference
                      .child(UserId).child('var')
                      .onValue,
                  builder: (context, snapshot) {
                    firebaseReference.once().then((
                        DataSnapshot dataSnapshot) {
                      formattedDate = dataSnapshot.value[UserId]['time']['lastused'];
                    });

                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data.snapshot.value != null) {
                      _counter = snapshot.data.snapshot.value['val'];
                      String s = snapshot.data.snapshot.value['val']
                          .toString();

                      if (t != s && _counter != 10) {
                        t = s;
                        DateTime now = DateTime.now();
                        formattedDate =
                            DateFormat('kk:mm:ss (d/M/y)').format(now);
                        firebaseReference.child('time').update(
                            {'lastused': formattedDate});
                      }
                      DateTime now = DateTime.now();
                      formattedNow = DateFormat('kk:mm:ss').format(now);

                      return SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 520.0,
                                  color: Colors.black,)
                            ),
                            Text(
                              //if()
                              'LAST USED: ' + formattedDate,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold
                              ),

                            ),
                            SizedBox(height: 10),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 520.0,
                                  color: Colors.black,)
                            ),
                            chk == 0 ?
                            Text(
                              ' INHALER NOT CONNECTED',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                                : Text(
                              ' INHALER CONNECTED',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 520.0,
                                  color: Colors.black,)
                            ),
                            SizedBox(height: 40.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                            border: Border.all(
                                                color: Colors.blueAccent)),
                                        child: Text(
                                            s.toString(),
                                            style: TextStyle(
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
                                            border: Border.all(
                                                color: Colors.blueAccent)),
                                        child:
                                        Text(
                                          (10 -
                                              snapshot.data.snapshot
                                                  .value['val'])
                                              .toString(),
                                          style: TextStyle(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 520.0,
                                  color: Colors.black,)
                            ),

                            _counter <= 2 ?
                            Container(
                              child: Text("WARNING LOW COUNT!!!",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold
                                ),),
                            )
                                : Container(
                              child: Text("SUFFICIENT COUNT",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 520.0,
                                  color: Colors.black,)
                            ),


                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 520.0,
                                  color: Colors.black,)
                            ),


                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  width: 540.0,
                                  color: Colors.black,)
                            ),
                            StreamBuilder(
                                stream: firebaseReference
                                    .child(UserId)
                                    .onValue,
                                builder: (context, snapshot) {
                                  return Text(
                                    "BATTERY: " +
                                        snapshot.data.snapshot.value['bat']['perc']
                                            .toString() + "%",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold
                                    ),
                                  );
                                }
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
                  }),
            ]
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
  Future<void> getvals() async{
    await firebaseReference.once().then((DataSnapshot datSnapshot) {
      setState(() {
        name = datSnapshot.value[UserId]['name'];
      });
    });
    await firebaseReference.once().then((DataSnapshot datSnapshot) {
      setState(() {
        age = datSnapshot.value[UserId]['age'];
      });

    });
}
}


