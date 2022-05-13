import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ismailapp/components/default_button.dart';
import 'package:ismailapp/models/Product.dart';
import 'package:ismailapp/size_config.dart';

import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final Product product;
  final String docID;

  Body({Key? key, required this.product, required this.docID})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final firestoreInstance = FirebaseFirestore.instance;

  String action = 'Deactivate';

  deactivateItem() {
    firestoreInstance
        .collection('items')
        .doc(widget.docID)
        .update({'available': false});
  }

  toggleState() {
    // firestoreInstance
    //     .collection('items')
    //     .doc(widget.docID)
    //     .update({'available': newstate});
    firestoreInstance.collection('items').doc(widget.docID).get().then((value) {
      if (value['available']) {
        firestoreInstance
            .collection('items')
            .doc(widget.docID)
            .update({'available': false});
      } else {
        firestoreInstance
            .collection('items')
            .doc(widget.docID)
            .update({'available': true});
      }
    });
  }

  @override
  void initState() {
    firestoreInstance.collection('items').doc(widget.docID).get().then((value) {
      // var result = value['available'];
      print(value['available']);
      if (value['available']) {
        action = 'Deactivate';
      } else {
        action = 'Activate';
      }
    });
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    ColorDots(product: widget.product),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: action,
                          press: () {
                            toggleState();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
