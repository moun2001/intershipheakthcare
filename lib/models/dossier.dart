class Dossier {
  final List<Antecedent> antecedents;
  final List<Allergie> allergies;
  final List<Traitement> traitements;

  Dossier({
    required this.antecedents,
    required this.allergies,
    required this.traitements,
  });

  factory Dossier.fromJson(Map<String, dynamic> json) {
    return Dossier(
      antecedents: (json['antecedents'] as List)
          .map((item) => Antecedent.fromJson(item))
          .toList(),
      allergies: (json['allergies'] as List)
          .map((item) => Allergie.fromJson(item))
          .toList(),
      traitements: (json['traitements'] as List)
          .map((item) => Traitement.fromJson(item))
          .toList(),
    );
  }
}

class Antecedent {
  final String id;
  final String type;
  final String description;
  final String date;
  final String lieu;
  final String medecin;

  Antecedent({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.lieu,
    required this.medecin,
  });

  factory Antecedent.fromJson(Map<String, dynamic> json) {
    return Antecedent(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      date: json['date'],
      lieu: json['lieu'],
      medecin: json['medecin'],
    );
  }
}

class Allergie {
  final String id;
  final String allergene;
  final String reaction;
  final String gravite;
  final String dateDecouverte;

  Allergie({
    required this.id,
    required this.allergene,
    required this.reaction,
    required this.gravite,
    required this.dateDecouverte,
  });

  factory Allergie.fromJson(Map<String, dynamic> json) {
    return Allergie(
      id: json['id'],
      allergene: json['allergene'],
      reaction: json['reaction'],
      gravite: json['gravite'],
      dateDecouverte: json['dateDecouverte'],
    );
  }
}

class Traitement {
  final String id;
  final String medicament;
  final String posologie;
  final String indication;
  final String dateDebut;
  final String? dateFin;
  final String statut;

  Traitement({
    required this.id,
    required this.medicament,
    required this.posologie,
    required this.indication,
    required this.dateDebut,
    this.dateFin,
    required this.statut,
  });

  factory Traitement.fromJson(Map<String, dynamic> json) {
    return Traitement(
      id: json['id'],
      medicament: json['medicament'],
      posologie: json['posologie'],
      indication: json['indication'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      statut: json['statut'],
    );
  }
}
