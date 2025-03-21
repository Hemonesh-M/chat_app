// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class UploadProfileImage extends StatefulWidget {
  final File imageFile; // Pass the image file

  const UploadProfileImage({super.key, required this.imageFile});

  @override
  State<UploadProfileImage> createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    uploadImageToImageKit(widget.imageFile);
  }

  // 🔹 Upload Image to ImageKit.io
  Future<void> uploadImageToImageKit(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
    );

    request.fields['fileName'] =
        'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // 🔥 Replace with your actual API key
    String apiKey = 'private_4GZCeQLgG6Jk03Oy+vt2JmcnkIc=';
    String basicAuth = 'Basic ${base64Encode(utf8.encode("$apiKey:"))}';

    request.headers['Authorization'] = basicAuth;
    request.headers['Content-Type'] = 'multipart/form-data';

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      setState(() {
        _uploadedImageUrl = jsonResponse['url']; // Get uploaded image URL
      });

      print("✅ Image Uploaded: $_uploadedImageUrl");
      await updateUserProfile(_uploadedImageUrl!); // Store in Firestore
    } else {
      print("❌ Upload Failed: ${response.reasonPhrase}");
    }
  }

  // 🔹 Update Firestore with Profile Image
  Future<void> updateUserProfile(String imageUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(
        {'profileImage': imageUrl},
        SetOptions(merge: true),
      );
      print("✅ Profile Image Updated for User: ${user.uid}");
    }
      print("FAiled");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploading Image...")),
      body: Center(
        child: _uploadedImageUrl == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(_uploadedImageUrl!), // Show uploaded image
                  const SizedBox(height: 20),
                  const Text("🎉 Image Uploaded Successfully!"),
                ],
              ),
      ),
    );
  }
}
