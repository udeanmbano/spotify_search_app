import 'package:flutter_test/flutter_test.dart' as WidgetTest;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_search_app/app/app.locator.dart';
import 'package:spotify_search_app/services/logger_service.dart';
import 'package:spotify_search_app/services/spotify_api_service.dart';
import 'package:spotify_search_app/ui/search_viewmodel.dart';
import 'package:test/test.dart';
import 'dart:convert';

// Generate Mocks for the required services
@GenerateMocks([SpotifyApiService, LoggerService])
import 'search_view_model_test.mocks.dart';
void main() {
  WidgetTest.TestWidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter framework is initialized

  late SearchViewModel viewModel;
  late MockSpotifyApiService mockApiService;
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockApiService = MockSpotifyApiService();
    mockLoggerService = MockLoggerService();

    // Register mocks
    if (!locator.isRegistered<SpotifyApiService>()) {
      locator.registerSingleton<SpotifyApiService>(mockApiService);
    }
    if (!locator.isRegistered<LoggerService>()) {
      locator.registerSingleton<LoggerService>(mockLoggerService);
    }

    viewModel = SearchViewModel();
  });

  tearDown(() {
    locator.reset();
  });

  group('SearchViewModel Tests', () {
    test('should change selected type', () {
      viewModel.setSelectedType('artist');
      expect(viewModel.selectedType, 'artist');
      verify(mockLoggerService.i('Selected type changed to artist')).called(1);
    });

    test('should perform search and populate results', () async {
      final mockSearchResults = [
        {'id': '1', 'name': 'Test Album', 'images': [], 'artists': [{'name': 'Artist Name'}], 'release_date': '2020-01-01'}
      ];

      when(mockApiService.search(any, any)).thenAnswer((_) async => mockSearchResults);

      await viewModel.search('test query');

      expect(viewModel.results.length, 1);
      expect(viewModel.results[0].name, 'Test Album');
      verify(mockLoggerService.i('Search initiated with query: test query and type: album')).called(1);
    });

    test('should handle search failure gracefully', () async {
      when(mockApiService.search(any, any)).thenThrow(Exception('Failed to fetch results'));

      await viewModel.search('test query');

      expect(viewModel.results.isEmpty, true);
      verify(mockLoggerService.e('Search failed: Exception: Failed to fetch results')).called(1);
    });
  });
}
