import 'package:flutter/material.dart';

class DownloadableFile {
  String moduleName;
  String fileName;
  String downloadUrl;

  DownloadableFile({
    @required this.moduleName,
    @required this.fileName,
    @required this.downloadUrl,
  });
}
