import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double rx = 0, ry = 0;
  int tab = 0;

  static const stickers = [
    ('🏄 Surfing', K.mint, -0.06),
    ('🍜 Ramen', K.coral, 0.05),
    ('🎨 Digital Art', K.lilac, -0.03),
    ('🌙 Deep Talks Tengah Malam', K.sun, 0.04),
    ('📖 Buku', K.mint, 0.06),
    ('🧩 Puzzle', K.coral, -0.05),
    ('🎭 Teater Musikal', K.lilac, 0.03),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded)),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onPanUpdate: (d) => setState(() {
                ry = (ry + d.delta.dx * 0.01).clamp(-0.4, 0.4);
                rx = (rx - d.delta.dy * 0.01).clamp(-0.4, 0.4);
              }),
              onPanEnd: (_) => setState(() {
                rx = 0;
                ry = 0;
              }),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(rx)
                  ..rotateY(ry),
                child: _pass(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                  child: Text('geser kartunya',
                      style: TextStyle(color: K.muted, fontSize: 12))),
            ),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: K.coral,
                      foregroundColor: K.ink,
                      minimumSize: const Size.fromHeight(52),
                      textStyle: const TextStyle(fontWeight: FontWeight.w800)),
                  onPressed: () {},
                  child: const Text('Sapa 👋'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: K.text,
                      side: const BorderSide(color: Colors.white24),
                      minimumSize: const Size.fromHeight(52)),
                  onPressed: () {},
                  child: const Text('Kirim pesan'),
                ),
              ),
            ]),
            const SizedBox(height: 22),
            Row(children: [
              for (final (i, t) in ['Info', 'Post 13', 'Video'].indexed)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => tab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: tab == i ? K.text : K.plum,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: tab == i ? K.ink : K.muted)),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 22),
            if (tab == 0) ..._info() else _empty(),
          ],
        ),
      ),
    );
  }

  Widget _pass() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B57), Color(0xFFB8A4FF)],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('CAMPUS PASS',
              style: TextStyle(
                  color: K.ink, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: K.ink, borderRadius: BorderRadius.circular(14)),
            child: const Row(children: [
              Icon(Icons.circle, color: K.mint, size: 8),
              SizedBox(width: 6),
              Text('di Perpustakaan', style: TextStyle(fontSize: 11)),
            ]),
          ),
        ]),
        const SizedBox(height: 22),
        Row(children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: K.ink,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(me.name[0],
                style: const TextStyle(
                    fontSize: 40, fontWeight: FontWeight.w900, color: K.sun)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(me.name,
                      style: const TextStyle(
                          fontSize: 22,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: K.ink)),
                  const SizedBox(height: 4),
                  Text(me.handle,
                      style: const TextStyle(
                          color: K.ink, fontWeight: FontWeight.w600)),
                ]),
          ),
        ]),
        const SizedBox(height: 22),
        const Row(children: [
          _Stat('42', 'Teman'),
          _Stat('10', 'Klub'),
          _Stat('7', 'Spot'),
        ]),
      ]),
    );
  }

  List<Widget> _info() => [
        Text(me.major,
            style: const TextStyle(
                color: K.sun, fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 14),
        const Text(
          'Kayaknya lagi nyoret-nyoret di kelas daripada nyatet. Mimpi bikin brand streetwear, tapi sekarang cukup ditemenin iPad dan matcha latte.',
          style: TextStyle(color: K.muted, height: 1.5, fontSize: 15),
        ),
        const SizedBox(height: 24),
        const Text('Bisa diajak ngobrol soal',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [
            for (final s in stickers)
              Transform.rotate(
                angle: s.$3,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                      color: s.$2, borderRadius: BorderRadius.circular(14)),
                  child: Text(s.$1,
                      style: const TextStyle(
                          color: K.ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                ),
              ),
          ],
        ),
      ];

  Widget _empty() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
            child: Text('Belum ada konten di sini',
                style: TextStyle(color: K.muted))),
      );
}

class _Stat extends StatelessWidget {
  final String n, label;
  const _Stat(this.n, this.label);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(n,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w900, color: K.ink)),
          Text(label,
              style: const TextStyle(
                  color: K.ink, fontWeight: FontWeight.w600, fontSize: 12)),
        ]),
      );
}
