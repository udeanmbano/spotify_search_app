import 'package:stacked/stacked.dart';
import '../models/search_result.dart';
import '../services/spotify_api_service.dart';
import '../services/logger_service.dart';
import '../app/app.locator.dart';
import '../shared/strings.dart'; // Locator for service injection

class SearchViewModel extends BaseViewModel {
  final SpotifyApiService _apiService =
      locator<SpotifyApiService>(); // Get from locator
  final LoggerService _logger = locator<LoggerService>(); // Get from locator
  List<SearchResult> results = [];
  String _selectedType = AppStrings.selectedTypeAlbum; // 'album' or 'artist'

  String get selectedType => _selectedType;

  void setSelectedType(String type) {
    _logger.i('Selected type changed to $type'); // Logging change
    _selectedType = type;
    notifyListeners();
  }

  Future<void> search(String query) async {
    _logger.i(
        'Search initiated with query: $query and type: $_selectedType'); // Logging search initiation
    setBusy(true);
    try {
      final items = await _apiService.search(query, _selectedType);
      results = items.map((item) {
        final imageUrl = (item['images'] as List?)?.isNotEmpty ?? false
            ? item['images'][0]['url']
            : null;
        return SearchResult(
          id: item['id'],
          name: item['name'],
          imageUrl: imageUrl,
          artist: _selectedType == 'album' ? item['artists'][0]['name'] : null,
          year: _selectedType == AppStrings.selectedTypeAlbum
              ? item['release_date']?.split('-')[0]
              : null,
        );
      }).toList();
    } catch (e) {
      _logger.e('Search failed: $e'); // Logging error
      results = [];
    } finally {
      setBusy(false);
    }
  }
}
