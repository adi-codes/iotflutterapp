import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iotcflutter_app/screens/Doctor.dart';
import 'package:iotcflutter_app/screens/DoctorPatient.dart';
import 'Patient.dart';


class DoctorHome extends StatefulWidget {
  String UserId;
  DoctorHome({this.UserId});
  @override
  _DoctorHomeState createState() => _DoctorHomeState(UserId: UserId);
}

class _DoctorHomeState extends State<DoctorHome> {
  List<Patient> patientList=[];
  String UserId;
  _DoctorHomeState({this.UserId});
  final firebaseReference=FirebaseDatabase.instance.reference().child('user');
  final dbref=FirebaseDatabase.instance.reference();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseReference.once().then((DataSnapshot snap){
      patientList.clear();
      var KEYS=snap.value.keys;
      var DATA=snap.value;
     for(var individualKey in KEYS){
       print(individualKey);
       print(DATA[individualKey]['docid']);
       print(UserId);
       if(DATA[individualKey]['docid']==UserId){


          Patient patient = new Patient(
            individualKey,
            DATA[individualKey ]['age'],
            DATA[individualKey ]['email'],
            DATA[individualKey]['mobile'],
            DATA[individualKey]['name'],
            DATA[individualKey]['sex'],

          );
          patientList.add(patient);
       }
        }
        setState(() {
          print('Length:  : $patientList.length ');
        });
      });
  }
  void goPatient(String key){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DoctorPatient(UserId: key)),
    );

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Text("Your patients"),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: patientList.length ==0? new Text('No patients assigned to you'): new ListView.builder(
                itemCount: patientList.length,
                itemBuilder: (_,index){
                  print(index);
                  return patientUI(patientList[index].key,patientList[index].age, patientList[index].email, patientList[index].mobile, patientList[index].name, patientList[index].sex);
                })
        ),
      ),
    );
  }

  Widget patientUI(String key,int age,String email, int mobile, String name, String sex){
    return Card(
      elevation:10.0 ,
      child: InkWell(
        onTap: (){
          goPatient(key);
        },
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NAME:'+name),
                Text('Age :'+ age.toString()),
                Row(
                  children: [
                    //Text('Sex:'+sex),
                    Text('Mobile: '+mobile.toString()),
                    SizedBox(width: 10),
                    Text('Sex: '+sex),
                  ],
                ),
              ]
          ),
        ),
      ),

    );
  }
}
