import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosialmediaapp/components/my_listtile.dart';
import 'package:sosialmediaapp/helper/helper_function.dart';

import '../components/my_back_button.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          // any error
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }
          // show loading circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Text("No data");
          }

          // get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              // back btn
              const Padding(
                padding: EdgeInsets.only(top: 50.0, left: 25),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),

              // list user

              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    // get individual user
                    final user = users[index];

                    // get data from each user
                    String username = user['username'];
                    String email = user['email'];

                    return MyListtile(
                      title: username,
                      subTitle: email,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
