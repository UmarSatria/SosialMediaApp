import 'package:flutter/material.dart';
import 'package:sosialmediaapp/auth/auth.dart';
import 'package:sosialmediaapp/auth/login_or_register.dart';
import 'package:sosialmediaapp/pages/display_profile.dart';
import 'package:sosialmediaapp/pages/home_page.dart';
import 'package:sosialmediaapp/pages/image_picker.dart';
import 'package:sosialmediaapp/pages/profile_page.dart';
import 'package:sosialmediaapp/pages/update_profile.dart';
import 'package:sosialmediaapp/pages/users_page.dart';
import 'package:sosialmediaapp/themes/dark_mode.dart';
import 'package:sosialmediaapp/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      // darkT  heme: darkMode,
      theme: lightMode,
      routes: {
        '/login_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/users_page': (context) => const UsersPage(),
        '/image_picker': (context) => const ImagePickerPage(),
        '/update_profile': (context) => const UpdateProfile(),
        '/display_profile': (context) => DisplayProfile()
      },
    );
  }
}
