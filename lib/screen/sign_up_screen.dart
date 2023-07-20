import 'package:firebase_auth/firebase_auth.dart';
import 'package:start/main.dart';
import 'package:start/screen/sign_in.dart';
import 'package:start/screen/verification.dart';

import '../constans/colors.dart';
import './verification.dart';
import '../widget/custom_Text_Form_fild.dart';
import '../widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../Auth.dart';
import '../../EdithProfiles/page/edit_profile_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // The variable related to showing or hidingf the text
  bool obscure = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  //The variable key related to the txt fild
  final key = GlobalKey<FormState>();

  //The validator key related to the text field
  bool _contansANumber = false;
  bool _numberofDigits = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        reverse: true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Welcome",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Create your account here",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      CostomTextFormFild(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the email";
                          } else {
                            return null;
                          }
                        },
                        hint: "Email or phone number",
                        controller: _controllerEmail,
                        prefixIcon: IconlyBroken.message,
                      ),
                      CostomTextFormFild(
                        onChanged: (value) {
                          setState(() {
                            _numberofDigits = value.length < 8 ? false : true;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the password";
                          } else {
                            return null;
                          }
                        },
                        obscureText: obscure,
                        hint: "Password",
                        prefixIcon: IconlyBroken.lock,
                        controller: _controllerPassword,
                        suffixIcon: obscure == true
                            ? IconlyBroken.show
                            : IconlyBroken.hide,
                        onTapSuffixIcon: () {
                          setState(() {});
                          obscure = !obscure;
                        },
                      ),
                      // Part about password terms
                      passwordTerms(
                          contains: _contansANumber, ateast6: _numberofDigits),
                    ],
                  ),
                ),
                CustomButton(
                    text: "Sign Up",
                    color: primary,
                    onTap: () {
                      setState(() {
                        if (key.currentState!.validate()) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  Center(child: CircularProgressIndicator()));
                          Auth().createUserWithEmailAndPassword(
                            email: _controllerEmail.text.trim(),
                            password: _controllerPassword.text.trim(),
                          );
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        }
                      });
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Alreafy have account?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: mainText),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                        },
                        child: Text(
                          "Sign In",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: primary),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  // Part about password terms
  passwordTerms({
    required bool contains,
    required bool ateast6,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Your password must cotain :",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: mainText),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: ateast6 == false ? outline : Color(0xFFE3FFF1),
              child: Icon(
                Icons.done,
                size: 12,
                color: ateast6 == false ? SecondaryText : primary,
              ),
            ),
            Text(
              "  Atleast 6 characters",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: ateast6 == false ? SecondaryText : mainText),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: contains == false ? outline : Color(0xFFE3FFF1),
              child: Icon(
                Icons.done,
                size: 12,
                color: contains == false ? SecondaryText : primary,
              ),
            ),
            Text(
              "  Contains a number",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: contains == false ? SecondaryText : mainText),
            )
          ],
        ),
      ],
    );
  }
}
