import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.photo_album,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 25),
              // home
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text("H O M E"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // profile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: const Text("P R O F I L E"),
                  onTap: () {
                    Navigator.pop(context);

                    // navigate to profile
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),

              // user
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(Icons.group),
                  title: Text("U S E R"),
                  onTap: () {
                    Navigator.pop(context);

                    // navigate to profile
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),

              // img picker
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(Icons.camera_front),
                  title: Text("I M A G E"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/image_picker');
                  },
                ),
              ),
              
              // update profile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(Icons.update),
                  title: Text("E D I T "),
                  onTap: () {
                    Navigator.pop(context);

                    // navigate to profile
                    Navigator.pushNamed(context, '/update_profile');
                  },
                ),
              ),

              // display profile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(Icons.group_add_rounded),
                  title: Text("D I S P L A Y "),
                  onTap: () {
                    Navigator.pop(context);

                    // navigate to profile
                    Navigator.pushNamed(context, '/display_profile');
                  },
                ),
              ),
            ],
          ),

          // logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: const Text("L O G O U T"),
              onTap: () {
                Navigator.pop(context);

                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
