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
    debugPrint("Scenario.fromJson: ");
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        // 'keywords': keywords,
        'instructions': instructions,
        // 'createdAt': createdAt.toIso8601String(),
        // 'updatedAt': updatedAt.toIso8601String(),
      };
}
