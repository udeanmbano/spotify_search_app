import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../app/app.locator.dart';
import 'logger_service.dart'; // Your LoggerService

class SpotifyApiService {
  late final String clientId;
  late final String clientSecret;
  String? _accessToken;

  final LoggerService _logger =
      locator<LoggerService>(); // Get LoggerService from the locator

  SpotifyApiService() {
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    try {
      _logger.i('Loading credentials from JSON file.');
      final credentials =
          jsonDecode(await rootBundle.loadString('assets/credentials.json'));
      clientId = credentials['clientId'];
      clientSecret = credentials['clientSecret'];
      _logger.i('Credentials loaded successfully.');
    } catch (e) {
      _logger.e('Failed to load credentials: $e');
      throw Exception('Failed to load credentials: $e');
    }
  }

  Future<void> authenticate() async {
    try {
      _logger.i('Authenticating with Spotify API.');
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        _accessToken = jsonDecode(response.body)['access_token'];
        _logger.i('Authentication successful. Access token acquired.');
      } else {
        final error = jsonDecode(response.body);
        _logger.e('Authentication failed: ${error['error_description']}');
        throw Exception('Authentication failed: ${error['error_description']}');
      }
    } catch (e) {
      _logger.e('An error occurred during authentication: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> search(String query, String type) async {
    try {
      _logger.i('Performing search for "$query" of type "$type".');

      if (_accessToken == null) {
        _logger.w('Access token is null. Authenticating...');
        await authenticate();
      }

      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=$query&type=$type&limit=10'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        _logger.i('Search successful.');
        return jsonDecode(response.body)[type == 'album' ? 'albums' : 'artists']
            ['items'];
      } else {
        final error = jsonDecode(response.body);
        _logger.e('Search failed: ${error['error']['message']}');
        throw Exception('Search failed: ${error['error']['message']}');
      }
    } catch (e) {
      _logger.e('Error occurred during search: $e');
      rethrow;
    }
  }
}
