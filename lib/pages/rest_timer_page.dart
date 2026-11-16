import 'dart:async';

import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/shared_widgets.dart';

class RestSession {
  const RestSession({required this.kind, required this.duration, required this.savedAt});

  final String kind;
  final Duration duration;
  final DateTime savedAt;
}

enum _RestMode {
  breakTime('Break', Icons.coffee_rounded, 5 * 60, 'Take a moment between sets.'),
  breathing('Breathe', Icons.air_rounded, 60, 'Slow your breath and reset.'),
  rest('Rest', Icons.self_improvement_rounded, 10 * 60, 'Give your body room to recover.');

  const _RestMode(this.label, this.icon, this.seconds, this.hint);
  final String label;
  final IconData icon;
  final int seconds;
  final String hint;
}

class RestTimerPage extends StatefulWidget {
  const RestTimerPage({super.key, required this.onSave});

  final ValueChanged<RestSession> onSave;

  @override
  State<RestTimerPage> createState() => _RestTimerPageState();
}

class _RestTimerPageState extends State<RestTimerPage> with AutomaticKeepAliveClientMixin<RestTimerPage> {
  @override
  bool get wantKeepAlive => true;
  _RestMode _mode = _RestMode.breakTime;
  Timer? _ticker;
  late int _remainingSeconds = _mode.seconds;
  int _elapsedSeconds = 0;
  int _lastSavedElapsed = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _selectMode(_RestMode mode) {
    if (_mode == mode) return;
    _ticker?.cancel();
    setState(() {
      _mode = mode;
      _remainingSeconds = mode.seconds;
      _elapsedSeconds = 0;
      _lastSavedElapsed = 0;
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _ticker?.cancel();
      setState(() => _isRunning = false);
      return;
    }
    if (_remainingSeconds == 0) return;

    setState(() => _isRunning = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (ticker) {
      if (!mounted) {
        ticker.cancel();
        return;
      }
      setState(() {
        _remainingSeconds = (_remainingSeconds - 1).clamp(0, _mode.seconds);
        _elapsedSeconds++;
        if (_remainingSeconds == 0) {
          ticker.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _saveRecord() {
    if (_elapsedSeconds == 0 || _lastSavedElapsed == _elapsedSeconds) return;
    widget.onSave(RestSession(
      kind: _mode.label,
      duration: Duration(seconds: _elapsedSeconds),
      savedAt: DateTime.now(),
    ));
    setState(() => _lastSavedElapsed = _elapsedSeconds);
  }

  void _restart() {
    _ticker?.cancel();
    setState(() {
      _remainingSeconds = _mode.seconds;
      _elapsedSeconds = 0;
      _lastSavedElapsed = 0;
      _isRunning = false;
    });
  }

  String _clock(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final saved = _elapsedSeconds > 0 && _lastSavedElapsed == _elapsedSeconds;
    final progress = _elapsedSeconds / _mode.seconds;
    return PageScaffold(
      eyebrow: 'A LITTLE SPACE FOR YOU',
      title: 'Pause & breathe',
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 385,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 5,
                  child: Container(
                    width: 300,
                    height: 175,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF24434A), Color(0xFF10252C), Color(0xFF0B1A20)],
                      ),
                      border: Border.all(color: lime.withValues(alpha: .28)),
                      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 26, offset: Offset(0, 13))],
                    ),
                    child: Stack(children: [
                      Positioned(
                        top: 17,
                        left: 0,
                        right: 0,
                        child: Icon(Icons.account_balance_wallet_rounded, color: lime.withValues(alpha: .50), size: 27),
                      ),
                      Positioned(
                        top: 57,
                        left: 18,
                        right: 18,
                        child: Container(
                          height: 94,
                          decoration: BoxDecoration(
                            color: ink.withValues(alpha: .74),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: .06)),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(child: Text('YOUR RESET POCKET', style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 1.8, fontWeight: FontWeight.w800))),
                      ),
                    ]),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: .82, end: 1),
                  duration: const Duration(milliseconds: 720),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) => Transform.translate(
                    offset: Offset(0, 9 + (1 - scale) * 70),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: .52, end: -.12),
                      duration: const Duration(milliseconds: 720),
                      curve: Curves.easeOutCubic,
                      builder: (context, angle, _) => Transform.rotate(
                        angle: angle,
                        child: Transform.scale(scale: scale, child: child),
                      ),
                    ),
                  ),
                  child: _TimerCard(
                    width: (MediaQuery.sizeOf(context).width - 86).clamp(220, 290).toDouble(),
                    mode: _mode,
                    time: _clock(_remainingSeconds),
                    elapsed: _clock(_elapsedSeconds),
                    progress: progress.clamp(0.0, 1.0),
                    running: _isRunning,
                    saved: saved,
                    onPlayPause: _toggleTimer,
                    onSave: _saveRecord,
                    onRestart: _restart,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text('A quiet moment can be part of your progress.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _RestMode.values.map((mode) {
              final selected = _mode == mode;
              return ChoiceChip(
                avatar: Icon(mode.icon, size: 16, color: selected ? ink : lime),
                label: Text(mode.label),
                selected: selected,
                onSelected: (_) => _selectMode(mode),
                selectedColor: lime,
                backgroundColor: panel,
                labelStyle: TextStyle(color: selected ? ink : Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                side: BorderSide(color: selected ? lime : Colors.white12),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 7),
          Text(_mode.hint, style: const TextStyle(color: muted, fontSize: 11)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(color: panel.withValues(alpha: .88), borderRadius: BorderRadius.circular(15)),
            child: const Row(children: [
              Icon(Icons.swipe_rounded, color: lime, size: 19),
              SizedBox(width: 9),
              Expanded(child: Text('You found a quiet page after Profile. Swipe back whenever you’re ready.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.35))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.width,
    required this.mode,
    required this.time,
    required this.elapsed,
    required this.progress,
    required this.running,
    required this.saved,
    required this.onPlayPause,
    required this.onSave,
    required this.onRestart,
  });

  final double width;
  final _RestMode mode;
  final String time;
  final String elapsed;
  final double progress;
  final bool running;
  final bool saved;
  final VoidCallback onPlayPause;
  final VoidCallback onSave;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: 300,
        padding: const EdgeInsets.fromLTRB(21, 20, 21, 19),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF7F3E9), Color(0xFFE2DDCF)]),
          border: Border.all(color: Colors.white.withValues(alpha: .8)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .36), blurRadius: 24, offset: const Offset(0, 14))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(mode.icon, color: const Color(0xFF284148), size: 19),
            const SizedBox(width: 7),
            Expanded(child: Text(mode.label.toUpperCase(), style: const TextStyle(color: Color(0xFF526064), fontSize: 9, letterSpacing: 1.6, fontWeight: FontWeight.w900))),
            const Icon(Icons.spa_rounded, color: Color(0xFF789176), size: 18),
          ]),
          const Spacer(),
          Text(time, style: const TextStyle(color: Color(0xFF13262B), fontSize: 43, letterSpacing: -1.5, fontWeight: FontWeight.w800, fontFeatures: [FontFeature.tabularFigures()])),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: progress, minHeight: 5, color: const Color(0xFF426B55), backgroundColor: const Color(0xFFD0D0C5)),
          ),
          const SizedBox(height: 7),
          Text(running ? 'A moment for yourself' : 'Elapsed $elapsed', style: const TextStyle(color: Color(0xFF6D7775), fontSize: 10)),
          const Spacer(),
          Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: onPlayPause,
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF183038), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
                icon: Icon(running ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 18),
                label: Text(running ? 'Pause' : 'Start', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 7),
            IconButton(
              tooltip: saved ? 'Record saved' : 'Keep record',
              onPressed: saved ? null : onSave,
              style: IconButton.styleFrom(backgroundColor: const Color(0xFFD5DDCD), foregroundColor: const Color(0xFF203A32)),
              icon: Icon(saved ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined, size: 20),
            ),
            IconButton(
              tooltip: 'Restart timer',
              onPressed: onRestart,
              style: IconButton.styleFrom(backgroundColor: const Color(0xFFD5DDCD), foregroundColor: const Color(0xFF203A32)),
              icon: const Icon(Icons.refresh_rounded, size: 20),
            ),
          ]),
          const SizedBox(height: 2),
          Center(child: Text('RECORD  ·  $elapsed', style: const TextStyle(color: Color(0xFF77817D), fontSize: 8, letterSpacing: 1.1, fontWeight: FontWeight.w800))),
        ]),
      );
}
