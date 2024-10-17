import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosialmediaapp/components/my_drawer.dart';
import 'package:sosialmediaapp/components/my_listtile.dart';
import 'package:sosialmediaapp/components/my_post_button.dart';
import 'package:sosialmediaapp/components/my_textfield.dart';
import 'package:sosialmediaapp/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore akses
  final FireStoreDatabase database = FireStoreDatabase();

  // text controller
  TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("P O S T "),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          // txt box for user type
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                // txt
                Expanded(
                  child: MyTextfield(
                    hintText: "Say something..",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post btn
                MyPostButton(
                  onTap: postMessage,
                )
              ],
            ),
          ),

          // POSTS
          StreamBuilder(
            stream: database.getPostStream(),
            builder: (context, snapshot) {
              // show loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all post
              final posts = snapshot.data?.docs;

              // no data?
              if (posts == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No post.. Post something!"),
                  ),
                );
              }

              // return as a list wrapped with Expanded
              return Expanded(
                // Expanded hanya membungkus ListView
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data of each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    // return list tile
                    return MyListtile(title: message, subTitle: userEmail);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
