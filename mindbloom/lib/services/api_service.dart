import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000'; // Update with your server's IP

  // Fetch feedback data
  Future<List<dynamic>> fetchFeedback() async {
    final response = await http.get(Uri.parse('$baseUrl/feedback'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  // Submit feedback
  Future<void> submitFeedback(Map<String, dynamic> feedbackData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(feedbackData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit feedback');
    }
  }
}
