import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/patient.dart';
import '../models/dossier.dart';
import '../models/recommandation.dart';

class DataLoader {
  // Ici je charge les données JSON pour simuler l'API
  static Future<Patient> loadPatient() async {
    final String response = await rootBundle.loadString('assets/patient.json');
    final data = await json.decode(response);
    return Patient.fromJson(data);
  }

  static Future<List<RendezVous>> loadRendezVous() async {
    final String response = await rootBundle.loadString('assets/rendezvous.json');
    final data = await json.decode(response);
    final List<dynamic> rendezVousList = data['rendezVous'];
    return rendezVousList.map((json) => RendezVous.fromJson(json)).toList();
  }

  static Future<Dossier> loadDossier() async {
    final String response = await rootBundle.loadString('assets/dossier.json');
    final data = await json.decode(response);
    return Dossier.fromJson(data);
  }

  static Future<List<Recommandation>> loadRecommandations() async {
    final String response = await rootBundle.loadString('assets/recommandations.json');
    final data = await json.decode(response);
    final recommandationsData = RecommandationsData.fromJson(data);
    return recommandationsData.recommandations;
  }
}
