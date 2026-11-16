import 'package:flutter/material.dart';
import '../app_colors.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.title, required this.eyebrow, required this.child});
  final String title;
  final String eyebrow;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: [
    SliverPadding(padding: const EdgeInsets.fromLTRB(22, 18, 22, 120), sliver: SliverList.list(children: [
      Text(eyebrow, style: const TextStyle(color: lime, fontSize: 10, letterSpacing: 1.6, fontWeight: FontWeight.w900)),
      const SizedBox(height: 6),
      Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
      const SizedBox(height: 18),
      child,
    ])),
  ]);
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.image, required this.height, required this.child});
  final String image;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover, colorFilter: ColorFilter.mode(const Color(0x9907161D), BlendMode.darken))),
    child: child,
  );
}

class SettingTile extends StatelessWidget {
  const SettingTile({super.key, required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(13)),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: cyan.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: cyan, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: muted, fontSize: 11))])),
      const Icon(Icons.chevron_right, color: muted),
    ]),
  );
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.fitness_center_rounded, Icons.fitness_center_rounded, 'Library'),
    (Icons.track_changes_rounded, Icons.track_changes_rounded, 'Goals'),
    (Icons.insights_outlined, Icons.insights_rounded, 'Analysis'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFF101B20),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: Container(
              height: 58,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF171D20),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: .07)),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                final activeWidth = constraints.maxWidth * .38;
                final idleWidth = (constraints.maxWidth - activeWidth) / (_items.length - 1);
                return Row(children: List.generate(_items.length, (index) {
                  final active = selected == index;
                  final item = _items[index];
                  return Tooltip(
                    message: item.$3,
                    child: Semantics(
                      button: true,
                      selected: active,
                      label: item.$3,
                      child: InkWell(
                        onTap: () => onSelect(index),
                        borderRadius: BorderRadius.circular(28),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeInOutCubic,
                          width: active ? activeWidth : idleWidth,
                          height: 48,
                          padding: EdgeInsets.symmetric(horizontal: active ? 8 : 0),
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFF2B3235) : Colors.transparent,
                            borderRadius: BorderRadius.circular(27),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: active ? lime : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                active ? item.$2 : item.$1,
                                color: active ? ink : Colors.white.withValues(alpha: .76),
                                size: 21,
                              ),
                            ),
                            if (active) ...[
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  item.$3,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ]),
                        ),
                      ),
                    ),
                  );
                }));
              }),
            ),
          ),
        ),
      );
}

Widget roundIcon(IconData icon, VoidCallback onPressed) => Material(
  color: const Color(0x99071A22),
  shape: const CircleBorder(),
  child: InkWell(customBorder: const CircleBorder(), onTap: onPressed, child: SizedBox(width: 42, height: 42, child: Icon(icon, size: 20))),
);
