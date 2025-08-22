// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/dossier.dart';
import '../services/data_loader.dart';
import '../widgets/dossier_section.dart';

class DossierScreen extends StatefulWidget {
  const DossierScreen({super.key});

  @override
  State<DossierScreen> createState() => _DossierScreenState();
}

class _DossierScreenState extends State<DossierScreen>
    with TickerProviderStateMixin {
  Dossier? dossier;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDossier();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDossier() async {
    try {
      final dossierData = await DataLoader.loadDossier();
      setState(() {
        dossier = dossierData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dossier Médical'),
        elevation: 0,
  
        bottom: isLoading || dossier == null
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                indicatorColor: theme.colorScheme.primary,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    icon: Icon(Icons.dashboard_outlined, size: 20),
                    text: 'Vue d\'ensemble',
                  ),
                  Tab(
                    icon: Icon(Icons.history, size: 20),
                    text: 'Antécédents',
                  ),
                  Tab(
                    icon: Icon(Icons.warning_amber_outlined, size: 20),
                    text: 'Allergies',
                  ),
                  Tab(
                    icon: Icon(Icons.medication_outlined, size: 20),
                    text: 'Traitements',
                  ),
                ],
              ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dossier == null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildAntecedentsTab(),
                    _buildAllergiesTab(),
                    _buildTreatmentsTab(),
                  ],
                ),
    );
  }

  Widget _buildOverviewTab() {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: _loadDossier,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.secondary.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.folder_shared,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Votre dossier médical',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Informations confidentielles et sécurisées',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            Text(
              'Résumé',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Antécédents',
                    dossier!.antecedents.length.toString(),
                    Icons.history,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Allergies',
                    dossier!.allergies.length.toString(),
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Traitements',
                    dossier!.traitements.where((t) => t.statut == 'en cours').length.toString(),
                    Icons.medication,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Recent Items
            Text(
              'Éléments récents',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

         
            if (dossier!.allergies.isNotEmpty) ...[
              _buildRecentCard(
                'Allergie récente',
                dossier!.allergies.first.allergene,
                dossier!.allergies.first.gravite,
                Icons.warning_amber,
                Colors.orange,
                _formatDate(dossier!.allergies.first.dateDecouverte),
              ),
              const SizedBox(height: 12),
            ],
            
            if (dossier!.traitements.where((t) => t.statut == 'en cours').isNotEmpty) ...[
              _buildRecentCard(
                'Traitement en cours',
                dossier!.traitements.firstWhere((t) => t.statut == 'en cours').medicament,
                dossier!.traitements.firstWhere((t) => t.statut == 'en cours').indication,
                Icons.medication,
                Colors.green,
                'Depuis ${_formatDate(dossier!.traitements.firstWhere((t) => t.statut == 'en cours').dateDebut)}',
              ),
              const SizedBox(height: 12),
            ],

      
          ],
        ),
      ),
    );
  }

  Widget _buildAntecedentsTab() {
    return RefreshIndicator(
      onRefresh: _loadDossier,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DossierSection(
              title: 'Antécédents médicaux',
              icon: 'history',
              color: Colors.blue,
              children: dossier!.antecedents.map((antecedent) {
                return DossierItem(
                  title: antecedent.description,
                  subtitle: antecedent.type,
                  date: _formatDate(antecedent.date),
                  location: antecedent.lieu,
                  status: antecedent.medecin,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesTab() {
    return RefreshIndicator(
      onRefresh: _loadDossier,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DossierSection(
              title: 'Allergies',
              icon: 'warning',
              color: Colors.orange,
              children: dossier!.allergies.map((allergie) {
                Color severityColor = _getSeverityColor(allergie.gravite);
                return DossierItem(
                  title: allergie.allergene,
                  subtitle: allergie.reaction,
                  date: _formatDate(allergie.dateDecouverte),
                  status: allergie.gravite,
                  statusColor: severityColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentsTab() {
    return RefreshIndicator(
      onRefresh: _loadDossier,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DossierSection(
              title: 'Traitements',
              icon: 'medication',
              color: Colors.green,
              children: dossier!.traitements.map((traitement) {
                Color statusColor = _getStatusColor(traitement.statut);
                return DossierItem(
                  title: traitement.medicament,
                  subtitle: traitement.indication,
                  date: '${_formatDate(traitement.dateDebut)} - ${traitement.dateFin != null ? _formatDate(traitement.dateFin!) : 'En cours'}',
                  status: traitement.statut,
                  statusColor: statusColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCard(String category, String title, String subtitle, IconData icon, Color color, String date) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Text(
              date,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Impossible de charger votre dossier médical.\nVérifiez votre connexion internet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadDossier,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'sévère':
        return Colors.red;
      case 'modérée':
        return Colors.orange;
      case 'légère':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'en cours':
        return Colors.green;
      case 'terminé':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}