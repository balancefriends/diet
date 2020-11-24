import 'dart:convert';
import 'dart:io';

String loadFixture(String name, {String path = 'test/fixtures'}) {
  final Map environmentVars = Platform.environment;
  final current = environmentVars['PWD'];
  return File('$current/$path/$name.json').readAsStringSync();
}

Map<String, dynamic> loadFixtureJson(String name,
    {String path = 'test/fixtures'}) {
  final Map environmentVars = Platform.environment;
  final current = environmentVars['PWD'];
  return Map<String, dynamic>.from(
      jsonDecode(File('$current/$path/$name.json').readAsStringSync()));
}
