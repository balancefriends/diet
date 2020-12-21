import 'dart:convert';
import 'dart:io';

Map<String, dynamic> loadFixture(String name) {
  return jsonDecode(File('test/fixtures/$name.json').readAsStringSync())
      as Map<String, dynamic>;
}
