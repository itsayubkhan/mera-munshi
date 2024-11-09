import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'utils/auth_service.dart';
import 'pages/Homepage.dart';
import 'pages/Splashscreen.dart';
import 'pages/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'pages/loginpage2.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.grey[400], // Set status bar color
      systemNavigationBarColor: Colors.grey[500],
      systemNavigationBarDividerColor: Colors.grey[700],// Set navigation bar color// Set navigation bar icon brightness
    ),
  );
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated options
  );
  runApp(const MyApp());
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.userStream,
      builder: (context, snapshot) {
        // Debugging: Print the connection state and data
        print('AuthWrapper StreamBuilder: Connection state: ${snapshot.connectionState}');
        if (snapshot.hasError) {
          print('AuthWrapper StreamBuilder: Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          print('AuthWrapper StreamBuilder: User is ${user?.email ?? 'null'}');

          if (user != null) {
            // Ensure Homepage can accept a User parameter or adjust accordingly
            return Homepage(user: user);
          } else {
            return loginpage2();
          }
        }

        // Show a loading indicator while waiting for the stream
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
