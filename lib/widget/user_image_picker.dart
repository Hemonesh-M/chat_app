import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: must_be_immutable
class UserImagePicker extends StatefulWidget {
  const UserImagePicker({required this.onPickProfileImage,super.key});
  final Function(File? profileImage) onPickProfileImage;
  @override
  State<UserImagePicker> createState() {
    return _UserImagePlaceState();
  }
}

class _UserImagePlaceState extends State<UserImagePicker> {
  File? _pickedImgFile;
  void pickImage()async{
    final pickedImg=await ImagePicker().pickImage(source: ImageSource.camera);
    if(pickedImg==null) return;
    setState(() {
      _pickedImgFile=File(pickedImg.path);
    });
    widget.onPickProfileImage(_pickedImgFile);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImgFile!=null?FileImage(_pickedImgFile!):null,
          radius: 80,
          child: _pickedImgFile==null?Center(child: Text("No Image Selected")):null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          label: Text(_pickedImgFile==null? "Add Image":"Change Image",style: TextStyle(
            color: Theme.of(context).colorScheme.primary
          ),),
          icon: Icon(Icons.image),
          
        ),
      ],
    );
  }
}
