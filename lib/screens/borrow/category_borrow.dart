import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:ismailapp/screens/product_details/product_screen.dart';
import 'package:ismailapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/Product.dart';
import '../post/post_screen.dart';
import '../product_details/components/product_description.dart';
import '../profile/profile_screen.dart';

class CategoryBorrowScreen extends StatefulWidget {
  final String category;
  const CategoryBorrowScreen(this.category, {Key? key}) : super(key: key);

  @override
  _CategoryBorrowScreenState createState() => _CategoryBorrowScreenState();
}

class _CategoryBorrowScreenState extends State<CategoryBorrowScreen> {
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

  _CategoryBorrowScreenState() {
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

  getStream(String searchPhrase) {
    return firestoreInstance
        .collection('items')
        .where('category', isEqualTo: searchPhrase)
        .where('available', isEqualTo: true)
        // .orderBy('amount', descending: true) //requires indexing in firestore
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
          Text(widget.category),
          const SizedBox(
            height: 20,
          ),
          Text('Recently uploaded items in ' + widget.category + ' category'),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: getStream(widget.category),
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
