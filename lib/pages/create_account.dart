import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petnaar/pages/home.dart';


class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _username; // Using late for null safety

  void _submit() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      Fluttertoast.showToast(
        msg: "Welcome $_username",
        backgroundColor: Colors.orangeAccent,
        toastLength: Toast.LENGTH_SHORT,
      );

      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement( // Changed to pushReplacement to not allow going back to the create account screen
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disables the back button
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text("Set up your profile"),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Center(
              child: Text(
                "Create a username",
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.trim().length < 3) {
                    return "Username too short.";
                  } else if (val.trim().length > 20) {
                    return "Username too long.";
                  } else {
                    return null;
                  }
                },
                onSaved: (val) => _username = val!,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  labelStyle: TextStyle(fontSize: 15.0),
                  hintText: "Must be at least 3 characters",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
                minimumSize: const Size(350.0, 50.0), // width and height
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
