# spotify_search_app

## Instructions to Run App
Here’s a simplified version of the **Instructions to Run the App** without any setup or configuration details, just the steps to run the app directly:

---

### **Instructions to Run the App**

1. **Clone the Repository**:
   Open your terminal and clone the project repository:
   ```bash
   git clone https://your-repository-url.git
   ```

2. **Navigate to the Project Directory**:
   ```bash
   cd <project-directory>
   ```

3. **Install Dependencies**:
   Run the following command to fetch the necessary packages:
   ```bash
   flutter pub get
   ```

4. **Run the App**:
    - For iOS (macOS only):
      ```bash
      flutter run or flutter run -d ios
      ```
    - For Android:
      ```bash
      flutter run or flutter run -d android
      ```

5. **Run on a Physical Device**:
    - Connect your physical device to the computer.
    - Run the app using:
      ```bash
      flutter run
      ```

---


## Suggestions 
Using the Stacked Architecture (a popular architecture for Flutter apps) for your app improves its scalability, maintainability, and testability by introducing a well-structured and modular approach to development.

---

### README.md

#### Improvements and Suggestions for Future Work

1. Adopting Stacked Architecture
   The Stacked architecture provides a clear separation of concerns through ViewModels, Views, and Services. Below are specific ways it could improve the current app:

    - Separation of UI and Business Logic:
        - Currently, `SpotifyApiService` handles business logic (e.g., authentication, API calls) but does not interact cleanly with the UI.
        - Using Stacked, business logic would be encapsulated in ViewModels, and the UI in Views, ensuring a clean separation and avoiding tightly coupled code.

    - Reactive State Management:
        - Stacked provides a built-in reactive state management mechanism via the `BaseViewModel`. The app's UI can automatically react to state changes in the ViewModel, making it more dynamic and eliminating the need for manual state handling.

    - Improved Scalability:
        - As the app grows, additional features like playlist management, playback control, or user profiles can be added by creating new services and ViewModels without affecting existing code.

   Example:
   ```dart
   class SearchViewModel extends BaseViewModel {
     final SpotifyApiService _spotifyApiService = locator<SpotifyApiService>();

     List<dynamic> _results = [];
     List<dynamic> get results => _results;

     Future<void> performSearch(String query, String type) async {
       setBusy(true);
       try {
         _results = await _spotifyApiService.search(query, type);
       } catch (e) {
         setError(e);
       } finally {
         setBusy(false);
       }
     }
   }
   ```

   In this structure, `performSearch` resides in the ViewModel, while the UI in the View observes `results` to display data.

2. Implementing Dependency Injection (DI) with Stacked's Locator Integration
    - The current implementation uses a service locator for dependency injection. Stacked integrates well with `get_it` and organizes services and repositories systematically.
    - This would improve modularity by ensuring that components (e.g., `SpotifyApiService`, `LoggerService`) are injected into ViewModels or other services only when needed, reducing unnecessary dependencies.

   Example:
   ```dart
   void setupLocator() {
     locator.registerLazySingleton<SpotifyApiService>(() => SpotifyApiService());
     locator.registerLazySingleton<LoggerService>(() => LoggerService());
   }
   ```

3. Enhanced Testability
    - Unit Tests:
        - By isolating business logic in ViewModels and abstracting API interactions via services, it becomes easier to write targeted unit tests for specific methods without worrying about UI interactions.
    - Mocking API Responses:
        - The `SpotifyApiService` could be abstracted as an interface, allowing mock implementations to be injected during testing.

      Example:
      ```dart
      class MockSpotifyApiService implements SpotifyApiService {
        @override
        Future<List<dynamic>> search(String query, String type) async {
          return [
            {'name': 'Mock Album 1'},
            {'name': 'Mock Album 2'},
          ];
        }
      }
      ```

      Injecting this mock service into the `SearchViewModel` ensures test coverage for UI responses without relying on the live Spotify API.

4. Error Handling and User Feedback
    - Stacked's `BaseViewModel` provides built-in support for error states via `setError`.
    - For example, if the `search` function fails, you could bind error messages to a widget that provides clear feedback to the user.

5. Future-Proofing Features
    - Offline Support: Use Stacked's services to add caching mechanisms for API results using a local database like `Hive` or `Sqflite`. This ensures the app works seamlessly even without internet connectivity.
    - Dynamic Features: Introduce new features like a "Favorites" section or "Top Charts" without refactoring existing code due to the modular nature of Stacked.
    - Authentication Tokens: Store tokens securely using services like `flutter_secure_storage`.

6. Improved Logger Integration
    - Move logging to a dedicated `LoggerService`, which can be reused across ViewModels and services. Ensure all logs, errors, and API failures are logged consistently.
    - Stacked allows injecting `LoggerService` into ViewModels for better traceability.

---

### Why Stacked Made This App Better

1. Better Code Organization:
    - Clear distinction between Views (UI), ViewModels (logic), and Services (API/data operations) makes it easy to navigate the codebase.

2. Scalability:
    - Adding features like Spotify playlists, detailed track information, or user authentication becomes straightforward due to Stacked's modularity.

3. Improved Team Collaboration:
    - Frontend developers can focus on Views, while backend or API logic is encapsulated in Services, allowing independent work streams.

4. Easier Maintenance:
    - Changes in API endpoints or new requirements can be implemented in Services/ViewModels without impacting Views.

5. Reactive Programming:
    - Stacked simplifies state management and ensures the UI automatically updates, improving the user experience.

By incorporating these changes, the app becomes robust, scalable, and future-proof while maintaining clean, testable code.
