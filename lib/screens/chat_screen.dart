import 'package:chat_app/widget/chat_messages.dart';
import 'package:chat_app/widget/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("XChat"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () async {
              try {
                await _firebase.signOut();
                // await FirebaseAuth.instance.signOut();
                /* we Dont need to switch to Auth Screen Firebase Automatically creates a snapshot with no data 
                 so we switch because of Stream Builder in main file*/

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return Auth();
                //     },
                //   ),
                // );
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("User Log-Out FAILED")));
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage()
        ],  
      )
    );
  }
}
