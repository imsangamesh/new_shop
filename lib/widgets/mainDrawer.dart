import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('My Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Shop',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(
            thickness: 1.3,
            indent: 10,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Orders',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(
            thickness: 1.3,
            indent: 10,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Manage Products',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
