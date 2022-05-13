import 'package:flutter/material.dart';
import 'package:ismailapp/components.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:ismailapp/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:ismailapp/reusable_widgets/reusable_widget.dart';

import 'package:firebase_storage/firebase_storage.dart'; // as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ismailapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  TextEditingController _amountTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late String imageUrl;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('items').snapshots();

  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('items');

    Future<void> addItem(title, desc, amount, imageUrl) {
      // Call the user's CollectionReference to add a new user
      return items
          .add({
            'title': title, // John Doe
            'description': desc, // Stokes and Sons
            'amount': amount, // 42,
            'imageUrl': imageUrl
          })
          .then(
            (value) => () {
              print("Item Added");
            },
          )
          .catchError((error) => print("Failed to add item: $error"));
    }

    productValidator(value, message) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    }

    uploadImage() async {
      final _firebaseStorage = FirebaseStorage.instance;
      final _imagePicker = ImagePicker();
      PickedFile image;
      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        //Select Image
        image = (await _imagePicker.getImage(source: ImageSource.gallery))!;
        var file = File(image.path);

        if (image != null) {
          //Upload to Firebase
          var snapshot = await _firebaseStorage
              .ref()
              .child('images/${DateTime.now()}')
              .putFile(file)
              .whenComplete(() => null);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl = downloadUrl;
            print("The image url: " + imageUrl);
          });
        } else {
          print('No Image Path Received');
        }
      } else {
        print('Permission not granted. Try Again with permission access');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Upload'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        return productValidator(
                            value, 'Please enter product name');
                      },
                      controller: _titleTextController,
                      decoration: const InputDecoration(
                          labelText: 'Product',
                          border: OutlineInputBorder(),
                          hintText: 'Product Title'),
                      autofocus: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        return productValidator(
                            value, 'Missing product description');
                      },
                      controller: _descriptionTextController,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          hintText: 'Brief Item Description'),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) {
                        return productValidator(
                            value, "Please enter the amount");
                      },
                      controller: _amountTextController,
                      decoration: const InputDecoration(
                          labelText: 'Fee',
                          border: OutlineInputBorder(),
                          hintText: 'Hiring amount'),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          uploadImage();
                        },
                        child: Text('Attach Image')),
                    ElevatedButton(
                      child: Text('Upload Item'),
                      onPressed: () async {
                        print('pressed');
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Processing Data')),
                          // );
                          await addItem(
                              _titleTextController.text,
                              _descriptionTextController.text,
                              _amountTextController.text,
                              imageUrl);
                          _titleTextController.clear();
                          _descriptionTextController.clear();
                          _amountTextController.clear();

                          Fluttertoast.showToast(
                              msg: "Item Successfuly Uploaded",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                        await addItem(
                            _titleTextController.text,
                            _descriptionTextController.text,
                            _amountTextController.text,
                            imageUrl);
                        _titleTextController.clear();
                        _descriptionTextController.clear();
                        _amountTextController.clear();

                        Fluttertoast.showToast(
                            msg: "Item Successfuly Uploaded",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
