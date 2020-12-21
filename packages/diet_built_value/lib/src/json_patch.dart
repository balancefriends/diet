import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:diet_built_value/diet_built_value.dart';

import 'serializers.dart';

part 'json_patch.g.dart';

abstract class JsonPatchOperation
    implements Built<JsonPatchOperation, JsonPatchOperationBuilder> {
  JsonPatchOperation._() {
    switch (op) {
      case JsonPatchOp.ADD:
      case JsonPatchOp.REPLACE:
      case JsonPatchOp.TEST:
        if (value == null) throw ArgumentError('"value" is required');
        break;
      case JsonPatchOp.MOVE:
      case JsonPatchOp.COPY:
        if (from == null) throw ArgumentError('"from" is required');
        break;
    }
  }

  factory JsonPatchOperation.add(String path, dynamic value) {
    return JsonPatchOperation.inner((b) => b
      ..op = JsonPatchOp.ADD
      ..path = path
      ..value = JsonObject(value));
  }

  factory JsonPatchOperation.replace(String path, dynamic value) {
    return JsonPatchOperation.inner((b) => b
      ..op = JsonPatchOp.REPLACE
      ..path = path
      ..value = JsonObject(value));
  }

  factory JsonPatchOperation.test(String path, dynamic value) {
    return JsonPatchOperation.inner((b) => b
      ..op = JsonPatchOp.TEST
      ..path = path
      ..value = JsonObject(value));
  }

  factory JsonPatchOperation.remove(String path) {
    return JsonPatchOperation.inner((b) => b
      ..op = JsonPatchOp.REMOVE
      ..path = path);
  }

  factory JsonPatchOperation.move(String from, String path) {
    return JsonPatchOperation.inner((b) => b
      ..op = JsonPatchOp.MOVE
      ..path = path);
  }

  factory JsonPatchOperation.copy(String from, String path) {
    return JsonPatchOperation.inner((b) => b
      ..op = JsonPatchOp.COPY
      ..path = path);
  }

  factory JsonPatchOperation.inner(
          [void Function(JsonPatchOperationBuilder) updates]) =
      _$JsonPatchOperation;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(JsonPatchOperation.serializer, this);
  }

  static JsonPatchOperation fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(JsonPatchOperation.serializer, json);
  }

  static Serializer<JsonPatchOperation> get serializer =>
      _$jsonPatchOperationSerializer;

  JsonPatchOp get op;

  String get path;

  @nullable
  JsonObject get value;

  @nullable
  String get from;

  @memoized
  bool get isAdd => op == JsonPatchOp.ADD;

  @memoized
  bool get isReplace => op == JsonPatchOp.REPLACE;

  @memoized
  bool get isRemove => op == JsonPatchOp.REMOVE;

  @memoized
  bool get isTest => op == JsonPatchOp.TEST;

  @memoized
  bool get isMove => op == JsonPatchOp.MOVE;

  @memoized
  bool get isCopy => op == JsonPatchOp.COPY;
}

@BuiltValueEnum()
class JsonPatchOp extends EnumClass {
  @BuiltValueEnumConst(wireName: 'add')
  static const JsonPatchOp ADD = _$ADD;
  @BuiltValueEnumConst(wireName: 'replace')
  static const JsonPatchOp REPLACE = _$REPLACE;
  @BuiltValueEnumConst(wireName: 'test')
  static const JsonPatchOp TEST = _$TEST;
  @BuiltValueEnumConst(wireName: 'remove')
  static const JsonPatchOp REMOVE = _$REMOVE;
  @BuiltValueEnumConst(wireName: 'move')
  static const JsonPatchOp MOVE = _$MOVE;
  @BuiltValueEnumConst(wireName: 'copy')
  static const JsonPatchOp COPY = _$COPY;

  const JsonPatchOp._(String name) : super(name);

  static BuiltSet<JsonPatchOp> get values => _$jsonPatchOpValues;

  static JsonPatchOp valueOf(String name) => _$jsonPatchOpValueOf(name);

  static Serializer<JsonPatchOp> get serializer => _$jsonPatchOpSerializer;
}

abstract class HasValue {
  /// The value to add, replace or test.
  JsonObject get value;
}

abstract class hasFrom {
  /// A JSON Pointer path pointing to the location to move/copy from.
  String get from;
}
