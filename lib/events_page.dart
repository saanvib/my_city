import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycity/welcome_cards.dart';

import 'my_colors.dart';
import 'my_text.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EventPage extends StatefulWidget {
  EventPage();

  @override
  EventPageState createState() => new EventPageState();
}

class EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Events"),
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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                'Events',
                style: MyText.headline(context).copyWith(
                    color: MyColors.grey_90, fontWeight: FontWeight.bold),
              ),
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('events')
                      .orderBy('StartDate', descending: true)
                      .limit(10)
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
                          padding: const EdgeInsets.all(10),
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) => _buildListItem(
                              index, context, snapshot.data.documents[index]),
                        );
                    }
                  }),
            ],
          ),
        ));
  }

  static Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot documentSnapshot) {
    var formatter = new DateFormat('MMM dd');
    String formattedDate =
        formatter.format(documentSnapshot["StartDate"].toDate());

    return ListTile(
      leading: Icon(
        Icons.event,
        size: 60,
      ),
      title: Text(formattedDate + " : " + documentSnapshot["EventName"]),
      subtitle: Text(documentSnapshot["Details"]),
      trailing: Icon(Icons.more_vert),
      isThreeLine: true,
    );
//    return ExpandableCard(
//        documentSnapshot['Topic'], documentSnapshot['Details']);
  }
}

//ListView(
//children: const <Widget>[
//Card(
//child:
//),
//],
//),
