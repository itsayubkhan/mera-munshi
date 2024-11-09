import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mera_munshi/utils/Googledrive_helper.dart';
import '../Components/Squaretile.dart';
import '../Components/myTextfield.dart';
import '../Components/mybutton.dart';
import 'Homepage.dart';

class loginpage2 extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled the sign-in");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print('Signed in as: ${user.displayName}');
        // Here you can also store user information, if needed
        return user;
      }
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
    return null;
  }


  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  loginpage2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/img/logo.png',
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Mera Munshi',
                style: TextStyle(
                    fontSize: 27,
                    fontFamily: 'Eina',
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'Enter Your Email',
                padding: const EdgeInsets.symmetric(horizontal: 25),
                controller: email,
                hintText: '',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: true,
                  controller: password,
                  style: TextStyle(fontFamily: 'Eina',color: Colors.grey[700]),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'Eina',color: Colors.grey[500]),
                      labelText: 'Enter Your Password',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      hintText: '',
                      enabledBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintStyle: TextStyle(fontFamily: 'Eina',color: Colors.grey[500])
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Forgot the password?',
                style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 18,
              ),
              MyButton(
                ontap: () {
                  backupDatabase();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                  final snackBar = SnackBar(
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.grey[500],
                    content: const Text(
                      'Request time out',
                      style: TextStyle(fontFamily: 'Eina', color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                text: 'Sign in',
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SquareTile(
                ImagePath: 'assets/img/google.png',
                height: 25,
                ontap: () async {
                  User? user = await signInWithGoogle();
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage(user: user)),
                    );
                  }
                },
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style:
                        TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'Register now',
                    style: TextStyle(fontFamily: 'Eina', color: Colors.blue),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
