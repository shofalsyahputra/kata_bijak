import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/category_page.dart';
import 'pages/favorites_page.dart';

void main() {
  runApp(QuotesApp());
}

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kata Bijak',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        '/kategori': (_) => CategoryPage(),
        '/favorit': (_) => FavoritesPage(),
      },
    );
  }
}
