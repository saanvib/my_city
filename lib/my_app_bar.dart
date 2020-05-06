import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycity/signin_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyAppBar extends AppBar {
  MyAppBar({@required String title, @required BuildContext context})
      : super(title: Text(title), actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => SignInPage()));
            },
          ),
        ]);
}
