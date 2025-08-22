class Recommandation {
  final String id;
  final String categorie;
  final String titre;
  final String description;
  final String conseil;

  Recommandation({
    required this.id,
    required this.categorie,
    required this.titre,
    required this.description,
    required this.conseil,
  });

  factory Recommandation.fromJson(Map<String, dynamic> json) {
    return Recommandation(
      id: json['id'],
      categorie: json['categorie'],
      titre: json['titre'],
      description: json['description'],
      conseil: json['conseil'],
    );
  }
}

class RecommandationsData {
  final List<Recommandation> recommandations;

  RecommandationsData({
    required this.recommandations,
  });

  factory RecommandationsData.fromJson(Map<String, dynamic> json) {
    return RecommandationsData(
      recommandations: (json['recommandations'] as List)
          .map((item) => Recommandation.fromJson(item))
          .toList(),
    );
  }
}
