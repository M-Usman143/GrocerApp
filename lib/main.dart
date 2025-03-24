import 'package:flutter/material.dart';
import 'package:GrocerApp/Common/WishListProvider.dart';
import 'package:GrocerApp/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Common/Cart Provider.dart';
import 'LocalStorageHelper/LocalStorageService.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage data
  await LocalStorageService.initializeData();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
      title: 'GrocerApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: splash_screen()
    );
  }
}