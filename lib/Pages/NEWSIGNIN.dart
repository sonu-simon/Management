import 'package:cce/Pages/LISTDOWNLOADS.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NEWSIGNIN extends StatefulWidget {
  @override
  _NEWSIGNINState createState() => _NEWSIGNINState();
}

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<void> signinFn() async {
  await firebaseAuth.signInWithEmailAndPassword(
      email: "itsme@gmail.com", password: "yeahme");
}

class _NEWSIGNINState extends State<NEWSIGNIN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IconButton(
        icon: Icon(Icons.login),
        onPressed: () {
          signinFn().then((_) {
            print(' user: ${firebaseAuth.currentUser}');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListDownloads()));
          });
        },
      )),
    );
  }
}
