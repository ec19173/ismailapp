import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:ismailapp/screens/product_details/product_screen.dart';
import 'package:ismailapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Product.dart';
import 'product_details/components/product_description.dart';

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
      print(">>>>>>>>>>>>>>>>>>>>submitted");
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
        onCleared: () {
          print(">>>>>>>>>>>>>>>>>>>>Search bar has been cleared");
        },
        onClosed: () {
          print(">>>>>>>>>>>>>>>>>>>>Search bar has been closed");
        });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text('Recently uploaded items'),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: firestoreInstance
                    .collection('items')
                    .orderBy('amount', descending: true)
                    .snapshots(),
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
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '💰\$ ${document.get('amount')}',
                              style: TextStyle(
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
