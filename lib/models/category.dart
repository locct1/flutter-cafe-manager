class CategoryModel {
  final String? id;
  final String title;

  CategoryModel({
    this.id,
    required this.title,
  });
  CategoryModel copyWith({
    String? id,
    String? title,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
