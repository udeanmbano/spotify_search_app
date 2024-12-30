import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApiService {
  final String clientId = 'c0161aa4e8b144a0ac31ac40494e0de4';
  final String clientSecret = '0ad6f4c4203843e1b3537816bb8d044f';
  String? _accessToken;

  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );
    if (response.statusCode == 200) {
      _accessToken = jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<List<dynamic>> search(String query, String type) async {
    if (_accessToken == null) await authenticate();

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=$type&limit=10'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[type == 'album' ? 'albums' : 'artists']['items'];
    } else {
      throw Exception('Failed to fetch results');
    }
  }
}
