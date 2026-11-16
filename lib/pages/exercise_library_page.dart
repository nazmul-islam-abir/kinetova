import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/exercise.dart';
import '../widgets/shared_widgets.dart';

class ExerciseLibraryPage extends StatefulWidget {
  const ExerciseLibraryPage({super.key, required this.completed, required this.onOpen});
  final Set<String> completed;
  final ValueChanged<int> onOpen;

  @override
  State<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  static const _categories = ['All', 'Freehand', 'Gym', 'Grow', 'Lose'];
  String _selectedCategory = 'All';
  List<int> get _filteredIndices => [
        for (var index = 0; index < exercises.length; index++)
          if (_selectedCategory == 'All' || exercises[index].categories.contains(_selectedCategory)) index,
      ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredIndices;
    return PageScaffold(
      title: 'Exercise library',
      eyebrow: 'FIND YOUR NEXT MOVE',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 116,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: const AssetImage('assets/images/sports.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(ink.withValues(alpha: .52), BlendMode.darken),
            ),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('MOVE AT YOUR PACE', style: TextStyle(color: lime, fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w900)),
            SizedBox(height: 6),
            Text('Choose what feels good today.', style: TextStyle(color: Colors.white, fontSize: 20, height: 1.08, fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 14),
        Row(children: [
          const Expanded(child: Text('Featured', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800))),
          Text('${exercises.length} videos', style: const TextStyle(color: muted, fontSize: 11)),
        ]),
        const SizedBox(height: 11),
        SizedBox(
          height: 138,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: exercises.length,
            separatorBuilder: (_, _) => const SizedBox(width: 11),
            itemBuilder: (context, index) => _FeaturedExerciseCard(
              exercise: exercises[index],
              complete: widget.completed.contains(exercises[index].name),
              onTap: () => widget.onOpen(index),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text('Browse by goal or style', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        const Text('Tap a category to filter', style: TextStyle(color: muted, fontSize: 10)),
        const SizedBox(height: 7),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final selected = category == _selectedCategory;
              return ChoiceChip(
                label: Text(category),
                selected: selected,
                onSelected: (_) => setState(() => _selectedCategory = category),
                selectedColor: lime,
                backgroundColor: panel,
                labelStyle: TextStyle(color: selected ? ink : Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                side: BorderSide(color: selected ? lime : Colors.white.withValues(alpha: .08)),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 7),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(.045, 0), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          ),
          child: Column(
            key: ValueKey(_selectedCategory),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: Text(_selectedCategory == 'All' ? 'All exercises' : '$_selectedCategory exercises', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
                Text('${filtered.length} results', style: const TextStyle(color: muted, fontSize: 11)),
              ]),
              const SizedBox(height: 10),
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(child: Text('More exercises are on the way', style: TextStyle(color: muted))),
                )
              else
                ...filtered.map((index) {
                  final exercise = exercises[index];
                  return _LibraryExerciseTile(
                    exercise: exercise,
                    complete: widget.completed.contains(exercise.name),
                    onTap: () => widget.onOpen(index),
                  );
                }),
            ]),
        ),
      ]),
    );
  }
}

class _FeaturedExerciseCard extends StatelessWidget {
  const _FeaturedExerciseCard({required this.exercise, required this.complete, required this.onTap});
  final Exercise exercise;
  final bool complete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.sizeOf(context).width * .64,
        child: Material(
          color: panel,
          borderRadius: BorderRadius.circular(17),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(exercise.image, fit: BoxFit.cover),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x10000000), Color(0xE607171E)]))),
              Positioned(
                top: 11,
                right: 11,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: lime, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .2), blurRadius: 12)]),
                  child: Icon(complete ? Icons.check_rounded : Icons.play_arrow_rounded, color: ink, size: 24),
                ),
              ),
              Positioned(
                left: 13,
                right: 13,
                bottom: 12,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(exercise.categories.join(' · ').toUpperCase(), style: const TextStyle(color: lime, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(exercise.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text('${exercise.duration}  ·  ${exercise.sets}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ]),
              ),
            ]),
          ),
        ),
      );
}

class _LibraryExerciseTile extends StatelessWidget {
  const _LibraryExerciseTile({required this.exercise, required this.complete, required this.onTap});
  final Exercise exercise;
  final bool complete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: panel.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 94,
              child: Row(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                  child: SizedBox(
                    width: 104,
                    height: 94,
                    child: Stack(fit: StackFit.expand, children: [
                      Image.asset(exercise.image, fit: BoxFit.cover),
                      ColoredBox(color: Colors.black.withValues(alpha: .17)),
                      Center(child: Icon(Icons.play_circle_fill_rounded, color: Colors.white.withValues(alpha: .95), size: 34)),
                    ]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(exercise.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(exercise.muscle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 9, letterSpacing: .5)),
                    const SizedBox(height: 6),
                    Text('${exercise.categories.join(' · ')}  ·  ${exercise.duration}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: lime, fontSize: 10, fontWeight: FontWeight.w700)),
                  ]),
                )),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(complete ? Icons.check_circle_rounded : Icons.play_arrow_rounded, color: complete ? lime : Colors.white70, size: 21),
                ),
              ]),
            ),
          ),
        ),
      );
}
