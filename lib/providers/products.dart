import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/myHttpException.dart';
import './product.dart';

class Products with ChangeNotifier {
  Products(this.authToken, this._items);

  final String authToken;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Black Sweater',
    //   description: 'funny sweater for your winter .',
    //   price: 49.99,
    //   imageUrl:
    //       'https://img.freepik.com/free-vector/front-hoodie-sweater-with-zebra-pattern_1308-58982.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Cool Shirt',
    //   description: 'A nice shirt with jacket in it.',
    //   price: 33,
    //   imageUrl:
    //       'https://img.freepik.com/free-photo/portrait-handsome-smiling-stylish-young-man-model-dressed-blue-shirt-clothes-fashion-man-posing_158538-4976.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Winter set',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 72.5,
    //   imageUrl:
    //       'https://img.freepik.com/free-vector/winter-clothes-essentials-collection_23-2147987373.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Jog-Pant',
    //   description: 'comfort jogging pants you need in morning',
    //   price: 27.68,
    //   imageUrl:
    //       'https://img.freepik.com/free-psd/men-sweat-pants-mockup_170704-223.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Gaming pad',
    //   description: 'play cool games on your ps5 this summer.',
    //   price: 104.62,
    //   imageUrl:
    //       'https://img.freepik.com/free-vector/skull-gaming-with-joy-stick-emblem-modern-style_32991-492.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Red chair',
    //   description: 'are you tired, then here you go.',
    //   price: 199,
    //   imageUrl:
    //       'https://img.freepik.com/free-vector/red-vintage-armchair-realistic-style_1441-760.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Men boxers',
    //   description:
    //       'casual inner wears for men but may come in handy in wrestling.',
    //   price: 15.5,
    //   imageUrl:
    //       'https://img.freepik.com/free-psd/mens-boxer-briefs-mockup_77323-437.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Small bag',
    //   description: 'planning on a picnic, here you go.',
    //   price: 72.63,
    //   imageUrl:
    //       'https://img.freepik.com/free-psd/pink-black-bagpack-mock-up_1310-135.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Pizza',
    //   description: 'feeling hungry, grab one.',
    //   price: 8.2,
    //   imageUrl:
    //       'https://img.freepik.com/free-psd/food-menu-delicious-pizza-social-media-banner-template_106176-362.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Iphone',
    //   description: 'the latest apple in market.',
    //   price: 1099.99,
    //   imageUrl:
    //       'https://img.freepik.com/free-psd/smartphone-mockup-iphone-13-pro-mockup_591564-165.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': false,
        }),
      );
      // print(json.decode(response.body));  -> {name: -MzkV0Fcr0IN444CO49f}
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }),
        );
        if (response.statusCode >= 400) {
          throw MyHttpException('sorry, something went wrong.');
        }
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    var existingProdIndex = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProdIndex, existingProd);
        notifyListeners();
        // print('--------------------------------------------');
        throw MyHttpException('Sorry, couldn\'t delete product.');
      }
      existingProdIndex = null;
      existingProd = null;
    } catch (e) {
      rethrow;
    }
  }
}

/*

https://img.freepik.com/free-psd/food-menu-delicious-pizza-social-media-banner-template_106176-362.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617

*/