import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'country_picker.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MaterialApp(
    home: CountryPicker(),
  ));
}
