import 'dart:io' as io;

import 'package:cce/models/DOWNLOADABLEFILES.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class ListDownloads extends StatefulWidget {
  @override
  _ListDownloadsState createState() => _ListDownloadsState();
}

List<String> subjects;
List<DownloadableFile> downloadableFiles;

class _ListDownloadsState extends State<ListDownloads> {
  io.Directory savedDir;

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
          downloadableFiles.add(downloadableFile);
          print(downloadableFiles);
          checkForFiles();
          setState(() {});
        });
      });
    });
  }

  setWorkingDirectory() async {
    io.Directory baseDir = await getExternalStorageDirectory();
    print(baseDir.path);
    String localPath = baseDir.path + io.Platform.pathSeparator + 'Download';
    savedDir = io.Directory(localPath);
    print('savedDir: ${savedDir.path}');
    bool hasExisted = await savedDir.exists();
    print(hasExisted);
    if (!hasExisted) {
      print('creation //////////////');
      savedDir.create();
    }
    // }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
    // initializeFirestore();
    setWorkingDirectory();
  }

  Future<bool> checkIfFileExists(String fileName) async {
    print('${savedDir.path}/$fileName');
    var returned = await io.File('${savedDir.path}/$fileName').exists();
    print('returned from file: $returned');
    if (returned == true) {
      print('return called');
      return true;
    } else
      return false;
  }

  checkForFiles() {
    downloadableFiles.forEach((element) {
      print('processing: ${element.fileName}');
      checkIfFileExists(element.fileName).then((value) =>
          value ? element.isDownloaded = true : element.isDownloaded = false);
    });
  }

  Color fileStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0, actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FlatButton(
                // color: Colors.amber,
                onPressed: initializeFirestore,
                child: Text(
                  'FILES',
                  style: TextStyle(fontSize: 30, letterSpacing: 0.5),
                ),
              ),
              FlatButton(
                // color: Colors.amber,
                onPressed: initializeFirestore,
                child: Text(
                  'FIRESTORE',
                  style: TextStyle(fontSize: 30, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ]),
      body: ListView.builder(
          itemCount: downloadableFiles.length,
          itemBuilder: (context, index) {
            print(downloadableFiles[index].isDownloaded);

            return ListTile(
              tileColor: downloadableFiles[index].isDownloaded
                  ? Colors.lightGreen[400]
                  : Colors.orange[300],
              title: Text(downloadableFiles[index].fileName),
              subtitle: Text(downloadableFiles[index].moduleName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: downloadableFiles[index].isDownloaded
                          ? Icon(Icons.cloud_download)
                          : Icon(Icons.cloud_download_outlined),
                      onPressed: () async {
                        final taskId = await FlutterDownloader.enqueue(
                          fileName: downloadableFiles[index].fileName,
                          url: downloadableFiles[index].downloadUrl,
                          savedDir: savedDir.path,
                          showNotification:
                              true, // show download progress in status bar (for Android)
                          openFileFromNotification:
                              true, // click on notification to open downloaded file (for Android)
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }
}
