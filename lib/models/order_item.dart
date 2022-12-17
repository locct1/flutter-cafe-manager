import 'cart_item.dart';
import 'order_detail.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String? id;
  final double amount;
  final int tableNumber;
  final List<OrderDetail> products;
  final DateTime dateTime;
  final String note;
  final String status;
  int get productCount {
    return products.length;
  }

  OrderItem({
    this.id,
    required this.amount,
    required this.tableNumber,
    required this.note,
    required this.products,
    required this.status,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith({
    String? id,
    double? amount,
    int? tableNumber,
    String? note,
    List<OrderDetail>? products,
    DateTime? dateTime,
    String? status,
  }) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      tableNumber: tableNumber ?? this.tableNumber,
      note: note ?? this.note,
      status: status ?? this.status,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    List? products = this.products != null
        ? this.products.map((i) => i.toJson()).toList()
        : null;
    String formattedDate = DateFormat().format(dateTime);
    return {
      'amount': amount,
      'tableNumber': tableNumber,
      'note': note,
      'products': products,
      'dateTime': formattedDate,
      'status': status,
    };
  }

  Map<String, dynamic> toJsonForm() {
    return {
      'tableNumber': tableNumber,
      'note': note,
    };
  }

  Map<String, dynamic> toJsonStatus() {
    return {
      'status': status,
    };
  }

  static OrderItem fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      amount: json['amount'],
      tableNumber: json['tableNumber'],
      note: json['note'],
      status: json['status'],
      products: List<OrderDetail>.from(
          json['products'].map((model) => OrderDetail.fromJson(model))),
      dateTime: DateFormat().parse(json['dateTime']),
    );
  }
}
