import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _messageController = TextEditingController();
  String message = "";
  void onSend() async{
    message = _messageController.text;
    setState(() {
      _messageController.clear();
    });
    FocusScope.of(context).unfocus();
    final user=FirebaseAuth.instance.currentUser!;
    final userdata=await FirebaseFirestore.instance.collection('user-metadata').doc(user.uid).get();
    
    await FirebaseFirestore.instance.collection('chat').add({
      'userid':user.uid,
      'createdAt':Timestamp.now(),
      'text':message,
      'username':userdata.data()!['username'],
      'userImage':userdata.data()!['imgURL']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 17, right: 1, bottom: 19),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Send  Message...",
                hintText: "Hey! How you Doing ?",
              ),
              enableSuggestions: true,
              controller: _messageController,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                if (_messageController.text.length == 1 ||
                    _messageController.text.isEmpty) {
                  setState(() {});
                }
              },
            ),
          ),
          IconButton(
            onPressed:
                _messageController.text.trim().isNotEmpty ? onSend : null,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
