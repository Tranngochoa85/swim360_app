import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:swim360_app/screens/coach_profile_screen.dart'; // Đã dùng lại

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final url = Uri.parse('http://10.0.2.2:8000/auth/login');

    // Lưu lại context một cách an toàn trước khi gọi await
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        // final token = responseData['access_token'];
        // Tạm thời chưa dùng token

        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const CoachProfileScreen()),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại.')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối. Không thể kết nối đến server.')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
    // ... (Phần UI giữ nguyên, không cần thay đổi)
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.pool, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text('SWIM360', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Học và luyện tập dễ dàng hơn bao giờ', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined)),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline)),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                  child: const Text('ĐĂNG NHẬP'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Bạn chưa có tài khoản?"),
                    TextButton(onPressed: () {}, child: const Text('Đăng ký')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}