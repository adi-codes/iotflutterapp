import 'package:flutter/material.dart';
import 'package:iotcflutter_app/screens/registration_doctor.dart';
import 'package:iotcflutter_app/screens/registration_patient.dart';

import 'home_page_ui.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text("Login"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.15,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: "Enter Email",
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
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(
                height: height * 0.03,
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
                    return "Email cannot be empty";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                obscureText: true,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              RaisedButton(
                child: Container(
                  child: Text("Submit")
                ),
                onPressed: () {},
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

            ],
          ),
        ),
      ),
    );
  }
}
