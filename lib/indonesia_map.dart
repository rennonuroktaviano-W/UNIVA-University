import 'package:flutter/material.dart';
import 'theme.dart';

/// Peta Indonesia sederhana (siluet) digambar dari koordinat lon/lat.
class IndoMap {
  static const double minLon = 95, maxLat = 6;
  static const double lonSpan = 46, latSpan = 17;

  static double scaleFor(Size c) => c.width * 0.92 / lonSpan;

  static Offset project(double lon, double lat, Size c) {
    final sc = scaleFor(c);
    final padX = (c.width - lonSpan * sc) / 2;
    final padY = (c.height - latSpan * sc) / 2;
    return Offset(padX + (lon - minLon) * sc, padY + (maxLat - lat) * sc);
  }

  // (lon, lat) tiap pulau, disederhanakan
  static const islands = <List<(double, double)>>[
    // Sumatra
    [(95.3, 5.6), (97.0, 5.3), (98.2, 4.2), (99.5, 3.2), (100.8, 2.2), (101.9, 1.6),
     (103.0, 1.0), (103.9, 0.4), (103.2, -0.5), (104.2, -1.5), (104.9, -2.6),
     (106.0, -3.0), (106.1, -4.2), (105.8, -5.5), (105.2, -5.9), (104.4, -5.7),
     (103.4, -4.9), (102.3, -3.9), (101.2, -2.8), (100.4, -1.5), (99.6, -0.3),
     (98.9, 1.1), (98.2, 2.2), (97.2, 3.2), (96.2, 4.2)],
    // Jawa
    [(105.2, -6.8), (105.9, -6.0), (106.8, -6.1), (108.0, -6.3), (108.6, -6.7),
     (110.0, -6.9), (111.0, -6.6), (112.0, -6.9), (112.8, -7.2), (113.8, -7.7),
     (114.5, -8.0), (114.3, -8.6), (113.0, -8.4), (111.5, -8.2), (110.0, -8.0),
     (108.8, -7.8), (107.5, -7.7), (106.5, -7.4), (105.5, -7.0)],
    // Madura
    [(112.7, -7.0), (113.9, -6.9), (113.7, -7.2), (112.8, -7.2)],
    // Bangka & Belitung
    [(105.1, -1.5), (106.0, -1.5), (106.8, -2.4), (106.4, -3.1), (105.6, -2.4)],
    [(107.5, -2.5), (108.3, -2.6), (108.3, -3.3), (107.6, -3.3)],
    // Kalimantan
    [(116.8, 6.9), (118.0, 6.0), (119.2, 5.1), (118.1, 4.2), (117.7, 3.2), (118.1, 1.9),
     (117.9, 1.0), (117.5, 0.2), (117.3, -0.7), (116.8, -1.4), (116.3, -2.4),
     (115.5, -3.3), (114.5, -3.7), (113.2, -3.3), (111.8, -3.4), (110.5, -3.0),
     (110.0, -2.0), (109.3, -1.0), (109.1, 0.0), (109.0, 1.0), (109.6, 1.9),
     (110.8, 1.8), (111.8, 2.6), (113.0, 3.3), (114.5, 4.5), (115.6, 5.0), (116.3, 6.2)],
    // Sulawesi
    [(125.1, 1.7), (124.2, 1.3), (122.8, 1.1), (121.2, 1.2), (120.0, 0.9), (119.7, -0.2),
     (119.9, -1.0), (119.3, -1.7), (118.9, -2.8), (119.0, -3.6), (119.4, -5.1),
     (119.5, -5.6), (120.4, -5.6), (120.4, -4.5), (120.5, -3.4), (121.2, -3.1),
     (121.5, -4.2), (122.0, -5.2), (122.8, -4.9), (122.6, -4.0), (122.2, -3.0),
     (122.0, -2.0), (123.4, -1.1), (122.5, -0.8), (121.5, -0.9), (120.4, 0.0),
     (120.8, 0.4), (122.0, 0.4), (123.2, 0.5), (124.3, 0.9)],
    // Papua
    [(130.9, -0.9), (132.0, -0.5), (133.2, -0.5), (134.1, -0.8), (134.5, -1.5),
     (134.0, -2.6), (135.0, -3.4), (136.2, -2.4), (137.6, -1.8), (138.6, -1.7),
     (139.8, -2.3), (141.0, -2.6), (141.0, -9.1), (140.3, -8.5), (138.9, -8.3),
     (138.0, -8.2), (137.8, -7.0), (138.3, -6.0), (137.5, -5.2), (136.5, -4.4),
     (135.0, -4.4), (134.0, -3.8), (133.0, -4.0), (132.4, -3.2), (132.9, -2.6),
     (132.0, -2.2), (131.2, -1.8)],
    // Halmahera, Seram, Buru
    [(127.4, 2.0), (128.2, 1.5), (128.0, 0.7), (128.7, 0.5), (128.3, -0.5),
     (127.6, -0.3), (127.7, 0.4), (127.3, 1.0)],
    [(128.0, -3.0), (129.5, -2.8), (130.8, -3.3), (130.3, -3.5), (128.5, -3.6), (128.1, -3.3)],
    [(126.0, -3.2), (127.2, -3.1), (127.3, -3.8), (126.2, -3.7)],
    // Bali, Lombok, Sumbawa, Flores, Sumba, Timor
    [(114.7, -8.2), (115.1, -8.1), (115.7, -8.4), (115.5, -8.8), (114.9, -8.8), (114.7, -8.5)],
    [(115.9, -8.3), (116.7, -8.3), (116.6, -8.9), (116.0, -8.8)],
    [(116.9, -8.5), (117.8, -8.3), (119.0, -8.6), (118.8, -9.0), (117.5, -9.0), (116.9, -8.8)],
    [(119.8, -8.5), (121.0, -8.4), (122.5, -8.4), (123.0, -8.5), (122.0, -8.9),
     (120.5, -8.8), (119.8, -8.7)],
    [(119.2, -9.6), (120.5, -9.5), (120.9, -10.0), (119.7, -10.3), (119.1, -10.0)],
    [(123.5, -10.2), (124.2, -9.4), (125.2, -9.3), (126.2, -8.9), (127.0, -8.4),
     (127.0, -8.8), (125.6, -9.6), (124.5, -10.2), (123.8, -10.4)],
  ];
}

class IndoMapPainter extends CustomPainter {
  const IndoMapPainter();

  static const ocean = Color(0xFF07060B);
  static const land = Color(0xFF16141F);
  static const edge = Color(0xFF2E2B3B);

  void _addSmooth(Path path, List<Offset> p) {
    Offset mid(Offset a, Offset b) => Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final n = p.length;
    final start = mid(p[n - 1], p[0]);
    path.moveTo(start.dx, start.dy);
    for (var i = 0; i < n; i++) {
      final c = p[i];
      final m = mid(c, p[(i + 1) % n]);
      path.quadraticBezierTo(c.dx, c.dy, m.dx, m.dy);
    }
    path.close();
  }

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = ocean);

    // garis lintang dan bujur tipis
    final grid = Paint()
      ..color = const Color(0x12FFFFFF)
      ..strokeWidth = 1;
    for (var lon = 95; lon <= 140; lon += 5) {
      final x = IndoMap.project(lon.toDouble(), 0, s).dx;
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), grid);
    }
    for (final lat in const [5, 0, -5, -10]) {
      final y = IndoMap.project(100, lat.toDouble(), s).dy;
      canvas.drawLine(Offset(0, y), Offset(s.width, y), grid);
    }

    final path = Path();
    for (final isl in IndoMap.islands) {
      _addSmooth(path, [for (final q in isl) IndoMap.project(q.$1, q.$2, s)]);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = K.lilac.withOpacity(0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawPath(path, Paint()..color = land);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeJoin = StrokeJoin.round
        ..color = edge,
    );
  }

  @override
  bool shouldRepaint(covariant IndoMapPainter old) => false;
}
