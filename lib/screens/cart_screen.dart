import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total :',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (cart.items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                ),
              ),
            ),
          if (cart.items.isEmpty)
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/newCartItem.png'),
                  const SizedBox(height: 10),
                  const Text(
                    'no products added !',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
            cart.itemCount == 0 ? Colors.grey : Theme.of(context).accentColor,
        disabledElevation: 0,
        label: const Text('ORDER NOW'),
        onPressed: cart.itemCount == 0
            ? null
            : () {
                try {
                  Provider.of<Orders>(context, listen: false).addOrder(
                    cart.items.values.toList(),
                    cart.totalAmount,
                  );
                  cart.clear();
                } catch (e) {}
              },
      ),
    );
  }
}
