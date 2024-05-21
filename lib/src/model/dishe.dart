class Dishes {

  final String publisher;
  final String title;
  final String sourceUrl;
  final String recipeId;
  final String imageUrl;
  final double socialRank;
  final String publisherUrl;
  final bool isFavorite;

  Dishes({
     required this.publisher,
     required this.title,
     required this.sourceUrl,
     required this.recipeId,
     required this.imageUrl,
     required this.socialRank,
     required this.publisherUrl,
     required this.isFavorite,
  });

  factory Dishes.fromJson(Map<String, dynamic> json) {
    return Dishes(
      publisher: json['publisher'],
      title: json['title'],
      sourceUrl: json['source_url'],
      recipeId: json['recipe_id'],
      imageUrl: json['image_url'],
      socialRank: json['social_rank'] is int ? json['social_rank'].toDouble() : json['social_rank'] is double ? json['social_rank'] : json['social_rank'],
      publisherUrl: json['publisher_url'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publisher': publisher,
      'title': title,
      'source_url': sourceUrl,
      'recipe_id': recipeId,
      'image_url': imageUrl,
      'social_rank': socialRank,
      'publisher_url': publisherUrl,
      'isFavorite': isFavorite,
    };
  }

  Dishes copyWith({
    String? publisher,
    String? title,
    String? sourceUrl,
    String? recipeId,
    String? imageUrl,
    double? socialRank,
    String? publisherUrl,
    bool? isFavorite,
  }) {
    return Dishes(
      publisher: publisher ?? this.publisher,
      title: title ?? this.title,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      recipeId: recipeId ?? this.recipeId,
      imageUrl: imageUrl ?? this.imageUrl,
      socialRank: socialRank ?? this.socialRank,
      publisherUrl: publisherUrl ?? this.publisherUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}


    
