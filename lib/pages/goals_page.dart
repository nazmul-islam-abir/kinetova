import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/exercise.dart';
import '../widgets/shared_widgets.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key, required this.completed, required this.onOpen});
  final Set<String> completed;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final completedCount = completed.length;
    final progress = (completedCount / exercises.length).clamp(0.0, 1.0).toDouble();
    final nextIndex = exercises.indexWhere((exercise) => !completed.contains(exercise.name));
    return PageScaffold(
      title: 'Goals & plan',
      eyebrow: 'BUILD YOUR ROUTINE',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ImageCard(
          image: 'assets/images/Maroon Minimalist Stretching Silhouette.png',
          height: 190,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text('SMALL STEPS, BIG CHANGE', style: TextStyle(color: lime, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
            const SizedBox(height: 7),
            const Text('Your week in motion', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('$completedCount of ${exercises.length} sessions completed', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.track_changes_rounded, color: lime, size: 19),
              const SizedBox(width: 9),
              const Expanded(child: Text('Weekly workout goal', style: TextStyle(fontWeight: FontWeight.w800))),
              Text('$completedCount / ${exercises.length}', style: const TextStyle(color: lime, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress, minHeight: 9, color: lime, backgroundColor: Colors.white12),
            ),
            const SizedBox(height: 10),
            Text(progress >= 1 ? 'Goal reached. Take a moment to celebrate.' : 'Complete ${exercises.length - completedCount} more sessions to reach your weekly goal.', style: const TextStyle(color: muted, fontSize: 11)),
          ]),
        ),
        const SizedBox(height: 21),
        Row(children: [
          const Expanded(child: Text('This week', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800))),
          Text('$completedCount/${exercises.length} done', style: const TextStyle(color: muted, fontSize: 11)),
        ]),
        const SizedBox(height: 11),
        ...List.generate(exercises.length, (index) {
          final exercise = exercises[index];
          final done = completed.contains(exercise.name);
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(children: [
              SizedBox(width: 43, child: Text(['MON', 'TUE', 'WED', 'THU'][index], style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w800))),
              Expanded(child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(color: panel.withValues(alpha: .94), borderRadius: BorderRadius.circular(11)),
                child: Row(children: [
                  Icon(done ? Icons.check_circle_rounded : Icons.circle_outlined, color: done ? lime : muted, size: 17),
                  const SizedBox(width: 8),
                  Expanded(child: Text(exercise.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  Text(done ? 'DONE' : 'PLANNED', style: TextStyle(color: done ? lime : muted, fontSize: 8, letterSpacing: .8, fontWeight: FontWeight.w900)),
                ]),
              )),
            ]),
          );
        }),
        const SizedBox(height: 15),
        Row(children: [
          const Expanded(child: Text('Today’s plan', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800))),
          const Text('OPEN TO TRAIN', style: TextStyle(color: muted, fontSize: 8, letterSpacing: .8, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 10),
        ...List.generate(exercises.length, (index) {
          final exercise = exercises[index];
          final done = completed.contains(exercise.name);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: panel.withValues(alpha: .94),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => onOpen(index),
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(height: 73, child: Row(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                    child: Image.asset(exercise.image, width: 72, height: 73, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 11),
                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(exercise.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('${exercise.duration} · ${exercise.sets}', style: const TextStyle(color: muted, fontSize: 10)),
                  ])),
                  Icon(done ? Icons.check_circle_rounded : Icons.play_circle_fill_rounded, color: done ? lime : lime, size: 23),
                  const SizedBox(width: 12),
                ])),
              ),
            ),
          );
        }),
        const SizedBox(height: 3),
        SizedBox(
          width: double.infinity,
          height: 51,
          child: FilledButton(
            onPressed: () => onOpen(nextIndex < 0 ? 0 : nextIndex),
            style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: ink),
            child: Text(nextIndex < 0 ? 'REPEAT A WORKOUT' : 'START NEXT EXERCISE', style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: .8)),
          ),
        ),
      ]),
    );
  }
}
