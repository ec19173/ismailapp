import 'package:firebase_auth/firebase_auth.dart';
import 'package:ismailapp/screens/post/post_screen.dart';
import 'package:ismailapp/screens/profile/profile_screen.dart';
import 'package:ismailapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import 'borrow/borrow_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print("Renting out screen");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostScreen()));
              },
              child: Text("Rent Out"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print("Borrowing screen");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BorrowScreen()));
              },
              child: Text("Borrow"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print("profile screen");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Text("Profile"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
