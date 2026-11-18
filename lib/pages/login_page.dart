import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 162, 234),

      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(30, 65, 30, 65),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 25),

            Text('Objetos perdidos USM Viña', style: TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.bold)),

            SizedBox(height: 12),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {

                    GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
                    GoogleSignInAuthentication googleAuth = googleUser.authentication;
                    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

                    await FirebaseAuth.instance.signInWithCredential(credential);

                  } catch (e){

                    debugPrint('Error iniciar sesion: $e');

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No se pudop iniciar sesion'))
                    );

                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 194, 216, 249),
                  foregroundColor: Color.fromARGB(255, 0, 0, 0),
                  padding: EdgeInsets.all(18)
                ),
                child: Text('Continuar con google')
                ),
            )
          ],

        ),
      ),
    );
  }
}