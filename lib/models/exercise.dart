import 'package:flutter/material.dart';

class Exercise {
  const Exercise({
    required this.name,
    required this.muscle,
    required this.kind,
    required this.duration,
    required this.sets,
    required this.image,
    required this.video,
    required this.icon,
    required this.categories,
  });

  final String name;
  final String muscle;
  final String kind;
  final String duration;
  final String sets;
  final String image;
  final String video;
  final IconData icon;
  final List<String> categories;
}

const exercises = [
  Exercise(name: 'Bench Press', muscle: 'CHEST · TRICEPS', kind: 'COMPOUND', duration: '8 min', sets: '4 sets', image: 'assets/images/download.jpg', video: 'assets/videos/90efcb0c1a93678690207fd4295f8d64_720w.mp4', icon: Icons.fitness_center, categories: ['Gym', 'Grow']),
  Exercise(name: 'Chest Dip', muscle: 'CHEST · SHOULDERS', kind: 'COMPOUND', duration: '10 min', sets: '3 sets', image: 'assets/images/download (1).jpg', video: 'assets/videos/c3422abb82c272fbe4efdd132f7b00ea_720w.mp4', icon: Icons.sports_gymnastics, categories: ['Freehand', 'Grow']),
  Exercise(name: 'Dumbbell Fly', muscle: 'CHEST', kind: 'ISOLATION', duration: '8 min', sets: '3 sets', image: 'assets/images/sports.jpg', video: 'assets/videos/90efcb0c1a93678690207fd4295f8d64_720w.mp4', icon: Icons.sports_gymnastics, categories: ['Gym', 'Grow']),
  Exercise(name: 'Brisk Walking', muscle: 'FULL BODY', kind: 'BODYWEIGHT', duration: '15 min', sets: 'Steady pace', image: 'assets/images/download (2).jpg', video: 'assets/videos/Brisk Walking.mp4', icon: Icons.directions_walk, categories: ['Freehand', 'Lose']),
];
