// lib/pencarian.dart

import 'package:flutter/material.dart';

// Nama class diubah menjadi Pencarian
class Pencarian extends StatelessWidget {
  const Pencarian({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search songs, artist...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.mic_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent searches',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _buatDaftarGambarHorizontal(),
          _buatDaftarRiwayatPencarian(),
        ],
      ),
    );
  }

  Widget _buatDaftarGambarHorizontal() {
    // UBAH BAGIAN INI: Hapus 'imageUrl' dari data
    final items = [
      {'title': 'Pilu Memb...'}, {'title': 'Lost'},
      {'title': 'Trouble'}, {'title': 'Nina...'},
      {'title': 'Des...'},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  Expanded(
                    // UBAH BAGIAN INI: Ganti gambar dengan ikon
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800, // Memberi warna latar
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    items[index]['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buatDaftarRiwayatPencarian() {
    final history = [
      'barasuara', 'midnight serenade', 'frank ocean trouble', 'frank ocean',
      'frank sinatra', 'nina', 'gusti irwan wibowo', 'pamungkas',
      'lagu timur', 'eskobar', 'ridwan sau', 'napa deslocado',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              const Icon(Icons.history, color: Colors.grey),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  history[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Icon(Icons.north_west, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}