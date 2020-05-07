import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycity/offer_help.dart';
import 'package:mycity/request_help.dart';
import 'package:mycity/welcome_cards.dart';

import 'my_colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class NeighborAssist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NeighborAssistState();
}

class _NeighborAssistState extends State<NeighborAssist> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  String userEmail = "rishi.bhargava@gmail.com";

//  @override
//  void initState() {
//    super.initState();
//    getCurrentUser().then((user) {
//      setState(() {
//        if (user) {
//          print(user.email);
//        }
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    // print("user email is : $userEmail");
    return Scaffold(
      appBar: AppBar(
          title: Text("Senior Helpline"),
          // leading: new Container(),
          backgroundColor: MyColors.skyBlue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => WelcomeCards()));
              },
            ),
          ]),
        body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              'Your help requests',
              style: optionStyle,
            ),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('help_requests')
                    .where('requestor', isEqualTo: userEmail)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) => _buildlistitem(
                            context, snapshot.data.documents[index]),
                      );
                  }
                }),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => RequestHelpDialog()),
                );
              },
              child: const Text('Request Help', style: TextStyle(fontSize: 20)),
            ),
            OfferHelp(),
          ],
        ),
      ),);
  }

  static Widget _buildlistitem(
      BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['request_type']),
      subtitle: Text(document['details']),
    );
  }

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    // Similarly we can get email as well
    userEmail = user.email;
    //print(uemail);
    print(user.email);
  }
}


