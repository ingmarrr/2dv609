class Scenario {
  final int id;
  final String name;
  final String category;
  final String description;
  final List<String> keywords;
  final String instructions;

  Scenario({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.keywords,
    required this.instructions,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      keywords: List<String>.from(json['keywords']),
      instructions: json['instructions'],
    );
  }
}
