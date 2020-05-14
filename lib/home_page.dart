// ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mycity/events_page.dart';
import 'package:mycity/list_adapter_basic.dart';
import 'package:mycity/welcome_cards.dart';
import 'package:url_launcher/url_launcher.dart';

import 'covid_page.dart';
import 'crime_report.dart';
import 'styles/my_colors.dart';
import 'styles/my_text.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  final String title = 'Home Page';
  int _activeTab;
  HomePage(this._activeTab);
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const TextStyle optionStyle = TextStyle(fontSize: 30);
  static BuildContext saveContext;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print("FirebaseMessaging token: $token");
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showDialog(
            message["notification"]["title"], message["notification"]["body"]);
        HapticFeedback.vibrate();
        SystemSound.play(SystemSoundType.click);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        HapticFeedback.vibrate();
        SystemSound.play(SystemSoundType.click);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        HapticFeedback.vibrate();
        SystemSound.play(SystemSoundType.click);
      },
    );
  }

  List<Widget> _widgetOptions = <Widget>[
    SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Text(
            'Announcements',
            style: optionStyle,
          ),
          StreamBuilder(
              stream: Firestore.instance
                  .collection('announcements')
                  .orderBy('Date', descending: true)
                  .limit(4)
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
          HomePageTiles(),
        ],
      ),
    ),
    SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Text(
          'Community Resources',
          style: optionStyle,
        ),
        StreamBuilder(
            stream: Firestore.instance.collection('community').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView.builder(
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => _buildCommunityList(
                        index, context, snapshot.data.documents[index]),
                  );
              }
            }),
      ]),
    ),
    CovidPage(),
  ];

  static Widget _buildEventListItem(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.event),
        title: Text(documentSnapshot['EventName']),
        subtitle: Text(documentSnapshot['Details']),
      ),
    );
  }

  static Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot documentSnapshot) {
    var formatter = new DateFormat('MMM dd');
    String formattedDate = formatter.format(documentSnapshot["Date"].toDate());

    return ItemTile(
        index: index,
        object: Item(documentSnapshot["Topic"], documentSnapshot["Details"],
            formattedDate, documentSnapshot["url"]),
        onClick: (index, obj) {
          print(obj.url);
          _launchURL(obj.url);
        });
//    return ExpandableCard(
//        documentSnapshot['Topic'], documentSnapshot['Details']);
  }

  static Widget _buildCommunityList(
      int index, BuildContext context, DocumentSnapshot documentSnapshot) {
    return ItemTile(
        index: index,
        object: Item(documentSnapshot["Topic"], documentSnapshot["Details"],
            null, documentSnapshot["url"]),
        onClick: (index, obj) {
          print(obj.url);
          _launchURL(obj.url);
        });
//    return ExpandableCard(
//        documentSnapshot['Topic'], documentSnapshot['Details']);
  }

  void _onItemTapped(int index) {
    setState(() {
      widget._activeTab = index;
    });
  }

  static void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    saveContext = context;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
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
      body: _widgetOptions.elementAt(widget._activeTab),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Community'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('COVID-19'),
          ),
        ],
        currentIndex: widget._activeTab,
        selectedItemColor: MyColors.lemonDark,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showDialog(String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}

class GridItemTile extends StatelessWidget {
  final String imgName;
  final String title;
  final int index;
  final Widget pageName;

  const GridItemTile({
    Key key,
    @required this.index,
    @required this.imgName,
    @required this.title,
    @required this.pageName,
  })  : assert(index != null),
        assert(imgName != null),
        assert(pageName != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Image.asset(
            imgName,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              alignment: Alignment.centerRight,
              height: 50,
              color: Colors.black.withOpacity(0.5),
              child: Row(
                children: <Widget>[
                  Text(title,
                      style: TextStyle(color: Colors.grey[100], fontSize: 20)),
                  Spacer(),
                  Icon(Icons.info, size: 25, color: Colors.grey[300])
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: Colors.black.withOpacity(0.1),
                splashColor: Colors.black.withOpacity(0.1),
                onTap: () {
                  _pushPage(context, pageName);
                },
                child:
                    Container(height: double.infinity, width: double.infinity)),
          ),
        ],
      ),
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
//
//class HomePageTiles extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => HomePageTilesState();
//}
//
//class HomePageTilesState extends State<HomePageTiles> {
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Row(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//// SizedBox(width: 20),
//            Expanded(
//              child: Stack(
//                children: <Widget>[
//                  FlatButton(
//                    child: Image.asset("images/image_events.png"),
//                    onPressed: null,
//                  ),
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: Container(
//// padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                      alignment: Alignment.centerRight,
//                      height: 50,
//                      width: 80,
//                      color: Colors.black.withOpacity(0.5),
//                      child: Text("Events",
//                          style:
//                              TextStyle(color: Colors.grey[100], fontSize: 20)),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Expanded(
//              child: Stack(
//                children: <Widget>[
//                  FlatButton(
//                    child: Image.asset("images/CrimeSceneInvestigation.jpg"),
//                    onPressed: () async {
//                      print("onpressed");
//                      Navigator.of(context).push(MaterialPageRoute<void>(
//                          builder: (_) => CrimeReport()));
//                    },
//                  ),
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: Container(
//// padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                      alignment: Alignment.centerRight,
//                      height: 50,
//                      width: 80,
//                      color: Colors.black.withOpacity(0.5),
//                      child: Text("Crime Report",
//                          style:
//                              TextStyle(color: Colors.grey[100], fontSize: 20)),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Expanded(
//              child: Stack(
//                children: <Widget>[
//                  FlatButton(
//                    child: Image.asset("images/elections.jpg"),
//                    onPressed: null,
//                  ),
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: Container(
//// padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                      alignment: Alignment.centerRight,
//                      height: 50,
//                      width: 80,
//                      color: Colors.black.withOpacity(0.5),
//                      child: Text("Elections 2020",
//                          style:
//                              TextStyle(color: Colors.grey[100], fontSize: 20)),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ],
//    );
//  }
//}

class HomePageTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageTilesState();
}

class HomePageTilesState extends State<HomePageTiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => EventPage()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  color: Colors.white,
                  elevation: 2,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.lightGreen[500],
                          child: Icon(
                            Icons.event,
                            color: Colors.white,
                          ),
                        ),
                        Container(width: 10),
                        Text(
                          "Events",
                          style: MyText.subhead(context).copyWith(
                              color: MyColors.grey_60,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(width: 5),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => CrimeReport()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  color: Colors.white,
                  elevation: 2,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.indigo[400],
                          child: Icon(
                            Icons.warning,
                            color: Colors.white,
                          ),
                        ),
                        Container(width: 10),
                        Column(
                          children: <Widget>[
                            Text(
                              "Crime",
                              style: MyText.subhead(context).copyWith(
                                  color: MyColors.grey_60,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Bulletin",
                              style: MyText.subhead(context).copyWith(
                                  color: MyColors.grey_60,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(height: 5),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => CrimeReport()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  color: Colors.white,
                  elevation: 2,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.red[300],
                          child: Icon(
                            Icons.thumbs_up_down,
                            color: Colors.white,
                          ),
                        ),
                        Container(width: 10),
                        Text(
                          "Elections",
                          style: MyText.subhead(context).copyWith(
                              color: MyColors.grey_60,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(width: 5),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => CrimeReport()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  color: Colors.white,
                  elevation: 2,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.lightGreen[500],
                          child: Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        Container(width: 10),
                        Text(
                          "FAQ",
                          style: MyText.subhead(context).copyWith(
                              color: MyColors.grey_60,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
