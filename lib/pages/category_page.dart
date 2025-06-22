import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quote_model.dart';
import '../services/quote_api_service.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<Quote> _quotes = [];
  final Set<String> _favoriteSet = {};
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchMoreQuotes();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favoriteSet.addAll(favorites);
    });
  }

  Future<void> _fetchMoreQuotes() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final futures = List.generate(5, (_) => QuoteApiService.fetchRandomQuote());
      final newQuotes = await Future.wait(futures);
      setState(() => _quotes.addAll(newQuotes));
    } catch (e) {
      print('Gagal fetch: $e');
      setState(() => _isError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveToFavorites(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    final quoteJson = json.encode(quote.toJson());
    if (!favorites.contains(quoteJson)) {
      favorites.add(quoteJson);
      await prefs.setStringList('favorites', favorites);
      setState(() {
        _favoriteSet.add(quoteJson);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ditambahkan ke Favorit')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sudah ada di Favorit')),
      );
    }
  }

  bool _isFavorited(Quote quote) {
    final quoteJson = json.encode(quote.toJson());
    return _favoriteSet.contains(quoteJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Kutipan Acak', style: TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.yellow),
      ),
      body: _isError
          ? Center(
              child: Text(
                'Terjadi kesalahan saat mengambil kutipan',
                style: TextStyle(color: Colors.white),
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _fetchMoreQuotes();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _quotes.length + 1,
                itemBuilder: (context, index) {
                  if (index == _quotes.length) {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.yellow)
                            : Text(
                                'Scroll untuk lebih banyak...',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    );
                  }

                  final quote = _quotes[index];
                  final isLiked = _isFavorited(quote);

                  return Card(
                    color: Colors.grey[900],
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${quote.text}"',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.yellow,
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '- ${quote.author}',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () => _saveToFavorites(quote),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
