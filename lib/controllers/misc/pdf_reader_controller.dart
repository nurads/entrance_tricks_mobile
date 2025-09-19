import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final int videoId;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller.initialize();

      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _position = _controller.value.position;
            _duration = _controller.value.duration;
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load video: $e');
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _seekTo(Duration position) {
    _controller.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player
            Center(
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[900],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading video...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Video Controls
            if (_isInitialized)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Top Controls
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Get.back(),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.videoTitle,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // TODO: Implement fullscreen toggle
                                  },
                                  icon: Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Center Play Button
                          Expanded(
                            child: Center(
                              child: IconButton(
                                onPressed: _togglePlayPause,
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),

                          // Bottom Controls
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Progress Bar
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: theme.colorScheme.primary,
                                    inactiveTrackColor: Colors.white
                                        .withOpacity(0.3),
                                    thumbColor: theme.colorScheme.primary,
                                    overlayColor: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _position.inMilliseconds.toDouble(),
                                    max: _duration.inMilliseconds.toDouble(),
                                    onChanged: (value) {
                                      _seekTo(
                                        Duration(milliseconds: value.toInt()),
                                      );
                                    },
                                  ),
                                ),

                                // Time and Controls
                                Row(
                                  children: [
                                    Text(
                                      _formatDuration(_position),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    Spacer(),
                                    Text(
                                      _formatDuration(_duration),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    SizedBox(width: 16),
                                    IconButton(
                                      onPressed: _togglePlayPause,
                                      icon: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
