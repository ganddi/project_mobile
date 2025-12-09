// lib/main.dart

import 'package:flutter/material.dart';
import 'package:project_uas/beranda.dart';
import 'package:project_uas/pencarian.dart';
import 'package:project_uas/pustaka.dart'; // Pastikan file beranda.dart ada

void main() {
  runApp(const AplikasiMusik());
}

class AplikasiMusik extends StatelessWidget {
  const AplikasiMusik({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Music Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      // Home sekarang akan mengarah ke widget baru yang punya state
      home: const KerangkaUtama(),
    );
  }
}

// Ini adalah widget utama yang baru, kita ubah menjadi StatefulWidget
class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  // 1. Variabel State untuk melacak tab yang aktif
  int _indeksHalaman = 0;

  // 2. Daftar halaman/widget yang akan ditampilkan sesuai tab
  static const List<Widget> _daftarHalaman = <Widget>[
    HalamanBeranda(), // Halaman dari file beranda.dart
    Pencarian(),
    Pustaka(),
  ];

  // 3. Fungsi untuk mengubah state saat tab ditekan
  void _onItemTapped(int index) {
    setState(() {
      _indeksHalaman = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold sekarang ada di sini, bukan di HalamanBeranda lagi
    return Scaffold(
      // Body akan berubah sesuai tab yang dipilih
      body: _daftarHalaman.elementAt(_indeksHalaman),

      // 4. Di sinilah kita menambahkan BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        // Daftar item/tombol di navbar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ikon saat aktif
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
        currentIndex: _indeksHalaman, // Mengatur item mana yang sedang aktif
        onTap: _onItemTapped, // Memanggil fungsi saat item ditekan
        // Pengaturan Tampilan
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed, // Agar semua label terlihat
        selectedItemColor: Colors.white, // Warna item yang aktif
        unselectedItemColor: Colors.grey, // Warna item yang tidak aktif
        showUnselectedLabels: true, // Tampilkan label meski tidak aktif
      ),
    );
  }
}
