import 'package:chat_app/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser!.uid;
    final stream =
        FirebaseFirestore.instance
            .collection("chat")
            .orderBy('createdAt', descending: true)
            .snapshots();
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("NO message Yet"));
        }
        final chatData = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatData.length,
          itemBuilder: (context, index) {
            final messageData=chatData[index];
            final curMessageUserId=messageData['userid'];
            final nextMessageUserId=index+1<chatData.length?chatData[index+1]['userid']:null;
            var isSameUser= (nextMessageUserId!=null && curMessageUserId==nextMessageUserId);
            if(isSameUser) {
              return MessageBubble.next(message: chatData[index]['text'], isMe: curMessageUserId==user);
            }
            else {
              return MessageBubble.first(
              userImage: chatData[index]['userImage'],
              username: chatData[index]['username'],
              message: chatData[index]['text'],
              isMe: curMessageUserId==user,
            );
            }
            
            
            
            //     return ListTile(
            //       leading: CircleAvatar(
            //         backgroundImage: NetworkImage(chatData[index]['userImage']),
            //       ),
            //       title: Text(chatData[index]['username']),
            //       subtitle: Text(chatData[index]['text']),
            //     );
          },
        );
      },
    );
  }
}
