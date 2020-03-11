import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageService{

  void writeFile(String fileName, String data) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;

    File file = new File('$documentsPath/$fileName');
    if(!file.existsSync()) {
      file.createSync();
    }

    print("saving $fileName...");
    await file.writeAsString(data);//默认从头开始读
  }

  Future<String> readFile(String fileName) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;

    File file = new File('$documentsPath/$fileName');

    if(!file.existsSync()) {
      return null;
    }

    print("loading $fileName...");
    return await file.readAsString();
  }

  void deleteFile(String fileName) async{
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;

    File file = new File('$documentsPath/$fileName');
    if(file.existsSync()) {
      file.deleteSync();
      print("delete $fileName...");
    }
  }
}