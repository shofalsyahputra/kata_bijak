class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'] ?? '',
      author: json['a'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q': text,
      'a': author,
    };
  }
}
