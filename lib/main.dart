import 'dart:convert';
import 'dart:io';
import 'package:crucks/models/monthPredict.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Recommendation.dart';
import 'Splash_page.dart';
import 'package:dio/src/multipart_file.dart';
import 'button_widget.dart';
import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/drive/v3.dart' as ga;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropDownButton',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );
      if (result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
      }
      print("File name $_fileName");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void upload(String filename, String url) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("http://127.0.0.1:5675"));
    request.files.add(http.MultipartFile(
        'file',
        File(_fileName.toString()).readAsBytes().asStream(),
        File(filename).lengthSync(),
        filename: "data.csv"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FeelMeal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : ButtonWidget(
                    text: 'Upload .csv',
                    onClicked: () {
                      pickFile();
                    }),
            //TextButton(onPressed: () {
            //   pickFile();
            // }, child: Text("Pick File")),
            if (pickedfile != null)
              // SizedBox(
              //     width: 400, height: 300, child: Image.file(fileToDisplay!)),
              SizedBox(height: 40, width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _fileName?.toString() ?? " ",
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20, fontFamily: 'Roboto'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Rx<MonthPredict?> recommendation = Rx(null);
  void fetchdata() async {
    final response = await get(Uri.parse("http://127.0.0.1:5675/result"));
    Map<String, dynamic> json = jsonDecode(response.body);

    recommendation.value = MonthPredict.fromJson(json);
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }
}
