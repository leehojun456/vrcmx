import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart' as models;

class ApiResponseView extends StatefulWidget {
  final models.User user;

  const ApiResponseView({super.key, required this.user});

  @override
  State<ApiResponseView> createState() => _ApiResponseViewState();
}

class _ApiResponseViewState extends State<ApiResponseView> {
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('JSON 응답이 클립보드에 복사되었습니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatJson(Map<String, dynamic>? json) {
    if (json == null) return 'API 응답 데이터가 없습니다';

    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jsonString = _formatJson(widget.user.rawApiResponse);
    return Scaffold(
      appBar: AppBar(
        title: const Text('VRChat API 응답'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyToClipboard(jsonString),
            tooltip: 'JSON 복사',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          jsonString,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
      ),
    );
  }
}
