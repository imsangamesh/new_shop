import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:new_shop/models/myHttpException.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/products/$id.json');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
        throw MyHttpException('sorry, favorite can\'t be set');
      }
    } catch (e) {
      rethrow;
    }
  }
}
