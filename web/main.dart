import 'dart:html';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  // Enable web specific features if needed
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());
}