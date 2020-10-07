import 'package:cce/models/DOWNLOADABLEFILES.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListDownloads extends StatefulWidget {
  @override
  _ListDownloadsState createState() => _ListDownloadsState();
}

List<String> subjects;
List<DownloadableFile> downloadableFiles;

class _ListDownloadsState extends State<ListDownloads> {
  Future<void> initializeFirestore() async {
    subjects = [];
    downloadableFiles = [];
    // DocumentReference subjectListCollection =
    //     FirebaseFirestore.instance.collection("noMap").doc('S1CSE');
    // print(subjectListCollection
    //     .get()
    //     .then((value) => print(value.data()['Subject Names'])));

    DocumentReference collection =
        FirebaseFirestore.instance.collection('S1CSE').doc('Subject names');
    collection
        .get()
        .then((value) => value.data().forEach((key, value) {
              print('key: $key value: $value');
              subjects.add(value);
            }))
        .then((value) {
      print(subjects);
      DocumentReference downloadCollection =
          FirebaseFirestore.instance.collection('S1CSE').doc(subjects[0]);
      downloadCollection.get().then((value) {
        value.data().forEach((key, value) {
          DownloadableFile downloadableFile = DownloadableFile(
              moduleName: value['moduleName'],
              fileName: value['fileName'],
              downloadUrl: value['downloadUrl']);
          print(downloadableFile.downloadUrl);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FlatButton(
        onPressed: initializeFirestore,
        child: Text(
          'FIRESTORE',
          style: TextStyle(fontSize: 30),
        ),
      ),
    ));
  }
}
