class QuoteModel {
  final bool success;
  final String source;
  final QuoteData data;

  QuoteModel({
    required this.success,
    required this.source,
    required this.data,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      success: json['success'],
      source: json['source'],
      data: QuoteData.fromJson(json['data']),
    );
  }
}

class QuoteData {
  final String quote;
  final String author;
  final List<String> tags;

  QuoteData({
    required this.quote,
    required this.author,
    required this.tags,
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) {
    return QuoteData(
      quote: json['quote'],
      author: json['author'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
