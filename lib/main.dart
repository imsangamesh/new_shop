import 'package:flutter/material.dart';
import 'package:new_shop/screens/authScreen.dart';
import 'package:new_shop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, authData, prevProds) => Products(
            authData.token,
            prevProds == null ? [] : prevProds.items,
          ),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: const Color.fromARGB(249, 255, 84, 149),
            canvasColor: const Color.fromARGB(249, 255, 207, 227),
            fontFamily: 'Lato',
          ),
          home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}


// const Color.fromARGB(255, 161, 201,0),
// const Color.fromARGB(249, 197, 213,0),
// const Color.fromARGB(254, 227, 236,0 ),