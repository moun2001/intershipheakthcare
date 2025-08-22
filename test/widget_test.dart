// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthtrack/models/patient.dart';
import 'package:healthtrack/models/recommandation.dart';

void main() {
  group('Modèles de données', () {
    test('Patient.fromJson devrait créer un objet Patient valide', () {
      final json = {
        'id': 'P001',
        'nom': 'Karim',
        'prenom': 'Hadj',
        'dateNaissance': '1985-03-15',
        'telephone': '+213 770 123 456',
        'email': 'karim.hadj@email.dz',
        'adresse': '123 Rue Didouche Mourad, Alger',
        'groupeSanguin': 'O+',
        'taille': 175,
        'poids': 72,
        'dernierRendezVous': {
          'id': 'RDV003',
          'medecin': 'Dr. Ahmed Benali',
          'specialite': 'Médecine générale',
          'date': '2024-01-15T10:00:00',
          'lieu': 'Clinique El Biar, Alger',
          'statut': 'terminé'
        }
      };

      final patient = Patient.fromJson(json);

      expect(patient.id, 'P001');
      expect(patient.nom, 'Karim');
      expect(patient.prenom, 'Hadj');
      expect(patient.dernierRendezVous, isNotNull);
      expect(patient.dernierRendezVous!.medecin, 'Dr. Ahmed Benali');
    });

    test('Recommandation.fromJson devrait créer un objet Recommandation valide', () {
      final json = {
        'id': 'REC001',
        'categorie': 'Sommeil',
        'titre': 'Rituel du soir',
        'description': 'Évitez les écrans 1h avant le coucher',
        'conseil': 'Créez une routine relaxante'
      };

      final recommandation = Recommandation.fromJson(json);

      expect(recommandation.id, 'REC001');
      expect(recommandation.categorie, 'Sommeil');
      expect(recommandation.titre, 'Rituel du soir');
      expect(recommandation.description, 'Évitez les écrans 1h avant le coucher');
      expect(recommandation.conseil, 'Créez une routine relaxante');
    });

    test('RendezVous.fromJson devrait créer un objet RendezVous valide', () {
      final json = {
        'id': 'RDV001',
        'medecin': 'Dr. Fatima Zohra',
        'specialite': 'Cardiologie',
        'date': '2024-02-20T14:30:00',
        'lieu': 'Hôpital Mustapha Pacha, Alger',
        'statut': 'à venir',
        'motif': 'Contrôle cardiaque annuel'
      };

      final rendezVous = RendezVous.fromJson(json);

      expect(rendezVous.id, 'RDV001');
      expect(rendezVous.medecin, 'Dr. Fatima Zohra');
      expect(rendezVous.specialite, 'Cardiologie');
      expect(rendezVous.statut, 'à venir');
      expect(rendezVous.motif, 'Contrôle cardiaque annuel');
    });
  });
}
