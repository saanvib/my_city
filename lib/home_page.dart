// ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycity/list_adapter_basic.dart';
import 'package:mycity/my_colors.dart';
import 'package:mycity/welcome_cards.dart';
import 'package:url_launcher/url_launcher.dart';

import 'crime_report.dart';
import 'senior_page.dart';

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
  List<Widget> _widgetOptions = <Widget>[
    Column(
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
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(width: 20),
            Expanded(
              child: Stack(
                children: <Widget>[
                  FlatButton(
                    child: Image.asset("images/image_events.png"),
                    onPressed: null,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      alignment: Alignment.centerRight,
                      height: 50,
                      width: 80,
                      color: Colors.black.withOpacity(0.5),
                      child: Text("Events",
                          style:
                              TextStyle(color: Colors.grey[100], fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  FlatButton(
                    child: Image.asset("images/CrimeSceneInvestigation.jpg"),
                    onPressed: () async {
                      print("onpressed");
                      Navigator.of(saveContext).push(MaterialPageRoute<void>(
                          builder: (_) => CrimeReport()));
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      alignment: Alignment.centerRight,
                      height: 50,
                      width: 80,
                      color: Colors.black.withOpacity(0.5),
                      child: Text("Crime Report",
                          style:
                              TextStyle(color: Colors.grey[100], fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  FlatButton(
                    child: Image.asset("images/elections.jpg"),
                    onPressed: null,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      alignment: Alignment.centerRight,
                      height: 50,
                      width: 80,
                      color: Colors.black.withOpacity(0.5),
                      child: Text("Elections 2020",
                          style:
                              TextStyle(color: Colors.grey[100], fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    Column(children: <Widget>[
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
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
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
    SeniorPage(),
//    CovidPage([CovidItem(
//      expandedValue: ArticleSimple(),
//      headerValue: "Senior Connections",
//      isExpanded:true,
//    )]),

//    Column(
//      children: <Widget>[
//        ArticleSimple(),
//        NeighborAssist(),
//        OfferHelp(),
//      ],
//    ),
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
}

class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}

class _PushMessagingExampleState extends State<PushMessagingExample> {
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Push Messaging Demo'),
        ),
        body: Material(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(_homeScreenText),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Text(_messageText),
                ),
              ])
            ],
          ),
        ));
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
