import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:start/Auth.dart';
import 'package:start/screen/google_sign.dart';
import '../homw.dart';
import '../screen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return const BottomNavigationExample();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
