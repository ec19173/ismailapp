import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ismailapp/screens/manageitem/manageitem_screen.dart';

import '../product_details/product_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  getActiveStream({String? searchphrase}) {
    return firestoreInstance
        .collection('items')
        .where('available', isEqualTo: true)
        .where('uploadedby', isEqualTo: auth.currentUser?.uid)
        // .orderBy('monthlyamount', descending: true)
        .snapshots();
  }

  getInactiveStream({String? searchphrase}) {
    return firestoreInstance
        .collection('items')
        .where('available', isEqualTo: false)
        .where('uploadedby', isEqualTo: auth.currentUser?.uid)
        // .orderBy('monthlyamount', descending: true)
        .snapshots();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: Column(
        children: [
          Row(
            children: const [
              Expanded(child: Text('Actively listed items')),
            ],
          ),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: getActiveStream(),
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
                              builder: (context) => ManageItemScreen(
                                docID: document.reference.id.toString(),
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
          Row(
            children: const [
              Expanded(child: Text('Deactivated items')),
            ],
          ),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: getInactiveStream(),
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
                              builder: (context) => ManageItemScreen(
                                docID: document.reference.id.toString(),
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
          Row(
            children: const [
              Expanded(child: Text('Previously rented items')),
            ],
          ),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: getActiveStream(),
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
                              builder: (context) => ManageItemScreen(
                                docID: document.reference.id.toString(),
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
