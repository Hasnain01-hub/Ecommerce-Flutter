import 'package:flutter/material.dart';

// class rating {
//   String email;
//   double raiting;
// }

class Product {
  String shoeName;
  String brand;
  String description;
  double average_price;
  List rating;
  String gender;
  // List<Color> productColors;
  List<String> thumbnail;

  Product(
      {required this.shoeName,
      required this.brand,
      required this.description,
      required this.average_price,
      required this.rating,
      // required this.productColors,
      required this.gender,
      required this.thumbnail});
}
