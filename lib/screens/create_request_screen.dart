import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Đổi tên hằng số theo quy tắc lowerCamelCase
const String fakeLearnerToken = "YOUR_LEARNER_ACCESS_TOKEN";

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final int _selectedCoachId = 8;
  final int _selectedPoolId = 1;

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Lưu lại context một cách an toàn
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final url = Uri.parse('http://10.0.2.2:8000/bookings/');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $fakeLearnerToken',
    };
    final body = json.encode({
      'pool_id': _selectedPoolId,
      'coach_id': _selectedCoachId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Gửi yêu cầu thành công!')),
        );
        navigator.pop(); // Quay lại trang trước
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
      appBar: AppBar(title: const Text('Tạo Yêu cầu Khóa học')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Gửi yêu cầu đến HLV ID: $_selectedCoachId'),
              Text('Tại Hồ bơi ID: $_selectedPoolId'),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Ghi chú thêm (ví dụ: trình độ, mục tiêu...)', border: OutlineInputBorder()),
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
                child: const Text('GỬI YÊU CẦU KHÓA HỌC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}