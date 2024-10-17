import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosialmediaapp/components/my_button.dart';
import 'package:sosialmediaapp/components/my_textfield.dart';
import 'package:sosialmediaapp/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  //  method
  void registerUser() async {
    // show loading
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    // pass
    if (passwordController.text != confirmPwController.text) {
      // pop loading
      Navigator.pop(context);

      // show error
      displayMessageToUser("Password don't mastch", context);
    }

    // if pw do match

    // create user
    else {
      try {
        // create user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // user document
        createUserDocument(userCredential);

        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }
  }

  // continue user document
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
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

              // username txt
              MyTextfield(
                hintText: "Username..",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),

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

              // pw txt
              MyTextfield(
                hintText: "Confirm Password..",
                obscureText: true,
                controller: confirmPwController,
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
                text: "Register",
                onTap: registerUser,
              ),
              const SizedBox(height: 25),

              // dont hv acc
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login here",
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
