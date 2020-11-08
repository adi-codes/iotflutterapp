import 'package:firebase_database/firebase_database.dart';
class Patient
{
  String key;
  int age;
  String email;
  int mobile;
  String name;
  String sex;
  Patient(this.key,this.age,this.email,this.mobile,this.name,this.sex);
/*
  Patient(String key){
    this.key=key;
    assign();

  }
 Future<void> assign() async{
    final firebaseReference=FirebaseDatabase.instance.reference().child(key);
    await firebaseReference.once().then((DataSnapshot datSnapshot) {
      age= datSnapshot.value['age'];
      email= datSnapshot.value['email'];
      mobile=datSnapshot.value['mobile'];
      name=datSnapshot.value['name'];
      sex=datSnapshot.value['sex'];
    });
  }*/
}