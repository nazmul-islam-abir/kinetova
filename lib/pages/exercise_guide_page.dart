import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../app_colors.dart';
import '../models/exercise.dart';
import '../widgets/shared_widgets.dart';

class ExerciseGuide extends StatefulWidget {
  const ExerciseGuide({super.key, required this.initialIndex, required this.completed, required this.onCompleted});
  final int initialIndex;
  final Set<String> completed;
  final ValueChanged<String> onCompleted;

  @override
  State<ExerciseGuide> createState() => _ExerciseGuideState();
}

class _ExerciseGuideState extends State<ExerciseGuide> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int index = widget.initialIndex;
  bool playing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = exercises[index];
    final isDone = widget.completed.contains(exercise.name);
    return Scaffold(
      backgroundColor: ink,
      body: SafeArea(child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 7, 16, 5),
          child: Row(children: [
            roundIcon(Icons.arrow_back, () => Navigator.pop(context)),
            const Spacer(),
            const Text('WORKOUT SESSION', style: TextStyle(color: muted, fontSize: 10, letterSpacing: 1.7, fontWeight: FontWeight.w800)),
            const Spacer(),
            roundIcon(Icons.more_horiz, () {}),
          ]),
        ),
        Expanded(child: PageView.builder(
          controller: _controller,
          onPageChanged: (value) => setState(() => index = value),
          itemCount: exercises.length,
          itemBuilder: (context, i) => _GuideSlide(
            exercise: exercises[i],
            index: i,
            completed: widget.completed.contains(exercises[i].name),
            onComplete: () {
              widget.onCompleted(exercises[i].name);
              setState(() {});
            },
            onPlaying: (value) => setState(() => playing = value),
          ),
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(23, 0, 23, 19),
          child: Column(children: [
            Row(children: [
              const Text('Next exercises', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${exercises.length - index - 1} remaining', style: const TextStyle(color: muted, fontSize: 12)),
            ]),
            const SizedBox(height: 9),
            SizedBox(height: 68, child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: exercises.length - index - 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, item) {
                final nextIndex = index + item + 1;
                final next = exercises[nextIndex];
                return InkWell(
                  onTap: () => _controller.animateToPage(nextIndex, duration: const Duration(milliseconds: 360), curve: Curves.easeOutCubic),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width - 46,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(9)),
                    child: Row(children: [
                      ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.asset(next.image, width: 54, height: 54, fit: BoxFit.cover)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(next.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('${next.duration}  ·  ${next.sets}', style: const TextStyle(color: muted, fontSize: 10)),
                      ])),
                      const Icon(Icons.play_circle_fill, color: lime),
                      const SizedBox(width: 5),
                    ]),
                  ),
                );
              },
            )),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, height: 52, child: FilledButton(
              onPressed: () {
                if (isDone) return;
                widget.onCompleted(exercise.name);
                if (index < exercises.length - 1) {
                  _controller.nextPage(duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
                } else {
                  Navigator.pop(context);
                }
              },
              style: FilledButton.styleFrom(backgroundColor: cyan, foregroundColor: ink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              child: Text(isDone ? 'EXERCISE COMPLETED ✓' : 'BEGIN EXERCISE', style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
            )),
          ]),
        ),
      ]))),
    );
  }
}

class _GuideSlide extends StatefulWidget {
  const _GuideSlide({required this.exercise, required this.index, required this.completed, required this.onComplete, required this.onPlaying});
  final Exercise exercise;
  final int index;
  final bool completed;
  final VoidCallback onComplete;
  final ValueChanged<bool> onPlaying;

  @override
  State<_GuideSlide> createState() => _GuideSlideState();
}

class _GuideSlideState extends State<_GuideSlide> {
  late final VideoPlayerController _video = VideoPlayerController.asset(widget.exercise.video);
  bool _videoReady = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _video.initialize().then((_) {
      if (!mounted) return;
      _video.setLooping(true);
      setState(() => _videoReady = true);
    }).catchError((_) {
      if (mounted) setState(() => _failed = true);
    });
    _video.addListener(_syncPlayback);
  }

  void _syncPlayback() => widget.onPlaying(_video.value.isPlaying);

  @override
  void dispose() {
    _video.removeListener(_syncPlayback);
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(23, 7, 23, 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: 1.18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Stack(fit: StackFit.expand, children: [
                if (_videoReady) FittedBox(fit: BoxFit.cover, child: SizedBox(width: _video.value.size.width, height: _video.value.size.height, child: VideoPlayer(_video)))
                else Image.asset(widget.exercise.image, fit: BoxFit.cover),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x78041419), Colors.transparent, Color(0x99041419)]))),
                if (_failed) const Center(child: Text('Video preview unavailable', style: TextStyle(color: Colors.white70))),
                Center(child: Material(
                  color: cyan,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      if (!_videoReady) return;
                      setState(() {
                        if (_video.value.isPlaying) {
                          _video.pause();
                        } else {
                          _video.play();
                        }
                      });
                    },
                    child: SizedBox(width: 62, height: 62, child: Icon(_videoReady && _video.value.isPlaying ? Icons.pause : Icons.play_arrow, color: ink, size: 38)),
                  ),
                )),
                Positioned(left: 14, top: 14, child: roundIcon(Icons.fullscreen, () {})),
                Positioned(right: 14, top: 14, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(30)), child: Text('${widget.index + 1} / ${exercises.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)))),
                if (_videoReady) Positioned(left: 12, right: 12, bottom: 10, child: VideoProgressIndicator(_video, allowScrubbing: true, colors: const VideoProgressColors(playedColor: cyan, bufferedColor: Colors.white54, backgroundColor: Colors.white24))),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          Text('EXERCISE ${widget.index + 1}/${exercises.length}', style: const TextStyle(color: lime, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          Text('Target your ${widget.exercise.muscle.toLowerCase().replaceAll(' · ', ' and ')} with ${widget.exercise.name}', style: const TextStyle(fontSize: 21, height: 1.2, fontWeight: FontWeight.w700)),
          const SizedBox(height: 13),
          Row(children: [
            _info(Icons.schedule, widget.exercise.duration),
            const SizedBox(width: 17),
            _info(Icons.repeat, widget.exercise.sets),
            const Spacer(),
            Text(widget.exercise.kind, style: const TextStyle(color: lime, fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 11),
          const Text('Keep your movement controlled and breathe steadily. Choose a comfortable pace and stop if you feel pain.', style: TextStyle(color: muted, fontSize: 12, height: 1.35)),
        ]),
      );

  Widget _info(IconData icon, String text) => Row(children: [Icon(icon, color: muted, size: 14), const SizedBox(width: 5), Text(text, style: const TextStyle(color: muted, fontSize: 11))]);
}
