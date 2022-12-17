import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TotalExpense {
  final String? id;
  final double price;
  final String description;
  final DateTime dateTime;
  TotalExpense({
    this.id,
    required this.description,
    required this.price,
   DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  TotalExpense copyWith({
    String? id,
    String? description,
    double? price,
    DateTime? dateTime,
  }) {
    return TotalExpense(
      id: id ?? this.id,
      description: description ?? this.description,
      price: price ?? this.price,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    String formattedDate = DateFormat().format(dateTime);

    return {
      'description': description,
      'price': price,
      'dateTime': formattedDate,
    };
  }

  static TotalExpense fromJson(Map<String, dynamic> json) {
    return TotalExpense(
      id: json['id'],
      description: json['description'],
      price: json['price'],
      dateTime: DateFormat().parse(json['dateTime']),
    );
  }
}
