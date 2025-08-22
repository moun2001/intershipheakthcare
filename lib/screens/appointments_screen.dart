// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/data_loader.dart';
import '../widgets/appointment_card.dart';
import '../widgets/filter_tabs.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<RendezVous> allRendezVous = [];
  List<RendezVous> filteredRendezVous = [];
  bool isLoading = true;
  int selectedFilterIndex = 0;

  final List<String> filterOptions = ['Tous', 'À venir', 'Passés'];

  @override
  void initState() {
    super.initState();
    _loadRendezVous();
  }

  Future<void> _loadRendezVous() async {
    try {
      final rendezVous = await DataLoader.loadRendezVous();
      setState(() {
        allRendezVous = rendezVous;
        _applyFilter();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: $e')),
        );
      }
    }
  }

  void _applyFilter() {
  final now = DateTime.now();
  
  switch (selectedFilterIndex) {
    case 0: // Tous
      filteredRendezVous = allRendezVous;
      break;
    case 1: // À venir
      filteredRendezVous = allRendezVous.where((rdv) {
        final rdvDate = DateTime.parse(rdv.date);
        
        return rdvDate.isAfter(now) || 
               (rdvDate.year == now.year && 
                rdvDate.month == now.month && 
                rdvDate.day == now.day && 
                rdvDate.hour >= now.hour);
      }).toList();
      break;
    case 2: // Passés
      filteredRendezVous = allRendezVous.where((rdv) {
        final rdvDate = DateTime.parse(rdv.date);
        return rdvDate.isBefore(now);
      }).toList();
      break;
  }
  
  // Tri par date (plus récent en premier pour les passés, plus proche en premier pour les à venir)
  filteredRendezVous.sort((a, b) {
    final dateA = DateTime.parse(a.date);
    final dateB = DateTime.parse(b.date);
    
    if (selectedFilterIndex == 2) { // Passés
      return dateB.compareTo(dateA); // Plus récent en premier
    } else {
      return dateA.compareTo(dateB); // Plus proche en premier
    }
  });
}
  void _onFilterChanged(int index) {
    setState(() {
      selectedFilterIndex = index;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Rendez-vous'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRendezVous,
        child: Column(
          children: [
            // Filtres
            FilterTabs(
              options: filterOptions,
              selectedIndex: selectedFilterIndex,
              onChanged: _onFilterChanged,
            ),
            
            // Contenu
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredRendezVous.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: filteredRendezVous.length,
                          itemBuilder: (context, index) {
                            final rendezVous = filteredRendezVous[index];
                            return AppointmentCard(
                              rendezVous: rendezVous,
                              onTap: () => _showRendezVousDetails(rendezVous),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            selectedFilterIndex == 0
                ? 'Aucun rendez-vous'
                : selectedFilterIndex == 1
                    ? 'Aucun rendez-vous à venir'
                    : 'Aucun rendez-vous passé',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos rendez-vous apparaîtront ici',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showRendezVousDetails(RendezVous rendezVous) {
    final theme = Theme.of(context);
    final date = DateTime.parse(rendezVous.date);
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    final formattedTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails du rendez-vous'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Médecin', rendezVous.medecin, Icons.person),
            _buildDetailRow('Spécialité', rendezVous.specialite, Icons.medical_services),
            _buildDetailRow('Date', formattedDate, Icons.calendar_today),
            _buildDetailRow('Heure', formattedTime, Icons.access_time),
            _buildDetailRow('Lieu', rendezVous.lieu, Icons.location_on),
            _buildDetailRow('Statut', rendezVous.statut, Icons.info),
            if (rendezVous.motif != null)
              _buildDetailRow('Motif', rendezVous.motif!, Icons.note),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
