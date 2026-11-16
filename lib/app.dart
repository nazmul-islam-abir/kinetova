import 'package:flutter/material.dart';
import 'main_shell.dart';
import 'app_colors.dart';

class KinetovaApp extends StatelessWidget {
  const KinetovaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'KINETOVA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ink,
          colorScheme: ColorScheme.fromSeed(seedColor: lime, brightness: Brightness.dark),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const MainShell(),
      );
}
