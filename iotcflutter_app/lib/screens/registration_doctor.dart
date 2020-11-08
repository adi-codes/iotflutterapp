import 'package:flutter/material.dart';
import 'package:iotcflutter_app/helpers/list_item_gender.dart';
import 'package:firebase_database/firebase_database.dart';
class RegistrationDoctor extends StatefulWidget {
  String UserId;
  String email;
  RegistrationDoctor({this.UserId,this.email});
  @override
  _RegistrationDoctorState createState() => _RegistrationDoctorState(UserId: UserId,email:email);
}

class _RegistrationDoctorState extends State<RegistrationDoctor> {
  int numd;
  String UserId;
  String email;
  String _name;
  int _age;
  int _mobile;
  String _sex;

  _RegistrationDoctorState({this.UserId, this.email});

  List<ListItem> _dropdownItems = [
    ListItem(1, "Male"),
    ListItem(2, "Female"),
    ListItem(3, "Others")
  ];
  final firebaseReference = FirebaseDatabase.instance.reference();
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    _sex = _selectedItem.name;
    print(_selectedItem.name);
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,

        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text("Doctor registration"),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              onChanged: () {
                Form.of(primaryFocus.context).save();
              },
              child: Wrap(
                children: [
                  SizedBox(
                    height: height * 0.15,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Name",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Name cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      setState(() {
                        _name = val;
                      });
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Container(
                        width: width * 0.4,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Age",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Age cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) {
                            setState(() {
                              _age = int.parse(val);
                            });
                          },
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.12,
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: DropdownButton<ListItem>(
                            value: _selectedItem,
                            items: _dropdownMenuItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedItem = value;
                                print(value);
                              });
                              _sex = _selectedItem.name;
                            }),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Mobile",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Mobile no can not be empty";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      setState(() {
                        _mobile = int.parse(val);
                      });
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  RaisedButton(
                      child:
                      Text('Submit'),
                      onPressed: () {
                        _submitDetails(
                            UserId, _name, email, _sex, _mobile, _age);
                      })
                ],
              ),),)
      ),
    );
  }

  Future<void> _submitDetails(String userId, String name, String _email,
      String sex, int mobile, int _age) async {
    print(name);
    print(_email);
    print(sex);
    await firebaseReference.child("doctor/" + userId).set({
      'name': name,
      'email': _email,
      'age': _age,
      'sex': sex,
      'mobile': mobile,
      'nop':0,
      'patients':['default']
    });


  }
}