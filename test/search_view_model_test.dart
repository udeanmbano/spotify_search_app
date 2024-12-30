import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_search_app/services/spotify_api_service.dart'; // Adjust this import according to your project structure
import 'package:spotify_search_app/services/logger_service.dart'; // Adjust this import according to your project structure
import 'package:spotify_search_app/ui/search_viewmodel.dart'; // Adjust this import according to your project structure
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Mock classes for SpotifyApiService and LoggerService
class MockSpotifyApiService extends Mock implements SpotifyApiService {}
class MockLoggerService extends Mock implements LoggerService {}
// Correctly mock the http.Client class
class MockHttpClient extends Mock implements http.Client {}

void main() {
  // Setup before each test
  setUp(() {
    // Registering mock services in GetIt
    GetIt.I.registerSingleton<SpotifyApiService>(MockSpotifyApiService());
    GetIt.I.registerSingleton<LoggerService>(MockLoggerService());
  });

  // Cleanup after each test
  tearDown(() {
    // Unregistering services to avoid memory leaks or state issues
    GetIt.I.unregister<SpotifyApiService>();
    GetIt.I.unregister<LoggerService>();
  });

  test('Test SearchViewModel setSelectedType', () async {
    // Arrange: Initialize the view model
    final searchViewModel = SearchViewModel();

    // Act: Set a new selected type
    searchViewModel.setSelectedType('artist');

    // Assert: Check that selectedType was updated
    expect(searchViewModel.selectedType, 'artist');
  });


}