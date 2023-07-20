import '../constans/colors.dart';
import '../screen/password_recovery_screen.dart';
import '../widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class VerificationCode extends StatefulWidget {
  const VerificationCode({Key? key}) : super(key: key);
  @override
  State<VerificationCode> createState() => EmailVerificationScreen();
}

class EmailVerificationScreen extends State<VerificationCode> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 90), (_) => checkEmailVerified());
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "check your email",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "We.ve sent the activation Link to your email ${FirebaseAuth.instance.currentUser?.email}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'Verifying email....',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                CustomButton(
                    onTap: () {
                      try {
                        FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    text: "Resend"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
