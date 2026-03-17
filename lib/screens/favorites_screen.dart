import 'package:flutter/material.dart';
import 'package:mind_flow/models/meditation.dart';
import 'package:mind_flow/services/auth_service.dart';
import 'package:mind_flow/services/meditation_service.dart';
import 'package:mind_flow/screens/meditation_detail_screen.dart';
import 'package:mind_flow/widgets/custom_widgets.dart';
import 'package:mind_flow/utils/app_utils.dart';
import 'package:mind_flow/utils/error_handler.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthService _authService = AuthService();
  final MeditationService _meditationService = MeditationService();

  List<Meditation> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final uid = _authService.currentUser?.uid;
      if (uid == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final userProfile = await _authService.getUserProfile(uid);
      if (userProfile == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final favoriteIds = userProfile.favoriteMeditationIds;
      final List<Meditation> loaded = [];

      for (final id in favoriteIds) {
        final data = await _meditationService.getMeditationById(id);
        if (data != null) loaded.add(Meditation.fromJson(data));
      }

      if (mounted) setState(() => _favorites = loaded);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorHandler.handleError(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavorite(Meditation meditation) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    try {
      await _authService.toggleFavorite(uid, meditation.id);
      setState(() => _favorites.removeWhere((m) => m.id == meditation.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorHandler.handleError(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingWidget();

    if (_favorites.isEmpty) {
      return const EmptyStateWidget(
        message: 'No favorite meditations yet.\nTap the heart icon on any meditation to save it.',
        icon: Icons.favorite_border,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final m = _favorites[index];
          return Dismissible(
            key: Key(m.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => _removeFavorite(m),
            child: CustomCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MeditationDetailScreen(meditation: m),
                ),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.self_improvement),
                ),
                title: Text(m.title),
                subtitle: Text(
                  '${m.category} · ${AppUtils.formatDuration(m.duration)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => _removeFavorite(m),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
