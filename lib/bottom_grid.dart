import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class GridSingleLineAdapter {
  List itemsTile = <GridItemTile>[];

  GridSingleLineAdapter() {
    itemsTile.add(GridItemTile(
        index: 0,
        imgName: "images/image_events.png",
        title: "Events",
        pageName: HomePage(0)));
    itemsTile.add(GridItemTile(
        index: 1,
        imgName: "images/CrimeSceneInvestigation.jpg",
        title: "Crime Report",
        pageName: HomePage(0)));
    itemsTile.add(GridItemTile(
        index: 2,
        imgName: "images/elections.jpg",
        title: "Elections 2020",
        pageName: HomePage(0)));
  }

  Widget getView() {
    return new Expanded(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        padding: EdgeInsets.all(2),
        crossAxisCount: 2,
        children: itemsTile,
      ),
    );
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
    return Stack(
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
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
