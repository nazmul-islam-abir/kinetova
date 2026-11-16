import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/shared_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title, required this.subtitle, required this.image, required this.icon, required this.action, required this.actionText});
  final String title;
  final String subtitle;
  final String image;
  final IconData icon;
  final VoidCallback action;
  final String actionText;

  @override
  Widget build(BuildContext context) => PageScaffold(title: title, eyebrow: 'KINETOVA', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _MotivationDeck(image: image),
    const SizedBox(height: 16),
    SettingTile(icon: icon, title: 'Today’s plan', subtitle: 'Chest · 4 guided exercises'),
    const SizedBox(height: 14),
    SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: action, style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: ink), child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.w900)))),
  ]));
}

class _MotivationDeck extends StatefulWidget {
  const _MotivationDeck({required this.image});
  final String image;

  @override
  State<_MotivationDeck> createState() => _MotivationDeckState();
}

class _MotivationDeckState extends State<_MotivationDeck> with SingleTickerProviderStateMixin {
  late final AnimationController _swipeController;
  Animation<Offset>? _flight;
  bool _animating = false;
  bool _dismissCard = false;
  int _index = 0;
  Offset _dragOffset = Offset.zero;

  List<(String, String, String)> get _messages => [
    ('Ready to move today?', 'Your next chapter starts with one step.', widget.image),
    ('You are stronger than yesterday.', 'Show up for the person you are becoming.', 'assets/images/gym day.jpg'),
    ('Progress loves consistency.', 'Small efforts add up. Keep your rhythm.', 'assets/images/sports.jpg'),
    ('Make today count.', 'You do not need perfect. You just need to begin.', 'assets/images/download (3).jpg'),
    ('One more rep. One more reason.', 'Your future self is cheering you on.', 'assets/images/dfg.jpg'),
    ('Move at your own pace.', 'Every step forward is still forward.', 'assets/images/fdh.jpg'),
    ('Keep showing up.', 'Every session is a promise you keep to yourself.', 'assets/images/sdfg.jpg'),
    ('Start where you are.', 'A little movement can change your whole day.', 'assets/images/download (4).jpg'),
  ];

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 340))
      ..addListener(() {
        if (mounted && _flight != null) setState(() => _dragOffset = _flight!.value);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() {
            if (_dismissCard) _index = (_index + 1) % _messages.length;
            _dragOffset = Offset.zero;
            _animating = false;
            _flight = null;
          });
        }
      });
  }

  void _release(DragEndDetails details) {
    if (_animating) return;
    final velocity = details.velocity.pixelsPerSecond;
    final dismiss = _dragOffset.distance >= 38 || velocity.distance > 620;
    final direction = _dragOffset.distance > 1
        ? _dragOffset / _dragOffset.distance
        : (velocity.distance > 1 ? velocity / velocity.distance : const Offset(1, 0));
    final size = MediaQuery.sizeOf(context);
    final destination = dismiss
        ? Offset(direction.dx * size.width * 1.35, direction.dy * size.height * 1.35)
        : Offset.zero;
    _animateCardAway(destination, dismiss: dismiss);
  }

  void _animateCardAway(Offset destination, {bool dismiss = true}) {
    if (_animating) return;
    _dismissCard = dismiss;
    final end = dismiss && destination.distance < 1
        ? Offset(0, -MediaQuery.sizeOf(context).height * .9)
        : destination;
    _flight = Tween<Offset>(begin: _dragOffset, end: end).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.easeOutCubic),
    );
    setState(() => _animating = true);
    _swipeController.forward(from: 0);
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = _messages[_index];
    return SizedBox(
      height: 370,
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned.fill(child: Transform.rotate(angle: -.055, alignment: Alignment.bottomLeft, child: _deckBack(2))),
        Positioned.fill(child: Transform.rotate(angle: -.028, alignment: Alignment.bottomLeft, child: _deckBack(1))),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.translationValues(_dragOffset.dx, _dragOffset.dy, 0)
            ..rotateZ((_dragOffset.dx * .00055).clamp(-.16, .16).toDouble()),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              if (!_animating) setState(() => _dragOffset += details.delta);
            },
            onHorizontalDragEnd: _release,
            onDoubleTap: () => _animateCardAway(Offset.zero),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(message.$3, fit: BoxFit.cover, alignment: Alignment.center),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x66101B20), Color(0x33101B20), Color(0xF207171E)], stops: [0, .34, 1]))),
                Positioned(left: 18, top: 18, child: _suitMark(Icons.favorite_rounded)),
                Positioned(right: 18, top: 56, child: Opacity(opacity: .75, child: _suitMark(Icons.favorite_rounded))),
                Positioned(left: 20, right: 20, bottom: 21, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('MOVE WITH PURPOSE', style: TextStyle(color: lime, fontSize: 10, letterSpacing: 1.6, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween(begin: const Offset(0, .18), end: Offset.zero).animate(animation), child: child)),
                    child: Column(key: ValueKey(_index), crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(message.$1, style: const TextStyle(fontSize: 25, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -.4)),
                      const SizedBox(height: 8),
                      Text(message.$2, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3)),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  Row(children: [
                    ...List.generate(_messages.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 220), width: i == _index ? 18 : 5, height: 5, margin: const EdgeInsets.only(right: 4), decoration: BoxDecoration(color: i == _index ? lime : Colors.white54, borderRadius: BorderRadius.circular(9)))),
                    const Spacer(),
                    const Icon(Icons.swipe, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    const Text('SWIPE FOR MORE', style: TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w800)),
                  ]),
                ])),
                ]),
              ),
            ),
          ),
      ]),
    );
  }

  Widget _deckBack(int layer) {
    final nextImage = _messages[(_index + layer) % _messages.length].$3;
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: lime.withValues(alpha: .24)),
          borderRadius: BorderRadius.circular(23),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .2), blurRadius: 12, offset: const Offset(0, 5))],
        ),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(nextImage, fit: BoxFit.cover),
          ColoredBox(color: ink.withValues(alpha: layer == 1 ? .16 : .28)),
          Positioned(left: 16, top: 16, child: Opacity(opacity: .8, child: _suitMark(Icons.favorite_rounded))),
        ]),
      ),
    );
  }

  Widget _suitMark(IconData icon) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(color: lime.withValues(alpha: .16), shape: BoxShape.circle, border: Border.all(color: lime.withValues(alpha: .35))),
    child: Icon(icon, size: 15, color: lime),
  );
}
