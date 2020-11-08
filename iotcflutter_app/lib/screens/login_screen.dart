import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iotcflutter_app/screens/Doctor.dart';
import 'package:iotcflutter_app/screens/registration_doctor.dart';
import 'package:iotcflutter_app/screens/registration_patient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page_ui.dart';
import 'registration_patient.dart';
import 'DoctorHome.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType{
  login,
  register
}
class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  int _radioValue1;
  FormType _formType= FormType.login;
  String _uid;
  final formKey = new GlobalKey<FormState>();
  bool validateAndSave(){
    final form=formKey.currentState;
    if(form.validate()) {
      form.save();
      print('form is valid!!!,\n Email: $_email,Password: $_password');
      return true;

    }
     else {
       print('form is invalid,\n Email: $_email,Password: $_password');
       return false;
    }
  }
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if(_formType==FormType.login) {
          UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in: ${user.user.uid}');
          _uid=user.user.uid;

          if(_radioValue1==1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(
                UserId: _uid,
              )),
            );
          else
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorHome(
                UserId: _uid,
              )),
            );


        }
        else{
          UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered user: ${user.user.uid}');
          _uid=user.user.uid;
          if(_radioValue1==1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPatient(
                  UserId: _uid,
                  email:_email
              )),
            );
          else
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationDoctor(
                  UserId: _uid,
                  email:_email)),
            );
        }
      }
      catch(e){
        print('Error $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
      setState(() {
        _formType=FormType.register;
      });

  }
  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.login;
    });
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text("Login/Create an account"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:buildInputs()+buildSubmitButton(),/*+ [
                SizedBox(
                  height: height * 0.15,
                ),

                SizedBox(
                  height: height * 0.03,
                ),

                RaisedButton(
                  child: Container(
                      child: Text("Registration doctor")
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationDoctor()),
                    );
                    },
                ),
                RaisedButton(
                  child: Container(
                      child: Text("Registration patient")
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPatient()),
                    );
                    },
                ),
                /*
                RaisedButton(
                  child: Container(
                      child: Text("Move to home page")
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Counter')),
                    );
                    },
                ),
                 */
              ],
            ),
          ),
        ),
      ),
      */
    )))));
  }
  List<Widget> buildInputs(){
      return [
        TextFormField(
          decoration: new InputDecoration(
            labelText: "Enter your Email",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(),
            ),
            //fillColor: Colors.green
          ),
          validator: (val) {
            if (val.length == 0) {
              return "Email cannot be empty";
            } else {
              return null;
            }
          },
          onSaved: (value) =>_email = value,
          keyboardType: TextInputType.emailAddress,
          style: new TextStyle(
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: new InputDecoration(
            labelText: "Enter Password",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(),
            ),
            //fillColor: Colors.green
          ),
          validator: (val) {
            if (val.length == 0) {
              return "Password cannot be empty";
            } else {
              return null;
            }
          },
          onSaved: (value) =>_password = value,
          keyboardType: TextInputType.emailAddress,
          style: new TextStyle(
            fontFamily: "Poppins",
          ),
          obscureText: true,
        ),

      ];
  }
  List<Widget> buildSubmitButton(){
    if(_formType==FormType.login) {
      return [
        Row(
            children:[

              new Radio(
                value: 0,
                groupValue: _radioValue1,
                onChanged: (value){ setState(() {
                  _radioValue1=value;
                });},
              ),
              new Text(
                'Doctor',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: _radioValue1,
                onChanged: (value){ setState(() {
                  _radioValue1=value;
                });},
              ),
              new Text(
                'Patient',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ]
        ),

        RaisedButton(
          child: Container(
              child: Text("Login")
          ),
          onPressed: validateAndSubmit,
        ),
        RaisedButton(
          child: Container(child: Text('Create an account')),
          onPressed: moveToRegister,
        )
      ];
    }else{
        return[
          Row(
            children:[

            new Radio(
              value: 0,
              groupValue: _radioValue1,
              onChanged: (value){ setState(() {
                _radioValue1=value;
              });},
            ),
            new Text(
              'Doctor',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: 1,
              groupValue: _radioValue1,
              onChanged: (value){ setState(() {
                _radioValue1=value;
              });},
            ),
            new Text(
              'Patient',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
            ]
          ),
          RaisedButton(
            child: Container(
                child: Text('Create an account')
            ),
            onPressed: validateAndSubmit,
          ),
          RaisedButton(
            child: Container(child: Text('Have an account?Login')),
            onPressed: moveToLogin,
          )
        ];
    }
  }
}
