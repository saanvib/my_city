import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycity/my_colors.dart';

import 'detail_page.dart';
import 'my_colors.dart';
import 'my_text.dart';


class OfferHelp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OfferHelpState();
}

class _OfferHelpState extends State<OfferHelp> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: <Widget>[
          Text(
            'Extend a helping hand',
            style: MyText.headline(context).copyWith(
                color: MyColors.grey_90, fontWeight: FontWeight.bold
            ),
          ),
          StreamBuilder(
              stream: Firestore.instance
                  .collection('help_requests')
//                  .where('status',
//                      isEqualTo: "New") // where('user', isEqualTo: uid)
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
        ],
      ),
    );
  }

  static Widget _buildlistitem(
      BuildContext context, DocumentSnapshot document) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: MyColors.skyBlue),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: IconButton(
                icon: document["status"] == "accepted"
                    ? Icon(
                        Icons.check_box,
                        color: Colors.green,
                      )
                    : Icon(Icons.check_box_outline_blank, color: Colors.white),
                onPressed: () {
                  Firestore.instance
                      .collection('help_requests')
                      .document(document.documentID)
                      .updateData({"status": "accepted"});
                },
              ),
            ),
            title: Text(
              document["request_type"],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

            subtitle: Row(
              children: <Widget>[
                Text(
                    document["details"].length > 25
                        ? document["details"].substring(0, 25) + "..."
                        : document["details"],
                    style: TextStyle(color: Colors.white))
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => DetailPage(
                        pageContent: PageContent(
                            document["request_type"], document["details"]))));
              },
            ),
          ),
        ),
      ),
    );

//    return InkWell(
//      onTap: () {
//        //onItemClick(object);
//      },
//      child: Padding(
//        padding: EdgeInsets.symmetric(vertical: 5),
//        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            Container(width: 20),
//            Expanded(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    document["request_type"],
//                    style: MyText.title(context).copyWith(
//                        color: Colors.grey[800], fontWeight: FontWeight.normal),
//                  ),
//                  Container(height: 5),
//                  Text(
//                    document["details"],
//                    maxLines: 2,
//                    style: MyText.subhead(context).copyWith(color: Colors.grey),
//                  ),
//                  Container(height: 15),
//                  FlatButton(
//                      onPressed: () {
//                        var doc = Firestore.instance
//                            .collection('help_requests')
//                            .document(document.documentID)
//                            .updateData({"status": "accepted"});
//                      },
//                      child: Text("Accept")),
//                  Divider(color: Colors.grey[300], height: 0),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
  }
}
