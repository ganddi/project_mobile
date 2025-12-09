// lib/beranda.dart

import 'package:flutter/material.dart';
import 'pencarian.dart';

// Nama class diubah ke Bahasa Indonesia
class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pencarian()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buatFilterKategori(),
                const SizedBox(height: 24),
                _buatJudulBagian("Quick picks", "Play all"),
                const SizedBox(height: 16),
                _buatDaftarQuickpicks(),
                const SizedBox(height: 24),
                const Text(
                  "gandi",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Text(
                  "Speed Dial",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buatGridSpeeddial(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatFilterKategori() {
    final chips = ['Podcast', 'Relax', 'Commute', 'Romance', 'Energy'];
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade700),
            ),
            alignment: Alignment.center,
            child: Text(chips[index]),
          );
        },
      ),
    );
  }

  Widget _buatJudulBagian(String judul, String teksAksi) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          judul,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.grey.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(teksAksi),
        ),
      ],
    );
  }

  // Nama fungsi diubah
  Widget _buatDaftarQuickpicks() {
    final songs = [
      {'title': 'Arteri', 'artist': '.Feast', 'plays': '85M plays'},
      {'title': 'Deslocado', 'artist': 'NAPA', 'plays': '35M plays'},
      {'title': 'Love', 'artist': 'Keyshia Cole', 'plays': '619M plays'},
    ];

    return Column(
      children: songs.map((song) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // UBAH BAGIAN INI: Ganti gambar dengan ikon
              Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade800, // Memberi warna latar
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song['title']!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${song['artist']!} • ${song['plays']!}",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Nama fungsi diubah
  Widget _buatGridSpeeddial() {
    final albums = [
      {'title': 'Laut'},
      {'title': 'Sampai Jumpa'},
      {'title': 'Diculik Cinta'},
      {'title': 'Pertama'},
      {'title': 'mejikubiniu'},
      {'title': 'Pamungkas'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // UBAH BAGIAN INI: Ganti gambar dengan ikon
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.shade800, // Memberi warna latar
                ),
                child: const Center(
                  child: Icon(Icons.music_note, color: Colors.white, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              album['title']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}
