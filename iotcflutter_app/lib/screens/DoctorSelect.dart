import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iotcflutter_app/screens/Doctor.dart';
import 'Doctor.dart';
import 'home_page_ui.dart';
class DoctorSelect extends StatefulWidget {
  String UserId;
  DoctorSelect({this.UserId});
  @override
  _DoctorSelectState createState() => _DoctorSelectState(UserId:UserId);
}

class _DoctorSelectState extends State<DoctorSelect> {
  List<Doctor> doctorList=[];
  String UserId;
  _DoctorSelectState({this.UserId});
  int numd;
  final firebaseReference=FirebaseDatabase.instance.reference().child('doctor');
  final dbref=FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNoDoctor() ;
    print(numd);
    firebaseReference.once().then((DataSnapshot snap){
        var KEYS =snap.value.keys;
        var DATA= snap.value;
        doctorList.clear();
        for(var individualKey in KEYS){
          print(individualKey);
          Doctor doctor = new Doctor(
            individualKey,
            DATA[individualKey ]['age'],
            DATA[individualKey ]['email'],
            DATA[individualKey]['mobile'],
            DATA[individualKey]['name'],
            DATA[individualKey]['sex'],
          );
          doctorList.add(doctor);
          setState(() {
            print('Length:  : $doctorList.length' );
          });
        }
    });

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Text("Select a Doctor"),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: doctorList.length ==0? new Text('No doctors available'): new ListView.builder(
                itemCount: doctorList.length,
                itemBuilder: (_,index){
                  print(index);
                  return doctorUI(doctorList[index].key,doctorList[index].age, doctorList[index].email, doctorList[index].mobile, doctorList[index].name, doctorList[index].sex);
                })
        ),
      ),
    );
  }
  Future<void> getNoDoctor() async{

    await firebaseReference.once().then((DataSnapshot datSnapshot) {
      numd=datSnapshot.value['numd'];
    });

  }
  Widget doctorUI(String key,int age,String email, int mobile, String name, String sex){
    return Card(
      elevation:10.0 ,
      child: InkWell(
        onTap: (){
          setDoctor(key);
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NAME: Dr.'+name),
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
  Future<void> setDoctor(String key) async{
    await dbref.child("user/"+UserId).update({"docid": key});
    await dbref.child("user/"+UserId).update({"nod": 1});
    int nop;
    await dbref.once().then((DataSnapshot datSnapshot) {
       nop= datSnapshot.value['doctor'][key][nop];
    });
    await dbref.child('doctor').child(key).child('patients').push().set(UserId);
    Navigator.push(
        context,
    MaterialPageRoute(builder: (context) => MyHomePage(
      UserId: UserId,
    )),
    );
  }

}
