// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Auth extends StatefulWidget {
  const Auth({super.key});
  @override
  State<Auth> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _enteredEmail = "";
  String _enteredPass = "";
  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // print(_enteredEmail);
    // print(_enteredPass);
    try {
      if (_isLogin) {
        final token = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPass,
        );

        // Navigator.of(
        //   context,
        // ).pushReplacement(MaterialPageRoute(builder: (context) => ChatScreen()));
        // print(UserCredential);
      } else {
        final UserCredentialdata = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPass,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        // try to log in
      }
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? "Authentication Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  right: 20,
                  left: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "abc@gmail.com",
                            // helperText: "abc@gmail.com",
                            label: Text(
                              "Email ID",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          // initialValue: "abc@gmail.com",
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Please Enter a Valid Email Address";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(
                              "Password ",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          // initialValue: "Doesy123@",
                          onSaved: (newValue) {
                            _enteredPass = newValue!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().length < 8) {
                              return "Length Should be more than 8 characters";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: _onSubmit,
                          label: Text(_isLogin ? "Login " : "Sign Up"),
                          icon: Icon(Icons.save),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? "Don't Have an account "
                                : "Already Have an account",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
