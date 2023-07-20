import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:start/homw.dart';
import 'package:start/screen/google_sign.dart';
import '../constans/colors.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_form_fild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Auth.dart';
import './sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // The variable related to showing or hidingf the text
  bool obscure = false;
  bool isLogin = true;
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  //The variable key related to the txt fild
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Please enter your account here",
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the password";
                            } else {
                              return null;
                            }
                          },
                          obscureText: obscure,
                          hint: "Password",
                          controller: _controllerPassword,
                          prefixIcon: IconlyBroken.lock,
                          suffixIcon: obscure == false
                              ? IconlyBroken.show
                              : IconlyBroken.hide,
                          onTapSuffixIcon: () {
                            setState(() {});
                            obscure = !obscure;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                            text: "Sign In",
                            color: primary,
                            onTap: () async {
                              setState(() {
                                if (key.currentState!.validate()) {
                                  isLogin
                                      ? null
                                      : showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => Center(
                                              child:
                                                  CircularProgressIndicator()));
                                }
                                try {
                                  final user =
                                      Auth().signInWithEmailAndPassword(
                                    email: _controllerEmail.text.trim(),
                                    password: _controllerPassword.text.trim(),
                                  );
                                  if (user == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavigationExample(),
                                        ));
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              });
                            }),
                        Text(
                          'Or continue with',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: SecondaryText),
                        ),
                        CustomButton(
                          onTap: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogin();
                          },
                          text: "G google",
                          color: Secondary,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont have any account?",
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
                                        builder: (context) => SignUpScreen(),
                                      ));
                                },
                                child: Text(
                                  "Sign Up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: primary),
                                ))
                          ],
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
