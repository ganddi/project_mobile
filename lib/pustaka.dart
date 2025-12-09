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
    print("--- MULAI REFRESH DATA ---");
    try {
      // 1. Ambil data
      final dataFromDB = await DatabaseHelper().getPlaylists();
      print(
        "Data mentah dari DB: $dataFromDB",
      ); // Cek apakah list-nya kosong [] atau ada isinya

      // 2. Konversi
      List<Map<String, dynamic>> convertedDBData = dataFromDB.map((e) {
        return {
          'id': e['id'], // <--- PENTING: Ambil ID dari database
          'type': 'playlist',
          'image': 'https://misc.scdn.co/liked-songs/liked-songs-300.png',
          'title': e['title'],
          'subtitle': 'Playlist • ${e['subtitle']}',
          'isUserCreated': true, // Penanda kalau ini bisa dihapus
        };
      }).toList();

      print("Data setelah dikonversi: ${convertedDBData.length} item");

      // 3. Update UI
      if (mounted) {
        setState(() {
          // Kita taruh data DB di PALING ATAS (index 0) supaya terlihat jelas
          _libraryItems = [...convertedDBData, ..._defaultItems];
        });
        print("--- UI BERHASIL DI-UPDATE ---");
      }
    } catch (e) {
      print("--- ERROR FATAL SAAT REFRESH: $e ---");
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
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ), // Biar fokus juga hijau
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
                print("Tombol Create Ditekan!"); // 1. Cek tombol

                if (titleController.text.isNotEmpty) {
                  print("Input Text: ${titleController.text}"); // 2. Cek input

                  // Simpan ke Database
                  await DatabaseHelper().insertPlaylist({
                    'title': titleController.text,
                    'subtitle': 'User Playlist',
                  });

                  print(
                    "Proses Insert Selesai, Refreshing UI...",
                  ); // 3. Cek insert

                  // Refresh tampilan
                  _refreshData();

                  if (mounted) Navigator.pop(context);
                } else {
                  print("Text Kosong, tidak menyimpan.");
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
          // _buildRecentsHeader(),
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

                    // TAMBAHKAN DUA BARIS INI:
                    isUserCreated: item['isUserCreated'] ?? false,
                    id: item['id'],
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

void _showRenameDialog(int id, String currentTitle) {
      final titleController = TextEditingController(
        text: currentTitle,
      ); // Isi nama lama

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Rename Playlist',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'New playlist name',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
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
                    // Panggil fungsi Update di Database
                    await DatabaseHelper().updatePlaylist(
                      id,
                      titleController.text,
                    );

                    // Refresh UI
                    _refreshData();

                    if (mounted) Navigator.pop(context); // Tutup dialog

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Playlist renamed!')),
                    );
                  }
                },
                child: const Text(
                  'Save',
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

  Widget _buildPlaylistItem({
    required String title,
    required String subtitle,
    required String imageUrl,
    bool pinned = false,
    bool isUserCreated =
        false, // Parameter baru untuk cek apakah ini buatan user
    int? id, // Parameter baru untuk ID
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Gambar
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
          // Teks Judul & Subtitle
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
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- BAGIAN INI YANG DIUBAH (TITIK TIGA JADI MENU) ---
         if (isUserCreated)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (id != null) {
                  if (value == 'rename') {
                    // Panggil fungsi Rename
                    _showRenameDialog(id, title);
                  } else if (value == 'delete') {
                    // Panggil fungsi Delete
                    _deletePlaylist(id, title);
                  }
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                // MENU 1: RENAME (DI ATAS)
                const PopupMenuItem<String>(
                  value: 'rename',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Rename', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                // MENU 2: DELETE (DI BAWAH)
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red), // Merah biar kontras
                      SizedBox(width: 8),
                      Text('Delete playlist', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            )
          else
            const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }

  void _deletePlaylist(int id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Playlist?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "$title"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Batal
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              // Hapus dari DB
              await DatabaseHelper().deletePlaylist(id);
              // Tutup dialog
              if (mounted) Navigator.pop(context);
              // Refresh UI
              _refreshData();

              // Tampilkan pesan sukses
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Deleted "$title"')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    
  }
}
