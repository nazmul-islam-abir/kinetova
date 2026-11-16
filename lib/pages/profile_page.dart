import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/shared_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.onOpenNotices});
  final VoidCallback onOpenNotices;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Offset? _pointerStart;

  void _handlePointerMove(PointerMoveEvent event) {
    final start = _pointerStart;
    if (start == null) return;
    if (start.dy < 72 && event.localPosition.dy - start.dy > 78) {
      _pointerStart = null;
      widget.onOpenNotices();
    }
  }

  @override
  Widget build(BuildContext context) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) => _pointerStart = event.localPosition,
        onPointerMove: _handlePointerMove,
        onPointerUp: (_) => _pointerStart = null,
        onPointerCancel: (_) => _pointerStart = null,
        child: PageScaffold(
          title: 'Profile',
          eyebrow: 'YOUR FITNESS SPACE',
          child: Column(children: [
            Material(
              color: panel,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: widget.onOpenNotices,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: lime.withValues(alpha: .14), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.notifications_active_outlined, color: lime, size: 20),
                    ),
                    const SizedBox(width: 11),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Your notices', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                      SizedBox(height: 3),
                      Text('Swipe down from the top, or tap to open', style: TextStyle(color: muted, fontSize: 10)),
                    ])),
                    const Icon(Icons.swipe_down_rounded, color: lime, size: 20),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: panel.withValues(alpha: .9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: lime.withValues(alpha: .18)),
              ),
              child: Row(children: [
                const Icon(Icons.air_rounded, color: lime, size: 19),
                const SizedBox(width: 9),
                const Expanded(child: Text('Need a reset? Swipe left for your quiet timer.', style: TextStyle(color: Colors.white70, fontSize: 10))),
                Icon(Icons.arrow_back_rounded, color: lime.withValues(alpha: .8), size: 17),
              ]),
            ),
            const SizedBox(height: 12),
            ImageCard(image: 'assets/images/download.jpg', height: 205, child: const Align(alignment: Alignment.bottomLeft, child: Text('Keep showing up.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)))),
            const SizedBox(height: 15),
            const CircleAvatar(radius: 38, backgroundColor: Color(0xFF1A3942), child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 10),
            const Text('Your profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const Text('Make this plan work for you', style: TextStyle(color: muted, fontSize: 12)),
            const SizedBox(height: 23),
            SettingTile(icon: Icons.flag_outlined, title: 'Weekly target', subtitle: '4 workouts per week'),
            SettingTile(icon: Icons.fitness_center, title: 'Workout style', subtitle: 'Gym + bodyweight'),
            SettingTile(icon: Icons.notifications_none, title: 'Reminders', subtitle: 'Daily motivation'),
          ]),
        ),
      );
}
