class Patient {
  final String id;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String telephone;
  final String email;
  final String adresse;
  final String groupeSanguin;
  final int taille;
  final int poids;
  final RendezVous? dernierRendezVous;

  Patient({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.telephone,
    required this.email,
    required this.adresse,
    required this.groupeSanguin,
    required this.taille,
    required this.poids,
    this.dernierRendezVous,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      telephone: json['telephone'],
      email: json['email'],
      adresse: json['adresse'],
      groupeSanguin: json['groupeSanguin'],
      taille: json['taille'],
      poids: json['poids'],
      dernierRendezVous: json['dernierRendezVous'] != null 
          ? RendezVous.fromJson(json['dernierRendezVous']) 
          : null,
    );
  }
}

class RendezVous {
  final String id;
  final String medecin;
  final String specialite;
  final String date;
  final String lieu;
  final String statut;
  final String? motif;

  RendezVous({
    required this.id,
    required this.medecin,
    required this.specialite,
    required this.date,
    required this.lieu,
    required this.statut,
    this.motif,
  });

  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      id: json['id'],
      medecin: json['medecin'],
      specialite: json['specialite'],
      date: json['date'],
      lieu: json['lieu'],
      statut: json['statut'],
      motif: json['motif'],
    );
  }
}
