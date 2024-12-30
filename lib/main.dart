import 'package:flutter/material.dart';
import 'package:spotify_search_app/shared/strings.dart';
import 'package:spotify_search_app/ui/search_view.dart';

import 'app/app.locator.dart';

void main() {
  //initializing loading of resources
  WidgetsFlutterBinding.ensureInitialized();
  //initializing Stacked Locator for dependency injection
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData.dark(),
      home: SearchView(),
    );
  }
}
