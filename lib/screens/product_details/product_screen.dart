import 'package:flutter/material.dart';

import '../../models/Product.dart';
import '../../size_config.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  final String title;
  final String description;
  final String imageURL;

  const DetailsScreen(
      {required this.title, required this.description, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final ProductDetailsArguments agrs =
    // ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(rating: 3.4),
      ),
      body: Body(
        product: Product(
            id: 1,
            images: [imageURL],
            colors: [Colors.red],
            rating: 4.4,
            title: title,
            description: description,
            price: 44.33),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
