import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'utilities/googleSignIn.dart';
import 'utilities/auth_login.dart';
import 'DietHomePage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    void goToHomePage() {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
    }

    void goToDietHomePage(){
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => DietHomePage()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              textDirection: TextDirection.ltr,
              key: Key('Email'),
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              textDirection: TextDirection.ltr,
              key: Key('Password'),
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',  
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              key: Key('LoginButton'),
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.amber.shade800)),
              onPressed: () async {
                final message = await AuthLogin().login(
                    email: emailController.text,
                    password: passwordController.text);
                if (message!.contains('Success')) {
                  try {
                    final User? user = auth.currentUser;
                    final String? uid = user?.uid;
                    
                    if (uid == 'OP1vNwQeqValaF5kwarne35SZSW2') {
                      goToDietHomePage();
                    }else {
                      goToHomePage();
                    }

                    
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'))
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
                height: 16,
                child: Text("or",
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13))),
            ElevatedButton(
                key: Key('GoogleLoginButton'),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Color.fromRGBO(244, 244, 232, 1))),
                onPressed: () async {
                  await signInWithGoogle();
                  goToDietHomePage();
                },
                child: const Text('Sign in with Google'))
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(244, 244, 232, 1),
    );
  }
}
