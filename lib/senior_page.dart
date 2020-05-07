import 'package:flutter/material.dart';
import 'package:mycity/neighbor_assist.dart';

import 'my_colors.dart';
import 'my_text.dart';

class SeniorPage extends StatefulWidget {
  SeniorPage();

  @override
  SeniorPageState createState() => new SeniorPageState();
}

class SeniorPageState extends State<SeniorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[

          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Covid-19 Statistics",
                        style: MyText.headline(context).copyWith(
                            color: MyColors.grey_90, fontWeight: FontWeight.bold
                        )),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(2)),
                            color: Colors.white, elevation: 2, clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.lightGreen[500], child: Icon(Icons.person, color: Colors.white,),
                                  ),
                                  Container(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("230", style: MyText.subhead(context).copyWith(color: MyColors.grey_60, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(height: 5),
                                      Text("Cases", style: MyText.caption(context).copyWith(color: MyColors.grey_40),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(width: 5),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(2)),
                            color: Colors.white, elevation: 2, clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.indigo[400], child: Icon(Icons.file_download, color: Colors.white,),
                                  ),
                                  Container(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("12", style: MyText.subhead(context).copyWith(color: MyColors.grey_60, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(height: 5),
                                      Text("Deaths", style: MyText.caption(context).copyWith(color: MyColors.grey_40),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                                ],
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
                          child: Card(
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(2)),
                            color: Colors.white, elevation: 2, clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.red[300], child: Icon(Icons.shopping_basket, color: Colors.white,),
                                  ),
                                  Container(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("4000+", style: MyText.subhead(context).copyWith(color: MyColors.grey_60, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(height: 5),
                                      Text("Products", style: MyText.caption(context).copyWith(color: MyColors.grey_40),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(width: 5),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(2)),
                            color: Colors.white, elevation: 2, clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.lightGreen[500], child: Icon(Icons.description, color: Colors.white,),
                                  ),
                                  Container(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("4429", style: MyText.subhead(context).copyWith(color: MyColors.grey_60, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(height: 5),
                                      Text("Reports", style: MyText.caption(context).copyWith(color: MyColors.grey_40),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 30),
                    Text("Senior Connection",
                        style: MyText.headline(context).copyWith(
                            color: MyColors.grey_90, fontWeight: FontWeight.bold
                        )),
                    Container(height: 10),
                    Text("Recreation & Community Services staff are ready to assist seniors (50+) of the Los Altos and Los Altos Hills communities with COVID-19 updates as well as referrals, resources, and information about what services are available while being safe at home. Staff is available Monday through Friday from 9AM to 1PM; please call (650) 947-2797 to get connected!",
                        style: MyText.subhead(context).copyWith(
                            color: MyColors.grey_90, fontWeight: FontWeight.w300
                        )),
                    Divider(height: 30),
                    Text("Technical Help", textAlign: TextAlign.start,
                      style: MyText.medium(context).copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 10),
                    Text("Receive a friendly tutorial to access internet sites and resources such as the City of Los Altos programs, activities and updates on COVID-19.", textAlign: TextAlign.justify,
                        style: MyText.subhead(context).copyWith(color: MyColors.grey_80)
                    ),
//                    Container(
//                      child: Image.asset("images/image_3.jpg", fit: BoxFit.cover,),
//                      width: double.infinity, height: 200,
//                    ),
                    Container(height: 20),
                    Text("Phone Buddy Calls", textAlign: TextAlign.start,
                        style: MyText.medium(context).copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 10),
                    Text("Say Hi to your friend(s) in the Los Altos Senior Program!  We will assist you if you don’t have your friend’s phone number, with permission. Call us for more information!", textAlign: TextAlign.justify,
                        style: MyText.subhead(context).copyWith(color: MyColors.grey_80)
                    ),
                    Container(height: 20),
                    Text("Grocery and Prescription Delivery", textAlign: TextAlign.start,
                      style: MyText.medium(context).copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 10),
                    Text("We have organizations to help get everything you need delivered, so you don’t have to leave your home.", textAlign: TextAlign.justify,
                        style: MyText.subhead(context).copyWith(color: MyColors.grey_80)
                    ),
                    Container(height: 20),
                    Text("Food & Other Needs", textAlign: TextAlign.start,
                      style: MyText.medium(context).copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 10),
                    Text("Find out how the Community Services Agency can address your needs. HiCap appointments are available via the internet so questions about MediCare can be answered.", textAlign: TextAlign.justify,
                        style: MyText.subhead(context).copyWith(color: MyColors.grey_80)
                    ),
                    FlatButton(
                      child: Text(
                        "Request Help",
                        style: TextStyle(color: Colors.purpleAccent[400], fontSize: 20),
                      ),
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => NeighborAssist()),
                        );
                      },
                    ),

                  ],
                ),
              );
            },
                childCount: 1
            ),
          )
        ],
      ),
    );
  }
}

