import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycity/welcome_cards.dart';
import 'package:url_launcher/url_launcher.dart';

import 'styles/my_colors.dart';
import 'styles/my_text.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CrimeReport extends StatefulWidget {
  CrimeReport();

  @override
  CrimeReportState createState() => new CrimeReportState();
}

class CrimeReportState extends State<CrimeReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Neighborhood Crime Report"),
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Container(width: 5),
                      ],
                    ),
                    Text("Neighborhood Crime Bulletin",
                        style: MyText.headline(context).copyWith(
                            color: MyColors.grey_90,
                            fontWeight: FontWeight.bold)),
                    Container(height: 10),
                    Text(
                        "The Los Altos Police Department emails the Neighborhood Watch Crime Bulletin to the Block Captains, who then shares it with their Neighborhood Watch Groups. This monthly newsletter summarizes the property crimes that have occurred around Los Altos, provides information about crime trends and recent scams, and offers crime prevention tips.",
                        style: MyText.subhead(context).copyWith(
                            color: MyColors.grey_90,
                            fontWeight: FontWeight.w300)),
                    Divider(height: 30),
                    Container(height: 10),
                    Text(
                        "You may read the most recent Crime Watch Bulletins below: ",
                        textAlign: TextAlign.justify,
                        style: MyText.subhead(context)
                            .copyWith(color: MyColors.grey_80)),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        ),
                        FlatButton(
                          child: Text(
                            "April 2020 Bulletin",
                            style: MyText.subhead(context)
                                .copyWith(color: MyColors.skyDark),
                          ),
                          onPressed: () async {
                            await launch(
                                "https://myemail.constantcontact.com/Crime-Prevention-News.html?soid=1126637385273&aid=wqXI6tzFEDk");
                          },
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        ),
                        FlatButton(
                          child: Text(
                            "March 2020 Bulletin",
                            style: MyText.subhead(context)
                                .copyWith(color: MyColors.skyDark),
                          ),
                          onPressed: () async {
                            await launch(
                                "https://myemail.constantcontact.com/Crime-Prevention-News.html?soid=1126637385273&aid=Ff4EVUiJERM");
                          },
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        ),
                        FlatButton(
                          child: Text(
                            "February 2020 Bulletin",
                            style: MyText.subhead(context)
                                .copyWith(color: MyColors.skyDark),
                          ),
                          onPressed: () async {
                            await launch(
                                "https://myemail.constantcontact.com/Crime-Prevention-News.html?soid=1126637385273&aid=rCViTE7Ef4c");
                          },
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        ),
                        FlatButton(
                          child: Text(
                            "January 2020 Bulletin",
                            style: MyText.subhead(context)
                                .copyWith(color: MyColors.skyDark),
                          ),
                          onPressed: () async {
                            await launch(
                                "https://myemail.constantcontact.com/Crime-Prevention-News.html?soid=1126637385273&aid=uGE9dq-ua8I");
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
            }, childCount: 1),
          )
        ],
      ),
    );
  }
}
