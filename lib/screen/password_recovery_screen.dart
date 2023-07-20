import '../screen/new_password_screen.dart';
import '../widget/custom_Text_Form_fild.dart';
import '../widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Password recovery',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Enter your email to recover your password",
                style: Theme.of(context).textTheme.bodyText1),
          ),
          CostomTextFormFild(
            hint: "Email or phone number",
            prefixIcon: IconlyBroken.message,
          ),
          CustomButton(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewPasswordScreen(),
                    ));
              },
              text: "Next"),
        ]),
      ),
    );
  }
}
