import 'package:flutter/material.dart';
import 'package:mind_flow/models/meditation.dart';
import 'package:mind_flow/models/user.dart' as app_models;
import 'package:mind_flow/services/auth_service.dart';
import 'package:mind_flow/services/meditation_service.dart';
import 'package:mind_flow/screens/meditation_list_screen.dart';
import 'package:mind_flow/screens/favorites_screen.dart';
import 'package:mind_flow/screens/meditation_detail_screen.dart';
import 'package:mind_flow/screens/auth_screen.dart';
import 'package:mind_flow/widgets/custom_widgets.dart';
import 'package:mind_flow/utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final MeditationService _meditationService = MeditationService();

  int _selectedIndex = 0;
  app_models.User? _user;
  List<Meditation> _featured = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        final userProfile = await _authService.getUserProfile(uid);
        final meditations = await _meditationService.getAllMeditations();
        if (mounted) {
          setState(() {
            _user = userProfile;
            _featured = meditations
                .map((m) => Meditation.fromJson(m))
                .take(5)
                .toList();
          });
        }
      }
    } catch (_) {
      // Silently handle errors — data will remain empty
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  Widget _buildHome() {
    if (_isLoading) return const LoadingWidget();
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGreeting(),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 24),
          Text(
            'Featured Meditations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _featured.isEmpty
              ? const EmptyStateWidget(
                  message: 'No meditations available yet.',
                  icon: Icons.self_improvement,
                )
              : Column(
                  children: _featured
                      .map((m) => _buildMeditationCard(m))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppUtils.getGreeting()},',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          _user?.name ?? 'Meditator',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Day Streak',
            value: '${_user?.meditationStreak ?? 0}',
            icon: Icons.local_fire_department,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Total Minutes',
            value: '${_user?.totalMeditationMinutes ?? 0}',
            icon: Icons.timer_outlined,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Sessions',
            value: '${_user?.completedMeditationIds.length ?? 0}',
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationCard(Meditation meditation) {
    return CustomCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MeditationDetailScreen(meditation: meditation),
        ),
      ),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.self_improvement)),
        title: Text(meditation.title),
        subtitle: Text(
          '${meditation.category} · ${AppUtils.formatDuration(meditation.duration)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(meditation.rating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHome(),
      const MeditationListScreen(),
      const FavoritesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _signOut,
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.library_music_outlined), label: 'Meditate'),
          NavigationDestination(
              icon: Icon(Icons.favorite_outline), label: 'Favorites'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
