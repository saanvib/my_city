import 'package:flutter/material.dart';

import 'styles/my_colors.dart';

class DetailPage extends StatelessWidget {
  static const TextStyle optionStyle = TextStyle(fontSize: 30);
  final PageContent pageContent;
  DetailPage({Key key, @required this.pageContent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageContent.topic + " Task",
          style: optionStyle,
        ),
        // leading: new Container(),
        backgroundColor: MyColors.skyBlue,
      ),
      body: Column(
        children: <Widget>[
          Text(pageContent.details),
        ],
      ),
    );
  }
}

class PageContent {
  String topic;
  String details;

  PageContent(this.topic, this.details);
}
