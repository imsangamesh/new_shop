import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
    } catch (e) {}
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://new-shop-87099-default-rtdb.firebaseio.com/orders.json');

    final response = await http.get(url);
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrders == null) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    extractedOrders.forEach((oId, oData) {
      loadedOrders.add(
        OrderItem(
          id: oId,
          amount: oData['amount'],
          dateTime: DateTime.parse(oData['dateTime']),
          products: (oData['products'] as List<dynamic>)
              .map((cpi) => CartItem(
                    id: cpi['id'],
                    title: cpi['title'],
                    quantity: cpi['quantity'],
                    price: cpi['price'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
