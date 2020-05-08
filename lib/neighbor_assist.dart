import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycity/offer_help.dart';
import 'package:mycity/request_help.dart';
import 'package:mycity/welcome_cards.dart';

import 'list_adapter_basic.dart';
import 'my_colors.dart';
import 'my_text.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class NeighborAssist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NeighborAssistState();
}

class _NeighborAssistState extends State<NeighborAssist> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  //TODO: Get users email from auth.
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
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Your help requests',
                  style: MyText.headline(context).copyWith(
                      color: MyColors.grey_90, fontWeight: FontWeight.bold),
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('help_requests')
                        .where('requestor', isEqualTo: userEmail)
                        .where('status',
                            whereIn: ['New', 'accepted']).snapshots(),
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
                                index, context, snapshot.data.documents[index]),
                          );
                      }
                    }),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => RequestHelpDialog()),
                    );
                  },
                  child: Text(
                    'Request Help',
                    style: TextStyle(
                        color: Colors.purpleAccent[400], fontSize: 20),
                  ),
                ),
                Divider(
                  height: 30,
                ),
                OfferHelp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildlistitem(
      int index, BuildContext context, DocumentSnapshot document) {
    return ItemTile(
        index: index,
        object: Item(document["request_type"], document["details"], null, null),
        onClick: null);
  }

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    // Similarly we can get email as well
    userEmail = user.email;
    //print(uemail);
    print(user.email);
  }
}
