import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/radar_screen.dart';
import 'screens/profile_screen.dart';

void main() => runApp(const UnivaApp());

class UnivaApp extends StatelessWidget {
  const UnivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIVA',
      debugShowCheckedModeBanner: false,
      theme: univaTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const OnboardingScreen(),
        '/radar': (_) => const RadarScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
