import 'package:flutter/material.dart';
import 'theme.dart';

class Person {
  final String name, handle, major;
  final Color color;
  const Person(this.name, this.handle, this.major, this.color);
}

class Zone {
  final String name, vibe, tag;
  final IconData icon;
  final double lon, lat;
  final int active; // jumlah mahasiswa aktif
  final Color color;
  final List<Person> people; // sampel yang bisa disapa
  const Zone({
    required this.name,
    required this.tag,
    required this.vibe,
    required this.icon,
    required this.lon,
    required this.lat,
    required this.active,
    required this.color,
    required this.people,
  });
}

// key, label, icon
const filters = [
  ('semua', 'Semua', Icons.apps_rounded),
  ('sumatra', 'Sumatra', Icons.landscape_rounded),
  ('jawa', 'Jawa', Icons.location_city_rounded),
  ('kalimantan', 'Kalimantan', Icons.forest_rounded),
  ('sulawesi', 'Sulawesi', Icons.sailing_rounded),
  ('nusa', 'Bali & Nusa Tenggara', Icons.beach_access_rounded),
  ('timur', 'Maluku & Papua', Icons.terrain_rounded),
];

const _aulia = Person('Aulia Rahma', '@aulia.r', 'Desain Komunikasi Visual, 2022', Color(0xFFFF6B57));
const _bima = Person('Bima Pratama', '@bimap', 'Informatika, 2021', Color(0xFFFFC857));
const _citra = Person('Citra Lestari', '@citra.l', 'Sastra Inggris, 2023', Color(0xFF5EEAD4));
const _dimas = Person('Dimas Arya', '@dimasarya', 'Teknik Sipil, 2022', Color(0xFFB8A4FF));
const _eka = Person('Eka Putri', '@ekaputri', 'Psikologi, 2023', Color(0xFFFF8FB1));
const _fajar = Person('Fajar Nugroho', '@fajarn', 'Manajemen, 2021', Color(0xFF8FD3FF));
const _gita = Person('Gita Maharani', '@gitamhr', 'Arsitektur, 2022', Color(0xFFFFB36B));
const _hafiz = Person('Hafiz Ramadhan', '@hafizr', 'Ilmu Komunikasi, 2023', Color(0xFF5EEAD4));
const _intan = Person('Intan Permata', '@intanp', 'Akuntansi, 2021', Color(0xFFB8A4FF));
const _jovan = Person('Jovan Wijaya', '@jovanw', 'Teknik Elektro, 2022', Color(0xFFFFC857));
const _kirana = Person('Kirana Dewi', '@kiranadw', 'Hukum, 2023', Color(0xFFFF8FB1));
const _laksmana = Person('Laksmana Adi', '@laksa.adi', 'Sistem Informasi, 2021', Color(0xFF8FD3FF));
const _maya = Person('Maya Safira', '@mayasf', 'Farmasi, 2022', Color(0xFFFF6B57));
const _naufal = Person('Naufal Hakim', '@naufalhk', 'Teknik Mesin, 2023', Color(0xFF5EEAD4));
const _qonita = Person('Qonita Azzahra', '@qonita.az', 'Pendidikan Biologi, 2022', Color(0xFFB8A4FF));
const _reza = Person('Reza Mahendra', '@rezamhd', 'Teknik Industri, 2021', Color(0xFFFFC857));
const _salsa = Person('Salsabila Nur', '@salsanr', 'Kedokteran, 2023', Color(0xFFFF8FB1));
const _tegar = Person('Tegar Saputra', '@tegarsp', 'Ilmu Politik, 2022', Color(0xFF8FD3FF));

const _blue = Color(0xFF8FD3FF);
const _pink = Color(0xFFFF8FB1);
const _orange = Color(0xFFFFB36B);

const zones = [
  Zone(name: 'Banda Aceh', tag: 'sumatra', icon: Icons.history_edu_rounded,
      vibe: 'Kampus ujung barat, kuat di kajian dan riset kebencanaan',
      lon: 95.32, lat: 5.55, active: 86, color: K.lilac, people: [_qonita]),
  Zone(name: 'Medan', tag: 'sumatra', icon: Icons.local_library_rounded,
      vibe: 'Kota pelajar terbesar di Sumatra, komunitas debat dan musiknya aktif',
      lon: 98.67, lat: 3.59, active: 214, color: K.coral, people: [_tegar]),
  Zone(name: 'Padang', tag: 'sumatra', icon: Icons.forest_rounded,
      vibe: 'Kampus di kaki bukit, terkenal kreatif dan jago kuliner',
      lon: 100.35, lat: -0.95, active: 132, color: K.mint, people: [_kirana]),
  Zone(name: 'Palembang', tag: 'sumatra', icon: Icons.account_balance_rounded,
      vibe: 'Kampus tepi Sungai Musi, sering ada event budaya',
      lon: 104.75, lat: -2.98, active: 118, color: K.sun, people: [_reza]),
  Zone(name: 'Jakarta', tag: 'jawa', icon: Icons.public_rounded,
      vibe: 'Pusat startup, magang, dan komunitas lintas kampus',
      lon: 106.85, lat: -6.2, active: 640, color: _pink, people: [_aulia, _bima]),
  Zone(name: 'Yogyakarta', tag: 'jawa', icon: Icons.menu_book_rounded,
      vibe: 'Kota pelajar, diskusi dan pameran seni hampir tiap malam',
      lon: 110.37, lat: -7.8, active: 420, color: K.lilac, people: [_citra, _eka]),
  Zone(name: 'Surabaya', tag: 'jawa', icon: Icons.engineering_rounded,
      vibe: 'Kampus teknik dan bisnis, banyak hackathon',
      lon: 112.75, lat: -7.25, active: 310, color: K.coral, people: [_jovan, _naufal]),
  Zone(name: 'Denpasar', tag: 'nusa', icon: Icons.beach_access_rounded,
      vibe: 'Pariwisata, desain, dan kolaborasi kreatif',
      lon: 115.22, lat: -8.65, active: 150, color: _orange, people: [_gita]),
  Zone(name: 'Kupang', tag: 'nusa', icon: Icons.terrain_rounded,
      vibe: 'Kampus di timur Nusa Tenggara, komunitas lingkungan dan budaya lokal',
      lon: 123.6, lat: -10.17, active: 64, color: K.mint, people: [_dimas]),
  Zone(name: 'Pontianak', tag: 'kalimantan', icon: Icons.park_rounded,
      vibe: 'Kota khatulistiwa, kampus riset hutan dan sungai',
      lon: 109.33, lat: -0.03, active: 98, color: K.mint, people: [_maya]),
  Zone(name: 'Banjarmasin', tag: 'kalimantan', icon: Icons.sailing_rounded,
      vibe: 'Kampus kota seribu sungai, fokus perikanan dan lahan basah',
      lon: 114.59, lat: -3.32, active: 88, color: _blue, people: [_intan]),
  Zone(name: 'Balikpapan', tag: 'kalimantan', icon: Icons.science_rounded,
      vibe: 'Dekat IKN, banyak mahasiswa energi dan tata kota',
      lon: 116.83, lat: -1.27, active: 110, color: K.sun, people: [_laksmana]),
  Zone(name: 'Makassar', tag: 'sulawesi', icon: Icons.computer_rounded,
      vibe: 'Pusat kampus Indonesia timur, komunitas teknologi dan olahraga',
      lon: 119.41, lat: -5.15, active: 260, color: _pink, people: [_fajar, _salsa]),
  Zone(name: 'Manado', tag: 'sulawesi', icon: Icons.waves_rounded,
      vibe: 'Kampus laut dan pariwisata, scene musik dan paduan suara',
      lon: 124.84, lat: 1.49, active: 92, color: K.coral, people: [_hafiz]),
  Zone(name: 'Ambon', tag: 'timur', icon: Icons.school_rounded,
      vibe: 'Kampus kepulauan Maluku, mahasiswa kelautan dan musik',
      lon: 128.19, lat: -3.7, active: 54, color: K.lilac, people: []),
  Zone(name: 'Jayapura', tag: 'timur', icon: Icons.agriculture_rounded,
      vibe: 'Gerbang timur Indonesia, mahasiswa dari seluruh Papua berkumpul',
      lon: 140.7, lat: -2.53, active: 72, color: K.mint, people: []),
];

const me = Person('Elizabeth Bennet', '@liz.bennet', 'Fakultas Desain, 2022', K.coral);
