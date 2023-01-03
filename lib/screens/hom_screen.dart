import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoapp/screens/signin_screen.dart';

class HomScreen extends StatelessWidget {
  const HomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextButton(
              child: Container(

                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.logout_outlined),
                ),
              ),

          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,




        
      ),
    body: Center(

    ),
    );
  }
}
