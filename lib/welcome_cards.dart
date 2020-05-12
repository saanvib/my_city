import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycity/signin_page.dart';

import 'my_colors.dart';
import 'my_text.dart';

class WelcomeCards extends StatefulWidget {
  WelcomeCards();

  @override
  WelcomeCardsState createState() => new WelcomeCardsState();
}

class WelcomeCardsState extends State<WelcomeCards> {
  List<Wizard> wizardData = Wizard.getWizard();
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.grey[100])),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: <Widget>[
          Expanded(
            child: PageView(
              onPageChanged: onPageViewChange,
              controller: pageController,
              children: buildPageViewItem(),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 60,
              child: Align(
                alignment: Alignment.topCenter,
                child: buildDots(context),
              ),
            ),
          )
        ]),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    isLast = _page == wizardData.length - 1;
    setState(() {});
  }

  List<Widget> buildPageViewItem() {
    List<Widget> widgets = [];
    for (Wizard wz in wizardData) {
      Widget wg = Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          children: <Widget>[
            Container(
                width: 280,
                height: 370,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 2,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(wz.background,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover),
                      Container(color: MyColors.skyDark.withOpacity(0.7)),
                      Column(
                        children: <Widget>[
                          Container(height: 35),
                          Text(wz.title,
                              style: MyText.title(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: Text(wz.brief,
                                textAlign: TextAlign.center,
                                style: MyText.subhead(context)
                                    .copyWith(color: Colors.white)),
                          ),
                          Expanded(
                            child: Image.asset(wz.image,
                                width: 150, height: 150, color: Colors.white),
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              child: Text(isLast ? "Get Started" : "Next",
                                  style: MyText.subhead(context)
                                      .copyWith(color: Colors.white)),
                              color: MyColors.skyDark,
                              onPressed: () {
                                if (isLast) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (_) => SignInPage()));
                                  return;
                                }
                                pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      );
      widgets.add(wg);
    }
    return widgets;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < wizardData.length; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor:
              page == i ? MyColors.skyDark : MyColors.periwinkleBlue,
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}

class Wizard {
  String image;
  String background;
  String title;
  String brief;

  static const List<String> wizard_title = [
    "Updates from City",
    "Senior Connections",
    "Community Events",
    "Local COVID-19 Info"
  ];
  static const List<String> wizard_brief = [
    "Stay informed with accurate and current information from your city.",
    "Help seniors in your community with grocery, gardening, etc.",
    "Save the date for city events. Don't miss out on community activities!",
    "Read updated statistics, lockdown information, and find testing centers.",
  ];
  static const List<String> wizard_image = [
    "images/img_wizard_2.png",
    "images/seniors.png",
    "images/events.webp",
    "images/covid19.png",
  ];
  static const List<String> wizard_background = [
    "images/image_15.jpg",
    "images/image_10.jpg",
    "images/image_3.jpg",
    "images/image_12.jpg"
  ];

  static List<Wizard> getWizard() {
    List<Wizard> items = [];
    for (int i = 0; i < wizard_title.length; i++) {
      Wizard obj = new Wizard();
      obj.image = wizard_image[i];
      obj.background = wizard_background[i];
      obj.title = wizard_title[i];
      obj.brief = wizard_brief[i];
      items.add(obj);
    }
    return items;
  }
}
