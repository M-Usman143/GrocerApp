import 'package:flutter/material.dart';
import 'package:GrocerApp/Common/WishListProvider.dart';
import 'package:GrocerApp/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Common/Cart Provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Common/VariantProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => VariantProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash_screen()
    );
  }
}