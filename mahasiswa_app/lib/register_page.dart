import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.1.104:8080/register'),
        body: {
          'username': _username.text,
          'email': _email.text,
          'password': _password.text,
        },
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi berhasil')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      } else {
        final message = data['message'] is String
            ? data['message']
            : (data['message'] as Map).values.first;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal: $message')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(labelText: "Username"),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) =>
                  value!.contains('@') ? null : 'Format email tidak valid',
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Minimal 6 karakter' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text("Daftar")),
          ]),
        ),
      ),
    );
  }
}
