import 'package:somalivisamobile/environment.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'main.reflectable.dart';
import 'mapper.dart';

  import 'package:intl/intl.dart';
  import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeReflectable();
  configMapper();
  Constants.setEnvironment(Environment.DEV);
  Intl.defaultLocale = "en";
  initializeDateFormatting();
  runApp(SomalivisamobileApp());
}
