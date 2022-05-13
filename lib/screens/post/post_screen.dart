import 'package:flutter/cupertino.dart';
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

import '../dashboard/Dashboard.dart';
import '../home_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String categorydropdownValue = 'Camping Gear';
  String conditionDropDownValue = 'Acceptable';
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  TextEditingController _itemValueTextController = TextEditingController();
  TextEditingController _dailyamountTextController = TextEditingController();
  TextEditingController _weeklyamountTextController = TextEditingController();
  TextEditingController _monthlyamountTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late String imageUrl;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('items').snapshots();

  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('items');

    Future<void> addItem(
        title, desc, damount, wamount, mamount, imageUrl, itemValue) {
      // Call the user's CollectionReference to add a new user
      return items
          .add({
            'title': title, // John Doe
            'description': desc, // Stokes and Sons
            'dailyamount': damount, // 42,
            'weeklyamount': wamount,
            'monthlyamount': mamount,
            'imageUrl': imageUrl,
            'value': itemValue,
            'category': categorydropdownValue,
            'condition': conditionDropDownValue,
            'available': true,
            'uploadedby': auth.currentUser?.uid,
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
                    const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return productValidator(
                            value, "Please enter the item value");
                      },
                      controller: _itemValueTextController,
                      decoration: const InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(),
                          hintText: 'Value of item (in GBP)'),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Condition'),
                      value: conditionDropDownValue,
                      items: ['Poor', 'Acceptable', 'Good']
                          .map((label) => DropdownMenuItem(
                                child: Text(label),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (condition) {
                        setState(
                          () {
                            double value =
                                double.parse(_itemValueTextController.text);
                            conditionDropDownValue = condition!;
                            double dailyrecommendation = 0,
                                weeklyrecommendation = 0,
                                monthlyrecommendation = 0;
                            double a = 1;

                            if (condition == 'Poor') {
                              a = value / 6 * 0.7;
                            } else if (condition == 'Acceptable') {
                              a = value / 6 * 0.9;
                            } else if (condition == 'Good') {
                              a = value / 6 * 1.2;
                            }

                            dailyrecommendation = a * 5 / 30;
                            weeklyrecommendation = a * 2 / 4;
                            monthlyrecommendation = a;

                            _dailyamountTextController.value =
                                _dailyamountTextController.value.copyWith(
                                    text:
                                        dailyrecommendation.toStringAsFixed(2),
                                    selection: TextSelection.collapsed(
                                        offset: dailyrecommendation
                                            .toString()
                                            .length));

                            _weeklyamountTextController.value =
                                _weeklyamountTextController.value.copyWith(
                                    text:
                                        weeklyrecommendation.toStringAsFixed(2),
                                    selection: TextSelection.collapsed(
                                        offset: weeklyrecommendation
                                            .toString()
                                            .length));

                            _monthlyamountTextController.value =
                                _monthlyamountTextController.value.copyWith(
                                    text: monthlyrecommendation
                                        .toStringAsFixed(2),
                                    selection: TextSelection.collapsed(
                                        offset: monthlyrecommendation
                                            .toString()
                                            .length));

                            Fluttertoast.showToast(
                                msg:
                                    "Recommended daily, weekly and monthly fees updated",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.lightBlue,
                                textColor: Colors.black,
                                fontSize: 12.0);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category'),
                      value: categorydropdownValue,
                      items: [
                        'Film & Photography',
                        'Audio Visual Equipment',
                        'Camping Gear',
                        'Others'
                      ]
                          .map((label) => DropdownMenuItem(
                                child: Text(label),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => categorydropdownValue = value!);
                      },
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return productValidator(
                                  value, "Please enter the daily fee");
                            },
                            controller: _dailyamountTextController,
                            decoration: const InputDecoration(
                                labelText: 'Daily',
                                border: OutlineInputBorder(),
                                hintText: 'Daily fee'),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return productValidator(
                                  value, "Please enter the weekly fee");
                            },
                            controller: _weeklyamountTextController,
                            decoration: const InputDecoration(
                                labelText: 'Weekly',
                                border: OutlineInputBorder(),
                                hintText: 'Weekly fee'),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return productValidator(
                                  value, "Please enter the monthly fee");
                            },
                            controller: _monthlyamountTextController,
                            decoration: const InputDecoration(
                                labelText: 'Monthly',
                                border: OutlineInputBorder(),
                                hintText: 'Monthly fee'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
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
                              _dailyamountTextController.text,
                              _weeklyamountTextController.text,
                              _monthlyamountTextController.text,
                              imageUrl,
                              _itemValueTextController.text);
                          _titleTextController.clear();
                          _descriptionTextController.clear();
                          // _amountTextController.clear();
                          _itemValueTextController.clear();
                          _dailyamountTextController.clear();
                          _weeklyamountTextController.clear();
                          _monthlyamountTextController.clear();

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
                                  builder: (context) => DashboardScreen()));
                        }
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
