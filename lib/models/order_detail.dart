import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
class OrderDetail {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderDetail({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
  OrderDetail copyWith({
    String? id,
    String? title,
    int? quantity,
    double? price,
    String? imageUrl,
  }) {
    return OrderDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id":id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
  
   static OrderDetail fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }
}
