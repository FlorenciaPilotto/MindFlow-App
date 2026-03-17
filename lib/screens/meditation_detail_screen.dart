import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mind_flow/models/meditation.dart';
import 'package:mind_flow/services/auth_service.dart';
import 'package:mind_flow/utils/app_utils.dart';
import 'package:mind_flow/utils/error_handler.dart';

class MeditationDetailScreen extends StatefulWidget {
  final Meditation meditation;

  const MeditationDetailScreen({Key? key, required this.meditation})
      : super(key: key);

  @override
  State<MeditationDetailScreen> createState() =>
      _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AuthService _authService = AuthService();

  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isCompleted = false;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _setupAudio();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    try {
      final userProfile = await _authService.getUserProfile(uid);
      if (mounted) {
        setState(() {
          _isFavorite =
              userProfile?.favoriteMeditationIds.contains(widget.meditation.id) ?? false;
        });
      }
    } catch (_) {
      // Non-critical — favorite status defaults to false
    }
  }

  void _setupAudio() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _onMeditationComplete();
    });
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_playerState == PlayerState.playing) {
        await _audioPlayer.pause();
      } else if (_playerState == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(UrlSource(widget.meditation.audioUrl));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorHandler.handleError(e))),
        );
      }
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    if (mounted) setState(() => _position = Duration.zero);
  }

  Future<void> _onMeditationComplete() async {
    if (_isCompleted) return;
    _isCompleted = true;
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      try {
        await _authService.updateProgress(
          uid: uid,
          meditationId: widget.meditation.id,
          durationSeconds: widget.meditation.duration,
        );
      } catch (_) {
        // Progress update failure is non-critical
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meditation complete! Well done.')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meditation.title),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: _isFavorite ? Colors.red : null,
            ),
            tooltip: _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            onPressed: () async {
              final uid = _authService.currentUser?.uid;
              if (uid == null) return;
              try {
                await _authService.toggleFavorite(uid, widget.meditation.id);
                if (mounted) {
                  setState(() => _isFavorite = !_isFavorite);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'Added to favorites.'
                            : 'Removed from favorites.',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppErrorHandler.handleError(e))),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cover art placeholder
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.self_improvement, size: 100),
            ),
            const SizedBox(height: 24),
            Text(
              widget.meditation.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.meditation.category} · ${AppUtils.formatDuration(widget.meditation.duration)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.meditation.description,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Progress slider
            Slider(
              value: _duration.inSeconds > 0
                  ? _position.inSeconds.toDouble()
                  : 0,
              max: _duration.inSeconds > 0
                  ? _duration.inSeconds.toDouble()
                  : 1,
              onChanged: (value) async {
                await _audioPlayer
                    .seek(Duration(seconds: value.toInt()));
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_position)),
                  Text(_formatDuration(_duration)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.stop_circle_outlined),
                  onPressed: _stop,
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  onPressed: _togglePlayPause,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
