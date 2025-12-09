// lib/Pustaka.dart

import 'package:flutter/material.dart';

class Pustaka extends StatelessWidget {
  const Pustaka({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.thumb_up,
        'title': 'Liked Music',
        'subtitle': 'Auto playlist',
        'isCircle': false,
      },
      {
        'icon': Icons.podcasts,
        'title': 'New Episodes',
        'subtitle': 'Auto playlist • 10 episodes',
        'isCircle': false,
      },
      {
        'icon': Icons.person,
        'title': 'Nusantara Beat',
        'subtitle': 'Artist • 4.64K subscribers',
        'isCircle': false,
      },
      {
        'icon': Icons.library_music,
        'title': 'Editing',
        'subtitle': 'Playlist • ganddi • 41 tracks',
        'isCircle': false,
      },
      {
        'icon': Icons.person,
        'title': 'Halsey',
        'subtitle': 'Artist • 12.4M subscribers',
        'isCircle': true,
      },
      {
        'icon': Icons.person,
        'title': 'Jack Stauber',
        'subtitle': 'Artist • 3.49M subscribers',
        'isCircle': true,
      },
      {
        'icon': Icons.mic,
        'title': 'Second Date Updates',
        'subtitle': 'Podcast • Brooke and Jeffrey',
        'isCircle': false,
      },
      {
        'icon': Icons.person,
        'title': 'Sandhy Sondoro',
        'subtitle': 'Artist • 51.4K subscribers',
        'isCircle': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              'Library',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          // --- UBAH BAGIAN INI: Ganti CircleAvatar dengan Icon ---
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.account_circle_outlined, // Menggunakan ikon profile alter
              size: 32, // Sesuaikan ukuran agar terlihat bagus
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buatItemPustaka(items[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('New'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buatItemPustaka(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: item['isCircle'] ? BoxShape.circle : BoxShape.rectangle,
              color: item['imageUrl'] == null ? Colors.grey.shade800 : null,
              image: item['imageUrl'] != null
                  ? DecorationImage(
                      image: NetworkImage(item['imageUrl']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item['icon'] != null ? Icon(item['icon'], size: 30) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (item['subtitle'].contains('Auto playlist'))
                      const Icon(Icons.star, color: Colors.grey, size: 14),
                    if (item['subtitle'].contains('Auto playlist'))
                      const SizedBox(width: 4),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
