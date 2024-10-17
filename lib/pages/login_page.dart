import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosialmediaapp/components/my_button.dart';
import 'package:sosialmediaapp/components/my_textfield.dart';
import 'package:sosialmediaapp/helper/helper_function.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // login method
  void login() async{
    // show loading

    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, 
      password: passwordController.text);

      // pop loading
      if (context.mounted) Navigator.pop(context);
    }

    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              //title
              const Text(
                "N O V A",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 50),

              // email txt
              MyTextfield(
                hintText: "Email..",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),

              // pw txt
              MyTextfield(
                hintText: "Password..",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),

              // forgot pw
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // sign in btn
              MyButton(
                text: "Login",
                onTap: login,
              ),
              const SizedBox(height: 25),

              // dont hv acc
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
