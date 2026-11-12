import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _Chip {
  final String label;
  final Color color;
  final double x, y, phase, tilt;
  const _Chip(this.label, this.color, this.x, this.y, this.phase, this.tilt);
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))
        ..repeat();
  double _drag = 0;

  static const chips = [
    _Chip('🍜 mie ayam', K.coral, 0.05, 0.06, 0.0, -0.10),
    _Chip('🎨 ngegambar', K.lilac, 0.55, 0.02, 1.2, 0.08),
    _Chip('🎸 jam session', K.sun, 0.12, 0.26, 2.1, 0.05),
    _Chip('📚 ngerjain tugas', K.mint, 0.50, 0.24, 3.0, -0.07),
    _Chip('⚽ futsal', K.coral, 0.06, 0.46, 4.0, 0.10),
    _Chip('☕ ngopi', K.lilac, 0.58, 0.44, 5.0, -0.05),
  ];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final trackW = box.maxWidth - 48;
          const handle = 60.0;
          final maxDrag = trackW - handle - 8;
          final progress = (_drag / maxDrag).clamp(0.0, 1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Text('univa.',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: K.coral,
                        letterSpacing: -1)),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => LayoutBuilder(builder: (context, a) {
                    return Stack(children: [
                      for (final ch in chips)
                        Positioned(
                          left: ch.x * a.maxWidth,
                          top: ch.y * a.maxHeight +
                              math.sin(_c.value * 2 * math.pi + ch.phase) * 10,
                          child: Transform.rotate(
                            angle: ch.tilt,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: ch.color,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(ch.label,
                                  style: const TextStyle(
                                      color: K.ink,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15)),
                            ),
                          ),
                        ),
                    ]);
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.rotate(
                      angle: -0.03,
                      child: const Text('Kampus lu',
                          style: TextStyle(
                              fontSize: 44,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              color: K.text)),
                    ),
                    Transform.rotate(
                      angle: 0.02,
                      child: const Text('lagi rame.',
                          style: TextStyle(
                              fontSize: 44,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                              color: K.sun)),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Lihat siapa nongkrong di mana, ikut acara dadakan, dan nemuin orang sefrekuensi.',
                      style: TextStyle(color: K.muted, fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                      color: K.plum, borderRadius: BorderRadius.circular(34)),
                  child: Stack(children: [
                    Center(
                      child: Opacity(
                        opacity: 1 - progress,
                        child: const Text('Geser buat masuk',
                            style: TextStyle(
                                color: K.muted, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Positioned(
                      left: 4 + _drag,
                      top: 4,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (d) => setState(() =>
                            _drag = (_drag + d.delta.dx).clamp(0.0, maxDrag)),
                        onHorizontalDragEnd: (_) {
                          if (progress > 0.85) {
                            Navigator.pushReplacementNamed(context, '/radar');
                          } else {
                            setState(() => _drag = 0);
                          }
                        },
                        child: Container(
                          width: handle,
                          height: handle,
                          decoration: const BoxDecoration(
                              color: K.coral, shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_forward_rounded,
                              color: K.ink),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
