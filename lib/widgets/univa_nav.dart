import 'package:flutter/material.dart';
import '../theme.dart';

class UnivaNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const UnivaNav({super.key, required this.current, required this.onTap});

  static const items = [
    (Icons.radar_rounded, 'Radar'),
    (Icons.local_fire_department_rounded, 'Feed'),
    (Icons.forum_rounded, 'Chat'),
    (Icons.person_rounded, 'Kamu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: K.plum,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final on = i == current;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: on ? 18 : 14, vertical: 12),
              decoration: BoxDecoration(
                color: on ? K.sun : Colors.transparent,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(children: [
                Icon(items[i].$1, color: on ? K.ink : K.muted, size: 22),
                if (on) ...[
                  const SizedBox(width: 6),
                  Text(items[i].$2,
                      style: const TextStyle(
                          color: K.ink, fontWeight: FontWeight.w800)),
                ],
              ]),
            ),
          );
        }),
      ),
    );
  }
}
