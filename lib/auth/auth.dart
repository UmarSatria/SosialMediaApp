import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosialmediaapp/auth/login_or_register.dart';
import 'package:sosialmediaapp/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is login
          if (snapshot.hasData) {
            return HomePage();
          } else {  
            return const LoginOrRegister();
          }
          //
        },
      ),
    );
  }
}
