// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/recommandation.dart';
import '../services/data_loader.dart';
import '../widgets/health_tip_card.dart';

class RecommandationsScreen extends StatefulWidget {
  const RecommandationsScreen({super.key});

  @override
  State<RecommandationsScreen> createState() => _RecommandationsScreenState();
}

class _RecommandationsScreenState extends State<RecommandationsScreen>
    with TickerProviderStateMixin {
  List<Recommandation> allRecommandations = [];
  List<Recommandation> filteredRecommandations = [];
  bool isLoading = true;
  late TabController _tabController;

  final List<String> categories = ['Toutes', 'Sommeil', 'Nutrition', 'Activité physique'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadRecommandations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    _filterRecommandations();
  }

  Future<void> _loadRecommandations() async {
    try {
      final recommandations = await DataLoader.loadRecommandations();
      setState(() {
        allRecommandations = recommandations;
        _filterRecommandations();
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

  void _filterRecommandations() {
    final selectedCategory = categories[_tabController.index];
    
    if (selectedCategory == 'Toutes') {
      filteredRecommandations = allRecommandations;
    } else {
      filteredRecommandations = allRecommandations
          .where((rec) => rec.categorie == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommandations Santé'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecommandations,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredRecommandations.isEmpty
                ? _buildEmptyState()
                : TabBarView(
                    controller: _tabController,
                    children: categories.map((category) {
                      return _buildRecommandationsList(category);
                    }).toList(),
                  ),
      ),
    );
  }

  Widget _buildRecommandationsList(String category) {
    List<Recommandation> categoryRecommandations;
    
    if (category == 'Toutes') {
      categoryRecommandations = allRecommandations;
    } else {
      categoryRecommandations = allRecommandations
          .where((rec) => rec.categorie == category)
          .toList();
    }

    if (categoryRecommandations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: categoryRecommandations.length,
      itemBuilder: (context, index) {
        final recommandation = categoryRecommandations[index];
        return HealthTipCard(recommandation: recommandation);
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final selectedCategory = categories[_tabController.index];
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            selectedCategory == 'Toutes'
                ? 'Aucune recommandation'
                : 'Aucune recommandation pour $selectedCategory',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'De nouvelles recommandations apparaîtront ici',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
