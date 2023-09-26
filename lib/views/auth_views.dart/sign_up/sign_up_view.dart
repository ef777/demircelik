import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'components/signup_form.dart';
import 'components/socal_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Ol"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: context.height * .02,
          ),
          const Center(
            child: Text(
              "X",
              style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: context.height * .02,
          ),
          Row(
            children: const [
              Spacer(),
              Expanded(
                flex: 26,
                child: SignUpForm(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
