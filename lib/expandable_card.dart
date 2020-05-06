import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  final String _topic;
  final String _details;
  @override
  ExpandableCard(this._topic, this._details);
  @override
  ExpandableCardState createState() => new ExpandableCardState();
}

class ExpandableCardState extends State<ExpandableCard>
    with TickerProviderStateMixin {
  bool expand = false;
  AnimationController controller1;
  Animation<double> animation1, animation1View;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View = CurvedAnimation(parent: controller1, curve: Curves.linear);

    controller1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildPanel(widget._topic, widget._details);
  }

  Widget buildPanel(String topic, String details) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Row(
              children: <Widget>[
                Container(width: 15, height: 0),
                Text(
                  topic,
                  style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                ),
                Spacer(flex: 1),
                Transform.rotate(
                  angle: animation1.value * math.pi / 180,
                  child: IconButton(
                    icon: Icon(Icons.expand_more),
                    onPressed: () {
                      togglePanel1();
                    },
                  ),
                ),
                Container(width: 5, height: 0),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: animation1View,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    details,
                  ),
                  //details,
//                    style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Divider(height: 0, thickness: 0.5),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      FlatButton(
                        child: Text(
                          "HIDE",
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        padding: EdgeInsets.all(0),
                        color: Colors.transparent,
                        onPressed: () {
                          togglePanel1();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void togglePanel1() {
    if (!expand) {
      controller1.forward();
    } else {
      controller1.reverse();
    }
    expand = !expand;
  }
}
