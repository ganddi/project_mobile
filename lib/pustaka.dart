import 'package:flutter/material.dart';
import 'package:project_uas/db_helper.dart'; // Pastikan import ini ada
import 'package:project_uas/auth_service.dart'; // Import Auth Service
import 'package:project_uas/login_page.dart'; // Import Halaman Login

// NAMA CLASS BERUBAH JADI Pustaka
class Pustaka extends StatefulWidget {
  const Pustaka({super.key});

  @override
  State<Pustaka> createState() => _PustakaState();
}

class _PustakaState extends State<Pustaka> {
  // List utama
  List<Map<String, dynamic>> _libraryItems = [];

  // Data Bawaan (Hardcoded)
  final List<Map<String, dynamic>> _defaultItems = [
    {
      'type': 'playlist',
      'image':
          'https://i.scdn.co/image/ab67706c0000da8418f9a2e30c45b5971b87d377',
      'title': 'Liked Songs',
      'subtitle': 'Playlist • 40 songs',
      'pinned': true,
    },
    {
      'type': 'artist',
      'image':
          'https://i.scdn.co/image/ab67616100005174df3b6751b430485988ff6e61',
      'name': 'Sal Priadi',
    },
    {
      'type': 'artist',
      'image':
          'https://i.scdn.co/image/ab676161000051740c03d7f3c65c5c83ac12d1b8',
      'name': 'The Panturas',
    },
  ];

  @override
  void initState() {
    super.initState();
    _libraryItems = List.from(_defaultItems); // Isi awal agar tidak kosong
    _refreshData();
  }

  // Fungsi ambil data dari Database
  void _refreshData() async {
    try {
      final dataFromDB = await DatabaseHelper().getPlaylists();

      List<Map<String, dynamic>> convertedDBData = dataFromDB.map((e) {
        return {
          'type': 'playlist',
          'image': 'https://misc.scdn.co/liked-songs/liked-songs-300.png',
          'title': e['title'],
          'subtitle': 'Playlist • ${e['subtitle']}',
          'isUserCreated': true,
        };
      }).toList();

      if (mounted) {
        setState(() {
          // Gabungkan Data Statis + Data Database
          _libraryItems = [..._defaultItems, ...convertedDBData];
        });
      }
    } catch (e) {
      print("Error ambil data: $e");
    }
  }

  // Dialog Tambah Playlist
  void _showAddPlaylistDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Create Playlist',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Playlist name',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  // Simpan ke Database
                  await DatabaseHelper().insertPlaylist({
                    'title': titleController.text,
                    'subtitle': 'User Playlist',
                  });
                  _refreshData(); // Refresh tampilan
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            // HAPUS 'const' DI SINI (Penting!)

            // --- BAGIAN INI KITA UBAH JADI POPUP MENU ---
            PopupMenuButton<String>(
              offset: const Offset(0, 50), // Supaya menu muncul di bawah avatar
              tooltip: 'Profile Menu',
              onSelected: (value) async {
                if (value == 'logout') {
                  // 1. Panggil fungsi logout
                  await AuthService().logout();

                  // 2. Pindah ke halaman Login & hapus history
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                }
              },
              // Tampilan Pemicu (Foto Profil)
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
                radius: 20,
              ),
              // Isi Menu
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.white), // Ikon Logout
                      SizedBox(width: 8),
                      Text('Log out', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),

            // ----------------------------------------------
            const SizedBox(width: 12),
            const Text(
              'Your Library',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPlaylistDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          const SizedBox(height: 12),
          _buildRecentsHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _libraryItems.length,
              itemBuilder: (context, index) {
                final item = _libraryItems[index];

                if (item['type'] == 'playlist') {
                  return _buildPlaylistItem(
                    imageUrl: item['image'] ?? '',
                    title: item['title'] ?? 'No Title',
                    subtitle: item['subtitle'] ?? '',
                    pinned: item['pinned'] ?? false,
                  );
                } else {
                  return _buildArtistItem(
                    imageUrl: item['image'] ?? '',
                    name: item['name'] ?? 'Unknown',
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPlaylistDialog,
        label: const Text('New'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
    );
  }

  // --- WIDGET HELPER (Tetap sama) ---

  Widget _buildFilterChips() {
    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: [
          _buildChip('Playlists', isSelected: true),
          _buildChip('Artists'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF333333) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white54),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: const [
          Icon(Icons.swap_vert, size: 20),
          SizedBox(width: 8),
          Text('Recents', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem({
    required String imageUrl,
    required String title,
    required String subtitle,
    bool pinned = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (pinned)
                      Transform.rotate(
                        angle: -45 * (3.1415926535 / 180),
                        child: const Icon(
                          Icons.push_pin,
                          size: 16,
                          color: Colors.green,
                        ),
                      ),
                    if (pinned) const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistItem({required String imageUrl, required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Artist',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
