import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Domain/auth_service.dart';

class SignUpScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign up with Google'),
          onPressed: () async {
            try {
              UserCredential userCredential =
                  await _authService.signUpWithGoogle();
              // User is signed up successfully, handle the next steps
            } catch (error) {
              // Handle sign-up error
            }
          },
        ),
      ),
    );
  }
}
