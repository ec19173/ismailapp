import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:ismailapp/screens/borrow/category_borrow.dart';
import 'package:ismailapp/screens/product_details/product_screen.dart';
import 'package:ismailapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_borrow.dart';

import '../../models/Product.dart';
import '../post/post_screen.dart';
import '../product_details/components/product_description.dart';
import '../profile/profile_screen.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({Key? key}) : super(key: key);

  @override
  _BorrowScreenState createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text('Search Items'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() {
      // print(">>>>>>>>>>>>>>>>>>>>submitted");
      var context = _scaffoldKey.currentContext;

      if (context == null) {
        return;
      }

      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text('You wrote "$value"!')));
    });
  }

  _BorrowScreenState() {
    searchBar = SearchBar(
      inBar: false,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      // onCleared: () {
      //   print(">>>>>>>>>>>>>>>>>>>>Search bar has been cleared");
      // },
      // onClosed: () {
      //   print(">>>>>>>>>>>>>>>>>>>>Search bar has been closed");
      // },
    );
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  final firestoreInstance = FirebaseFirestore.instance;

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

  getStream({String? searchphrase}) {
    return firestoreInstance
        .collection('items')
        .where('available', isEqualTo: true)
        .orderBy('monthlyamount', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text('Categories'),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                // color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                builder: (context) =>
                                    const CategoryBorrowScreen(
                                      'Film and Photography',
                                    )));
                      },
                      child: cardBuilder('Film and Photography',
                          'https://www.easybasicphotography.com/uploads/8/1/3/6/81363426/published/canon-t7i_1.jpg'),
                    ),
                    GestureDetector(
                      onTap: () {
                        // print("Audio Visual Equipment");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategoryBorrowScreen(
                                        'Audio Visual Equipment')));
                      },
                      child: cardBuilder('Audio Visual Equipment',
                          'https://2.imimg.com/data2/SS/RX/MY-902661/full-audio-visual-equipment-500x500.jpg'),
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
                                builder: (context) =>
                                    CategoryBorrowScreen('Camping Gear')));
                      },
                      child: cardBuilder('Camping Gear',
                          'https://taskandpurpose.com/uploads/2021/12/02/best-camping-gear.jpeg'),
                    ),
                    GestureDetector(
                      child: cardBuilder('Others',
                          'https://icon-library.com/images/others-icon/others-icon-13.jpg'),
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          // print("Signed Out");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoryBorrowScreen('Others')));
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Text('Recently uploaded items'),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: getStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    // padding: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.all(20.0),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                title: document.get('title'),
                                description: document.get('description'),
                                imageURL: document.get('imageUrl'),
                              ),
                            ),
                          );
                        },
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 10.0, 0, 5),
                        leading: Image.network(
                          document.get('imageUrl'),
                          width: 100,
                          height: 800,
                        ),
                        // title: Text(document.get('title')),
                        title: Row(
                          children: <Widget>[
                            Text(
                              document.get('title'),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '💰\$ ${document.get('dailyamount')}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        subtitle: Text(
                          document.get('description'),
                          maxLines: 3,
                          // style: textStyle.get('description'),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
