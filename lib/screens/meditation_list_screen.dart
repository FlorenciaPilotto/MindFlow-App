import 'package:flutter/material.dart';
import 'package:mind_flow/models/meditation.dart';
import 'package:mind_flow/services/meditation_service.dart';
import 'package:mind_flow/screens/meditation_detail_screen.dart';
import 'package:mind_flow/widgets/custom_widgets.dart';
import 'package:mind_flow/utils/app_utils.dart';
import 'package:mind_flow/constants/constants.dart';

class MeditationListScreen extends StatefulWidget {
  const MeditationListScreen({Key? key}) : super(key: key);

  @override
  State<MeditationListScreen> createState() => _MeditationListScreenState();
}

class _MeditationListScreenState extends State<MeditationListScreen> {
  final MeditationService _meditationService = MeditationService();
  final TextEditingController _searchController = TextEditingController();

  List<Meditation> _allMeditations = [];
  List<Meditation> _filteredMeditations = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeditations();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMeditations() async {
    setState(() => _isLoading = true);
    try {
      final data = await _meditationService.getAllMeditations();
      if (mounted) {
        setState(() {
          _allMeditations = data.map((m) => Meditation.fromJson(m)).toList();
          _filteredMeditations = _allMeditations;
        });
      }
    } catch (_) {
      // Handle silently — filtered list remains empty
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMeditations = _allMeditations.where((m) {
        final matchesCategory =
            _selectedCategory == 'All' || m.category == _selectedCategory;
        final matchesSearch = query.isEmpty ||
            m.title.toLowerCase().contains(query) ||
            m.description.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomTextField(
            controller: _searchController,
            label: 'Search meditations…',
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['All', ...AppConstants.meditationCategories]
                .map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: _selectedCategory == c,
                        onSelected: (_) => _selectCategory(c),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _isLoading
              ? const LoadingWidget()
              : _filteredMeditations.isEmpty
                  ? const EmptyStateWidget(
                      message: 'No meditations found.',
                      icon: Icons.self_improvement,
                    )
                  : RefreshIndicator(
                      onRefresh: _loadMeditations,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredMeditations.length,
                        itemBuilder: (context, index) {
                          final m = _filteredMeditations[index];
                          return CustomCard(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MeditationDetailScreen(meditation: m),
                              ),
                            ),
                            child: ListTile(
                              leading:
                                  const CircleAvatar(child: Icon(Icons.headphones)),
                              title: Text(m.title),
                              subtitle: Text(
                                '${m.category} · ${AppUtils.formatDuration(m.duration)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Text(m.rating.toStringAsFixed(1)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
