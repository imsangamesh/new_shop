import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Black Sweater',
      description: 'funny sweater for your winter .',
      price: 49.99,
      imageUrl:
          'https://img.freepik.com/free-vector/front-hoodie-sweater-with-zebra-pattern_1308-58982.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    ),
    Product(
      id: 'p2',
      title: 'Cool Shirt',
      description: 'A nice shirt with jacket in it.',
      price: 33,
      imageUrl:
          'https://img.freepik.com/free-photo/portrait-handsome-smiling-stylish-young-man-model-dressed-blue-shirt-clothes-fashion-man-posing_158538-4976.jpg?size=626&ext=jpg&uid=R65626931&ga=GA1.2.1218116275.1648890617',
    ),
    Product(
      id: 'p3',
      title: 'Winter set',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 72.5,
      imageUrl:
          'https://img.freepik.com/free-vector/winter-clothes-essentials-collection_23-2147987373.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    ),
    Product(
      id: 'p4',
      title: 'Jog-Pant',
      description: 'comfort jogging pants you need in morning',
      price: 27.68,
      imageUrl:
          'https://img.freepik.com/free-psd/men-sweat-pants-mockup_170704-223.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.1.1218116275.1648890617',
    ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
