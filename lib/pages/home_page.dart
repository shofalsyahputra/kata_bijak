import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/quote_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = index);
    } else if (index == 1) {
      Navigator.pushNamed(context, '/kategori');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/favorit');
    }
  }

  final List<Widget> _pages = [
    QuoteView(),
    Placeholder(), // Tidak dipakai langsung karena pakai Navigator
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Kata Bijak', style: TextStyle(color: Colors.yellow)),
        iconTheme: IconThemeData(color: Colors.yellow),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
        ],
      ),
    );
  }
}

class QuoteView extends StatefulWidget {
  @override
  State<QuoteView> createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  late Future<Quote> _futureQuote;

  @override
  void initState() {
    super.initState();
    _futureQuote = QuoteApiService.fetchRandomQuote();
  }

  void _refreshQuote() {
    setState(() {
      _futureQuote = QuoteApiService.fetchRandomQuote();
    });
  }

  Future<void> _saveToFavorites(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final quoteJson = json.encode(quote.toJson());
    if (!favorites.contains(quoteJson)) {
      favorites.add(quoteJson);
      await prefs.setStringList('favorites', favorites);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote disimpan ke favorit')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote sudah ada di favorit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: _futureQuote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final quote = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '"${quote.text}"',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.yellow,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  '- ${quote.author}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => _saveToFavorites(quote),
                      icon: Icon(Icons.favorite_border),
                      label: Text('Suka'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[800],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _refreshQuote,
                      child: Text('Quote Lain'),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan', style: TextStyle(color: Colors.white)));
        }
        return Center(child: CircularProgressIndicator(color: Colors.yellow));
      },
    );
  }
}
