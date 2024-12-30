import 'package:flutter/material.dart';
import 'package:spotify_search_app/ui/search_view.dart';

import 'app/app.locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      theme: ThemeData.dark(),
      home: SearchView(),
    );
  }
}
