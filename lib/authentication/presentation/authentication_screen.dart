import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(Buttons.google, onPressed: () {});
  }
}