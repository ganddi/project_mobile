import 'package:flutter/material.dart';
import 'package:project_uas/beranda.dart';
import 'package:project_uas/pencarian.dart';
import 'package:project_uas/pustaka.dart';
import 'package:project_uas/login_page.dart';
import 'package:project_uas/auth_service.dart';
import 'dart:io'; // Untuk cek Platform (Windows/Android)
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Untuk database Windows

void main() {
  // --- TAMBAHKAN KODE INI ---
  // Cek jika aplikasi berjalan di Desktop (Windows/Linux/Mac)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Inisialisasi database ffi
    sqfliteFfiInit();
    // Set database factory ke versi ffi
    databaseFactory = databaseFactoryFfi;
  }
  // ---------------------------

  runApp(const AplikasiMusik());
}

class AplikasiMusik extends StatelessWidget {
  const AplikasiMusik({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.green,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      themeMode: ThemeMode.dark,
      // Ubah home menjadi SplashScreen untuk cek login
      home: const SplashScreen(),
    );
  }
}

// Widget Baru: SplashScreen untuk mengecek status login
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.green)),
    );
  }
}

// Rename AplikasiMusikState yang lama menjadi MainPage agar bisa dipanggil setelah login
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HalamanBeranda(),
    Pencarian(),
    Pustaka(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Tambahkan fungsi logout (opsional, bisa ditaruh di tombol profile)
  // void _logout() async {
  //   final authService = AuthService();
  //   await authService.logout();
  //   if (mounted) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginPage()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Your Library',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
