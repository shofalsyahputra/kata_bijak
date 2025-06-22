import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteApiService {
  static Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/random'))
          .timeout(
            Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Permintaan melebihi batas waktu');
            },
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        } else {
          throw Exception('Data kosong atau format tidak valid');
        }
      } else {
        throw Exception('Gagal fetch quote: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      print('Timeout: $e');
      throw Exception('Waktu habis saat mengambil kutipan');
    } catch (e) {
      print('ERROR API: $e');
      throw Exception('Terjadi kesalahan saat mengambil data');
    }
  }
}
