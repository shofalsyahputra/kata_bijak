import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/quote_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Quote> _favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favoriteQuotes = favorites.map((q) {
        final map = json.decode(q);
        return Quote.fromJson(map);
      }).toList();
    });
  }

  Future<void> _removeFromFavorites(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    final quoteJson = json.encode(quote.toJson());
    favorites.remove(quoteJson);
    await prefs.setStringList('favorites', favorites);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dihapus dari Favorit')),
    );

    _loadFavorites(); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorit Saya', style: TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.yellow),
      ),
      body: _favoriteQuotes.isEmpty
          ? Center(
              child: Text(
                'Belum ada kutipan favorit',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = _favoriteQuotes[index];
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      '"${quote.text}"',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Text(
                      '- ${quote.author}',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _removeFromFavorites(quote),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
