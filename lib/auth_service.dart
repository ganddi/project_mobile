import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // GANTI IP INI SESUAI IPV4 LAPTOP KAMU YANG DIDAPAT DARI CMD
  // Jangan pakai 'localhost'. Jika pakai Emulator Android Studio bisa coba '10.0.2.2'
  // Tapi paling aman pakai IP laptop asli (misal 192.168.1.10)
  final String baseUrl = 'http://192.168.1.122/spotify_api'; 

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login.php'); // Arahkan ke file php
    
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      // Debugging: Lihat apa balasan dari server
      print('Response Login: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Cek status dari JSON PHP kita
        if (data['status'] == 'success') {
          String token = data['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error Login: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/register.php'); // Arahkan ke file php

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Response Register: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Cek status dari JSON PHP kita
        if (data['status'] == 'success') {
          String token = data['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error Register: $e');
      return false;
    }
  }

  // ... (Sisa fungsi logout dan isLoggedIn TETAP SAMA) ...
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}