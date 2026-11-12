import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../indonesia_map.dart';
import '../theme.dart';
import '../widgets/univa_nav.dart';

// icon, warna, judul, subjudul, waktu
const _notifs = [
  (
    Icons.waving_hand_rounded,
    K.sun,
    'Citra Lestari menyapa kamu',
    'Lagi online dari Yogyakarta',
    '2 menit lalu',
  ),
  (
    Icons.local_fire_department_rounded,
    K.coral,
    'Jakarta lagi rame',
    '640 mahasiswa aktif, naik 18% dari kemarin',
    '15 menit lalu',
  ),
  (
    Icons.group_add_rounded,
    K.mint,
    'Reza Mahendra mau berteman',
    'Teknik Industri, Palembang',
    '1 jam lalu',
  ),
  (
    Icons.emoji_events_rounded,
    K.lilac,
    'Makassar masuk 3 besar kota teraktif',
    'Peringkat keaktifan minggu ini',
    '3 jam lalu',
  ),
  (
    Icons.pin_drop_rounded,
    Color(0xFF8FD3FF),
    'Teman dekatmu check-in',
    'Gita Maharani baru check-in di Denpasar',
    'Kemarin',
  ),
];

const _bg = Color(0xFF07060B);

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();
  final _tc = TransformationController();
  Size _canvas = Size.zero;
  bool _placed = false;

  String filter = 'semua';
  final Set<int> _unread = {0, 1, 2, 3, 4};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_placed) return;
    final s = MediaQuery.sizeOf(context);
    final cw = s.width * 3.0;
    final sc = cw * 0.92 / IndoMap.lonSpan;
    _canvas = Size(cw, math.max(IndoMap.latSpan * sc * 1.6, 900));

    // awal: fokus ke Jawa, Sumatra bagian selatan, dan Kalimantan
    const k = 0.9;
    final f = IndoMap.project(110, -3, _canvas);
    _tc.value =
        Matrix4.translationValues(
          s.width / 2 - k * f.dx,
          s.height / 2 - k * f.dy,
          0,
        ) *
        Matrix4.diagonal3Values(k, k, 1);
    _placed = true;
  }

  @override
  void dispose() {
    _c.dispose();
    _tc.dispose();
    super.dispose();
  }

  int get _total => zones.fold<int>(0, (s, z) => s + z.active);

  int _count(String key) => zones
      .where((z) => key == 'semua' || z.tag == key)
      .fold<int>(0, (s, z) => s + z.active);

  String _fmt(int n) => n.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => '.',
  );

  String _k(int n) => n >= 1000
      ? '${(n / 1000).toStringAsFixed(1).replaceAll('.', ',')}k'
      : '$n';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _tc,
              constrained: false,
              minScale: 0.35,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(120),
              child: SizedBox(
                width: _canvas.width,
                height: _canvas.height,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(painter: IndoMapPainter()),
                      ),
                    ),
                    for (final z in zones) _positioned(z),
                  ],
                ),
              ),
            ),
          ),
          _header(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: UnivaNav(
                current: 0,
                onTap: (i) {
                  if (i == 3) Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- header ----------

  Widget _header() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bg, _bg.withOpacity(0.9), _bg.withOpacity(0)],
            stops: const [0, 0.65, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_fmt(_total)} mahasiswa aktif',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Cubit dan geser peta buat jelajah Indonesia',
                              style: TextStyle(color: K.muted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _openNotifs,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                color: K.plum,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 24,
                              ),
                            ),
                            if (_unread.isNotEmpty)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: K.coral,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _bg, width: 2),
                                  ),
                                  child: Text(
                                    '${_unread.length}',
                                    style: const TextStyle(
                                      color: K.ink,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 20),
                    itemCount: filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _chip(i),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(int i) {
    final f = filters[i];
    final on = filter == f.$1;
    return GestureDetector(
      onTap: () => setState(() => filter = f.$1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: on ? K.text : K.plum,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(f.$3, size: 16, color: on ? K.ink : K.muted),
            const SizedBox(width: 6),
            Text(
              f.$2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: on ? K.ink : K.muted,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _k(_count(f.$1)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: on ? K.coral : K.muted.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- titik kampus di peta ----------

  Widget _positioned(Zone z) {
    final p = IndoMap.project(z.lon, z.lat, _canvas);
    return Positioned(left: p.dx - 48, top: p.dy - 34, child: _zoneBlob(z));
  }

  Widget _zoneBlob(Zone z) {
    final on = filter == 'semua' || filter == z.tag;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: on ? 1 : 0.15,
      child: GestureDetector(
        onTap: on ? () => _openZone(z) : null,
        child: SizedBox(
          width: 96,
          child: Column(
            children: [
              SizedBox(
                width: 68,
                height: 68,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) {
                    final p = _c.value;
                    return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Transform.scale(
                          scale: 0.7 + p * 0.5,
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: z.color.withOpacity((1 - p) * 0.6),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: z.color,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: z.color.withOpacity(0.45),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Icon(z.icon, size: 22, color: K.ink),
                        ),
                        Positioned(
                          right: -2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _bg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              _k(z.active),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _bg.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  z.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- notifikasi ----------

  void _openNotifs() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, sc) => Container(
            decoration: const BoxDecoration(
              color: K.plum,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _unread.isEmpty
                          ? null
                          : () {
                              setState(() => _unread.clear());
                              setSheet(() {});
                            },
                      child: const Text('Tandai semua dibaca'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < _notifs.length; i++)
                  _notifTile(i, setSheet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notifTile(int i, StateSetter setSheet) {
    final n = _notifs[i];
    final unread = _unread.contains(i);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        setState(() => _unread.remove(i));
        setSheet(() {});
      },
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: n.$2.withOpacity(0.18),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(n.$1, color: n.$2, size: 24),
      ),
      title: Text(
        n.$3,
        style: TextStyle(
          fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        n.$4,
        style: const TextStyle(color: K.muted, fontSize: 12),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(n.$5, style: const TextStyle(color: K.muted, fontSize: 11)),
          const SizedBox(height: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: unread ? K.coral : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- bottom sheet kampus ----------

  void _openZone(Zone z) {
    final messenger = ScaffoldMessenger.of(context);
    final ratio = (z.active / 700).clamp(0.0, 1.0);
    final label = ratio > 0.6 ? 'Ramai' : (ratio > 0.25 ? 'Lumayan' : 'Sepi');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, sc) => Container(
          decoration: const BoxDecoration(
            color: K.plum,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: sc,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: z.color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(z.icon, color: K.ink, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          z.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          z.vibe,
                          style: const TextStyle(color: K.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Text(
                    'Keramaian',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    label,
                    style: TextStyle(
                      color: z.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation(z.color),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${_fmt(z.active)} mahasiswa aktif sekarang',
                style: const TextStyle(color: K.muted, fontSize: 12),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: z.color,
                  foregroundColor: K.ink,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  messenger.showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Check-in di ${z.name} berhasil'),
                    ),
                  );
                },
                icon: const Icon(Icons.pin_drop_rounded),
                label: const Text(
                  'Check-in di sini',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Lagi online',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (z.people.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(Icons.explore_off_rounded, color: K.muted, size: 36),
                      SizedBox(height: 10),
                      Text(
                        'Belum ada yang bisa disapa di sini.\nCheck-in dulu biar kampusmu kelihatan di radar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: K.muted, height: 1.4),
                      ),
                    ],
                  ),
                ),
              for (final p in z.people)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: p.color,
                    child: Text(
                      p.name[0],
                      style: const TextStyle(
                        color: K.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    p.major,
                    style: const TextStyle(color: K.muted, fontSize: 12),
                  ),
                  trailing: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: _bg,
                      foregroundColor: z.color,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                    icon: const Icon(Icons.waving_hand_rounded, size: 16),
                    label: const Text('Sapa'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
