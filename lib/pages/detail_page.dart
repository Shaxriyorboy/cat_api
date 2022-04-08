import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service/http_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? file;

  Future _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        file = File(image.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  _uploadImage() async {
    await Network.MULTIPART(
            Network.API_UPLOAD, file!.path, Network.paramsEmpty())
        .then((value) => {
              if (value != null)
                {
                  Navigator.of(context).pop(true),
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          GestureDetector(
            onTap: () {
              _getImage();
            },
            child: file == null
                ? Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/gallery.jpg"),
                      ),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image(
                      image: FileImage(file!),
                      fit: BoxFit.cover,
                      height: 300,
                      width: 300,
                    ),
                  ),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              height: 50,
              color: Colors.blue,
              onPressed: () {
                _uploadImage();
              },
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              minWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
