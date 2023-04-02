import 'package:flutter/material.dart';

class Scenario {
  final int id;
  final String name;
  final String category;
  final String description;
  // final List<String> keywords;
  final String instructions;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  Scenario({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    // required this.keywords,
    required this.instructions,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return Scenario(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      // keywords: List<String>.from(json['keywords']),
      instructions: json['instructions'],
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
