import 'package:flutter/material.dart';
import 'login_page.dart';
import 'session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username = "";

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = await SessionManager.getSession();
    setState(() {
      username = session;
    });
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Mahasiswa"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          )
        ],
      ),
      body: Center(
        child: Text(
          'Selamat datang, $username!',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
