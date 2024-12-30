import 'package:stacked/stacked_annotations.dart';
import '../services/logger_service.dart';
import '../services/spotify_api_service.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => SpotifyApiService());
  locator.registerLazySingleton<LoggerService>(() => LoggerService());
}
