import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycity/signin_page.dart';

import 'home_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RequestHelpDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestHelpDialogState();
}

class _RequestHelpDialogState extends State<RequestHelpDialog> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  var _requestType = ["Grocery", "Food Pickup", "Gardening", "Other"];
  String _requestChoice;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Submit Request For Help"), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await _auth.signOut();
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => SignInPage()));
          },
        ),
      ]),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            Text(
              "Please use the form below to request help from one of the neighbours.",
            ),
            DropdownButtonFormField(
              items: _requestType.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  this._requestChoice = newValue;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Choose a category',
                labelText: 'Category',
              ),
              value: _requestChoice,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter a short description of the task.',
                labelText: 'Details',
              ),
              validator: (String value) {
                return value.isEmpty ? "Please enter a description." : null;
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: const Text('Request Help', style: TextStyle(fontSize: 20)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(_requestChoice);
                  print(_descriptionController.text);

                  Firestore.instance.collection('help_requests').add({
                    "request_type": _requestChoice,
                    "details": _descriptionController.text,
                    "requestor": "email",
                    "status": "New",
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => HomePage(2)),
                  );
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
