import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudStorage extends StatefulWidget {
  const CloudStorage({super.key});

  @override
  State<CloudStorage> createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  // 스토리지 인스턴스
  final storage = FirebaseStorage.instance;

  // 스토리지 참조
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    // 더 낮은 수준의 참조
    Reference? imagesRef = storageRef.child('images');
    final theImage =
        imagesRef.child('FA044515-C394-4F88-BEF4-6149628921A8.jpeg');
    final fullPath = theImage.fullPath;
    final bucket = theImage.bucket;
    final name = theImage.name;

    final gsReference = storage.refFromURL("gs://${bucket}/${fullPath}");
    // final httpsReference = storage.refFromURL(
    //     "https://firebasestorage.googleapis.com/b/${bucket}/o/${fullPath}");
    // final imageUrl = getCloudStorageUrl(theImage);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            child: Text("fullPath : ${fullPath}"),
          ),
          Container(
            child: Text("bucket : ${bucket}"),
          ),
          Container(
            child: Text("name : ${name}"),
          ),
          Container(
            child: Text("gsReference : ${gsReference}"),
          ),
          // Container(
          //   child: Text("httpsReference : ${httpsReference}"),
          // ),
          // Container(
          //   child: Image.network("${httpsReference}"),
          // ),
          // Container(
          //   child: Text("imageUrl : ${imageUrl}"),
          // ),
          // Container(
          //   child: Image.network("${imageUrl}"),
          // ),
        ],
      ),
    );
  }

  Future<String> getCloudStorageUrl(Reference reference) async {
    String result = await reference.getDownloadURL();
    setState(() {});
    return result;
  }
}
