import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/constants.dart';

abstract class BaseAgent {
  final String role;
  final String instructions;

  BaseAgent({required this.role, required this.instructions});

  Future<String> process(String input) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.grokApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.grokApiKey}',
        },
        body: jsonEncode({
          'model': AppConstants.grokModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are the $role of the Rihla Travel System. $instructions',
            },
            {
              'role': 'user',
              'content': input,
            },
          ],
          'temperature': 0.5,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }
      return 'Agent Error: ${response.statusCode}';
    } catch (e) {
      return 'Agent Exception: $e';
    }
  }
}
