// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_uas/main.dart'; // Pastikan path ini benar

void main() {
  // Kita beri nama test yang sesuai dengan apa yang kita uji
  testWidgets('Test Tampilan Halaman Beranda Youtube Music', (
    WidgetTester tester,
  ) async {
    // 1. Bangun aplikasi kita
    await tester.pumpWidget(const AplikasiMusik());

    // 2. Verifikasi bahwa widget-widget penting muncul di layar.
    // Kita tidak lagi mencari '0' atau '1'.

    // Cek apakah ada judul "Music" di AppBar
    expect(find.text('Music'), findsOneWidget);

    // Cek apakah ada ikon pencarian
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Cek apakah ada judul bagian "Pilihan cepat"
    expect(find.text('Pilihan cepat'), findsOneWidget);

    // Cek apakah salah satu kategori filter muncul
    expect(find.text('Podcast'), findsOneWidget);

    // Cek apakah salah satu judul lagu muncul
    expect(find.text('IRIS OUT'), findsOneWidget);
  });
}
