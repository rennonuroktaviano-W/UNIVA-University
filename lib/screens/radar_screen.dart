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
      barrierColor: Colors.black.withOpacity(0.68),
      builder: (_) => StatefulBuilder(
        builder: (sheetContext, setSheet) {
          final visible = List<int>.generate(_notifs.length, (i) => i)
              .where((i) {
            if (filter == 'belum') return _unread.contains(i);
            if (filter == 'sosial') return [0, 2, 4].contains(i);
            if (filter == 'aktivitas') return [1, 3].contains(i);
            return true;
          }).toList();

          return DraggableScrollableSheet(
            initialChildSize: 0.82,
            minChildSize: 0.55,
            maxChildSize: 0.96,
            expand: false,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: K.plum,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 11),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 18, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Notifikasi',
                                style: TextStyle(
                                  color: K.text,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.7,
                                ),
                              ),
                            ),
                            if (_unread.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: K.coral.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  '${_unread.length} baru',
                                  style: const TextStyle(
                                    color: K.coral,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Tutup',
                              onPressed: () => Navigator.pop(sheetContext),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: K.muted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Semua kabar terbaru dari komunitasmu.',
                          style: TextStyle(color: K.muted, fontSize: 13),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _notifFilter('semua', 'Semua', setSheet),
                                    _notifFilter(
                                      'belum',
                                      'Belum dibaca',
                                      setSheet,
                                    ),
                                    _notifFilter(
                                      'sosial',
                                      'Sosial',
                                      setSheet,
                                    ),
                                    _notifFilter(
                                      'aktivitas',
                                      'Aktivitas',
                                      setSheet,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_unread.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(() => _unread.clear());
                                  setSheet(() {});
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  foregroundColor: K.coral,
                                ),
                                child: const Text(
                                  'Baca semua',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: visible.isEmpty
                        ? _notifEmpty()
                        : ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(20, 2, 20, 30),
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(2, 8, 0, 12),
                                child: Text(
                                  'TERBARU',
                                  style: TextStyle(
                                    color: K.muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              for (final i in visible) _notifTile(i, setSheet),
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  'Kamu sudah sampai di akhir notifikasi',
                                  style: TextStyle(
                                    color: K.muted.withOpacity(0.7),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _notifFilter(String value, String label, StateSetter setSheet) {
    final selected = filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => setSheet(() => filter = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? K.coral : Colors.white.withOpacity(0.045),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected ? K.coral : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : K.muted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _notifEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                color: K.muted,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Belum ada notifikasi',
              style: TextStyle(
                color: K.text,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Notifikasi baru akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: K.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notifTile(int i, StateSetter setSheet) {
    final n = _notifs[i];
    final unread = _unread.contains(i);
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: unread
            ? Colors.white.withOpacity(0.075)
            : Colors.white.withOpacity(0.025),
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: () {
            setState(() => _unread.remove(i));
            setSheet(() {});
            _openNotifDetail(i);
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(
                color: unread
                    ? K.coral.withOpacity(0.22)
                    : Colors.white.withOpacity(0.045),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: n.$2.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(n.$1, color: n.$2, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.$3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: K.text,
                                fontSize: 13,
                                height: 1.3,
                                fontWeight:
                                    unread ? FontWeight.w900 : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (unread) ...[
                            const SizedBox(width: 7),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: K.coral,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        n.$4,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: K.muted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        n.$5,
                        style: TextStyle(
                          color: unread ? K.coral : K.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: K.muted,
                    size: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _notifMessage(int i) {
    switch (i) {
      case 0:
        return 'Citra Lestari sedang aktif di Yogyakarta dan menyapamu. '
            'Mungkin ini kesempatan yang pas untuk memulai obrolan dan '
            'mengenal teman baru dari kampus lain.';
      case 1:
        return 'Jakarta sedang menjadi salah satu titik paling ramai di '
            'UNIVA. Ada 640 mahasiswa yang aktif, meningkat 18% dibandingkan '
            'kemarin. Yuk, lihat apa yang sedang ramai dibicarakan.';
      case 2:
        return 'Reza Mahendra ingin terhubung denganmu. Ia berasal dari '
            'jurusan Teknik Industri di Palembang. Buka profilnya untuk '
            'mengenal lebih jauh sebelum menerima permintaan pertemanan.';
      case 3:
        return 'Makassar berhasil masuk tiga besar kota dengan aktivitas '
            'mahasiswa tertinggi minggu ini. Terima kasih sudah ikut '
            'membuat komunitas UNIVA semakin hidup.';
      default:
        return 'Gita Maharani baru saja check-in di Denpasar. Lihat lokasi '
            'dan aktivitas terbaru temanmu untuk menemukan tempat menarik '
            'di sekitar komunitas.';
    }
  }

  String _notifCategory(int i) {
    if (i == 0 || i == 2) return 'SOSIAL';
    if (i == 4) return 'LOKASI';
    return 'AKTIVITAS KOMUNITAS';
  }

  void _openNotifDetail(int i) {
    final n = _notifs[i];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.72),
      builder: (detailContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(detailContext).height * 0.84,
        ),
        decoration: const BoxDecoration(
          color: K.plum,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 13, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 27),
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: n.$2.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Icon(n.$1, color: n.$2, size: 28),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: K.mint.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: K.mint,
                            size: 13,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Sudah dibaca',
                            style: TextStyle(
                              color: K.mint,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                Text(
                  _notifCategory(i),
                  style: const TextStyle(
                    color: K.coral,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.7,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  n.$3,
                  style: const TextStyle(
                    color: K.text,
                    fontSize: 23,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: K.muted,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      n.$5,
                      style: const TextStyle(color: K.muted, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.045),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Text(
                    _notifMessage(i),
                    style: const TextStyle(
                      color: K.text,
                      fontSize: 14,
                      height: 1.75,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(detailContext),
                    style: FilledButton.styleFrom(
                      backgroundColor: K.coral,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Mengerti',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
