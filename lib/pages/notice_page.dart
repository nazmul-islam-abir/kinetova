import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_colors.dart';

Route<void> noticeFoldRoute() => PageRouteBuilder<void>(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 760),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) => const NoticePage(),
      transitionsBuilder: (_, animation, _, child) {
        final fold = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        final zoom = Tween<double>(begin: .78, end: 1).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        ));
        final angle = Tween<double>(begin: -math.pi / 2, end: 0).animate(fold);
        final drop = Tween<Offset>(begin: const Offset(0, -.12), end: Offset.zero).animate(fold);
        return AnimatedBuilder(
          animation: animation,
          child: SlideTransition(position: drop, child: child),
          builder: (context, page) => Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, .0014)
                ..rotateX(angle.value),
              child: Transform.scale(
                scale: zoom.value,
                alignment: Alignment.topCenter,
                child: page,
              ),
            ),
          ),
        );
      },
    );

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ink,
        body: Stack(fit: StackFit.expand, children: [
          Positioned.fill(child: Opacity(opacity: .22, child: Image.asset('assets/images/sports.jpg', fit: BoxFit.cover))),
          SafeArea(child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 13, 20, 16),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: IconButton.styleFrom(backgroundColor: panel, foregroundColor: Colors.white),
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                ),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Your notices', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
                  SizedBox(height: 3),
                  Text('A little nudge for your next move', style: TextStyle(color: muted, fontSize: 12)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: lime.withValues(alpha: .14), borderRadius: BorderRadius.circular(20)),
                  child: const Text('3 NEW', style: TextStyle(color: lime, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w900)),
                ),
              ]),
            ),
            Container(height: 1, color: Colors.white.withValues(alpha: .07)),
            Expanded(
              child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 30), children: const [
                _NoticeCard(icon: Icons.bolt_rounded, label: 'TODAY', title: 'Your training is ready', message: 'Chest day is waiting. Start with one set and find your rhythm.', time: 'Just now'),
                _NoticeCard(icon: Icons.flag_rounded, label: 'WEEKLY GOAL', title: 'You are building momentum', message: 'Two sessions down this week. Your next one keeps the streak alive.', time: '2 hours ago'),
                _NoticeCard(icon: Icons.favorite_rounded, label: 'COMMUNITY', title: 'Someone sent you a cheer', message: '“Keep showing up. You are doing great!”', time: 'Yesterday'),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.keyboard_double_arrow_up_rounded),
                  label: const Text('FOLD AWAY'),
                  style: OutlinedButton.styleFrom(foregroundColor: lime, side: BorderSide(color: lime.withValues(alpha: .42))),
                ),
              ),
            ),
          ])),
        ]),
      );
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.icon, required this.label, required this.title, required this.message, required this.time});
  final IconData icon;
  final String label;
  final String title;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white.withValues(alpha: .06))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: lime.withValues(alpha: .13), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: lime, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(label, style: const TextStyle(color: lime, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w900))),
              Text(time, style: const TextStyle(color: muted, fontSize: 10)),
            ]),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(color: muted, fontSize: 12, height: 1.35)),
          ])),
        ]),
      );
}
