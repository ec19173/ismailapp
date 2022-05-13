import 'package:firebase_auth/firebase_auth.dart';
import 'package:ismailapp/screens/post/post_screen.dart';
import 'package:ismailapp/screens/profile/profile_screen.dart';
import 'package:ismailapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import '../borrow/borrow_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

cardBuilder(title, link) {
  return Card(
    child: Column(
      children: [
        Text(title),
        Image.network(
          link,
          width: 150,
          height: 150,
        )
      ],
    ),
  );
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashBoard'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            // color: Colors.blueGrey,
            borderRadius: const BorderRadius.all(const Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostScreen()));
                  },
                  child: cardBuilder('Rent Out',
                      'https://boostlikes-bc85.kxcdn.com/blog/wp-content/uploads/2016/03/Facebook-Page-For-Rent.jpg'),
                ),
                GestureDetector(
                  onTap: () {
                    // print("Borrowing screen");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BorrowScreen()));
                  },
                  child: cardBuilder('Borrow',
                      'https://www.pngitem.com/pimgs/m/476-4766026_helping-hands-circle-helping-hands-cartoon-hd-png.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // print("profile screen");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                  child: cardBuilder('Profile',
                      'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                ),
                GestureDetector(
                  child: cardBuilder('Logout',
                      'https://www.computerhope.com/issues/pictures/logout.jpg'),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      // print("Signed Out");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
