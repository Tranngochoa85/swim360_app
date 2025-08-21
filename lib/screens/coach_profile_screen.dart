import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Đổi tên hằng số theo quy tắc lowerCamelCase
const String fakeCoachToken = "YOUR_COACH_ACCESS_TOKEN";

class CoachProfileScreen extends StatefulWidget {
  const CoachProfileScreen({super.key});

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _experienceController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final _videoUrlController = TextEditingController();

  @override
  void dispose() {
    _experienceController.dispose();
    _specialtiesController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Lưu lại context một cách an toàn
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final url = Uri.parse('http://10.0.2.2:8000/coaches/me/profile');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $fakeCoachToken',
    };
    final body = json.encode({
      'experience_summary': _experienceController.text,
      'specialties': _specialtiesController.text,
      'video_url': _videoUrlController.text,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Hồ sơ đã được lưu thành công!')),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối server.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (Phần UI giữ nguyên, không cần thay đổi) ...
    return Scaffold(
      appBar: AppBar(title: const Text('Hoàn thiện Hồ sơ HLV')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Tóm tắt kinh nghiệm', border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng nhập kinh nghiệm';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _specialtiesController,
                decoration: const InputDecoration(labelText: 'Chuyên môn (ví dụ: Bơi ếch, dạy trẻ em)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(labelText: 'Link video giới thiệu (YouTube)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('LƯU HỒ SƠ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}