import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:diet_built_value/diet_built_value.dart';
import 'package:diet_built_value/src/json_patch.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('json patch', () {
    setUp(() {});

    test('add', () {
      final json = loadFixture('json_patch_add');

      final add = JsonPatchOperation.fromJson(json);

      expect(add.op, JsonPatchOp.ADD);
      expect(add.path, '/biscuits/1');
      expect(add.value.asMap['name'], 'Ginger Nut');

      print(add.toJson());
    });

    test('remove', () {
      final json = loadFixture('json_patch_remove');

      final add = JsonPatchOperation.fromJson(json);

      expect(add.op, JsonPatchOp.REMOVE);
      expect(add.path, '/biscuits');
    });

    test('replace', () {
      final json = loadFixture('json_patch_replace');

      final add = JsonPatchOperation.fromJson(json);

      expect(add.op, JsonPatchOp.REPLACE);
      expect(add.path, '/biscuits/0/name');
      expect(add.value.asString, 'Chocolate Digestive');
    });

    test('copy', () {
      final json = loadFixture('json_patch_copy');

      final add = JsonPatchOperation.fromJson(json);

      expect(add.op, JsonPatchOp.COPY);
      expect(add.from, '/biscuits/0');
      expect(add.path, '/best_biscuit');
    });

    test('move', () {
      final json = loadFixture('json_patch_move');

      final add = JsonPatchOperation.fromJson(json);

      expect(add.op, JsonPatchOp.MOVE);
      expect(add.from, '/biscuits');
      expect(add.path, '/cookies');
    });

    test('test', () {
      final json = loadFixture('json_patch_test');

      final add = JsonPatchOperation.fromJson(json);

      expect(add.op, JsonPatchOp.TEST);
      expect(add.path, '/best_biscuit/name');
      expect(add.value, JsonObject('Choco Leibniz'));
    });
  });
}
