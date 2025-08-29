import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> searchTavily(String query) async {
  final url = Uri.parse('https://api.tavily.com/search');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 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',
    },
    body: jsonEncode({
      'query': query,
      'search_depth': 'basic', // または 'advanced'
      'max_results': 5,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['results'] ?? []; // ここでUIに渡す
  } else {
    throw Exception('Tavily API error: ${response.statusCode}');
  }
}
