// login_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'register_page.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.getRedirectResult();
        if (userCredential.user != null) {
          // User successfully signed in.
          _navigateToNextPage(userCredential.user!);
        }
      } catch (e) {
        // Handle error.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal')),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToNextPage(FirebaseAuth.instance.currentUser!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToNextPage(User user) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(user.uid);
    DatabaseEvent event = await userRef.once();
    Map<dynamic, dynamic>? userData =
        event.snapshot.value as Map<dynamic, dynamic>?;

    if (userData != null) {
      if (userData['role'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/user');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Aplikasi Pemesanan Ruang Studi',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                      ),
                      child: Text('Sign in with Google'),
                    ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Belum punya akun? Daftar disini',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
