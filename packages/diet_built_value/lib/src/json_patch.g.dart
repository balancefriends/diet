// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JsonPatchOp _$ADD = const JsonPatchOp._('ADD');
const JsonPatchOp _$REPLACE = const JsonPatchOp._('REPLACE');
const JsonPatchOp _$TEST = const JsonPatchOp._('TEST');
const JsonPatchOp _$REMOVE = const JsonPatchOp._('REMOVE');
const JsonPatchOp _$MOVE = const JsonPatchOp._('MOVE');
const JsonPatchOp _$COPY = const JsonPatchOp._('COPY');

JsonPatchOp _$jsonPatchOpValueOf(String name) {
  switch (name) {
    case 'ADD':
      return _$ADD;
    case 'REPLACE':
      return _$REPLACE;
    case 'TEST':
      return _$TEST;
    case 'REMOVE':
      return _$REMOVE;
    case 'MOVE':
      return _$MOVE;
    case 'COPY':
      return _$COPY;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<JsonPatchOp> _$jsonPatchOpValues =
    new BuiltSet<JsonPatchOp>(const <JsonPatchOp>[
  _$ADD,
  _$REPLACE,
  _$TEST,
  _$REMOVE,
  _$MOVE,
  _$COPY,
]);

Serializer<JsonPatchOperation> _$jsonPatchOperationSerializer =
    new _$JsonPatchOperationSerializer();
Serializer<JsonPatchOp> _$jsonPatchOpSerializer = new _$JsonPatchOpSerializer();

class _$JsonPatchOperationSerializer
    implements StructuredSerializer<JsonPatchOperation> {
  @override
  final Iterable<Type> types = const [JsonPatchOperation, _$JsonPatchOperation];
  @override
  final String wireName = 'JsonPatchOperation';

  @override
  Iterable<Object> serialize(Serializers serializers, JsonPatchOperation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'op',
      serializers.serialize(object.op,
          specifiedType: const FullType(JsonPatchOp)),
      'path',
      serializers.serialize(object.path, specifiedType: const FullType(String)),
    ];
    if (object.value != null) {
      result
        ..add('value')
        ..add(serializers.serialize(object.value,
            specifiedType: const FullType(JsonObject)));
    }
    if (object.from != null) {
      result
        ..add('from')
        ..add(serializers.serialize(object.from,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  JsonPatchOperation deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new JsonPatchOperationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'op':
          result.op = serializers.deserialize(value,
              specifiedType: const FullType(JsonPatchOp)) as JsonPatchOp;
          break;
        case 'path':
          result.path = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'value':
          result.value = serializers.deserialize(value,
              specifiedType: const FullType(JsonObject)) as JsonObject;
          break;
        case 'from':
          result.from = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$JsonPatchOpSerializer implements PrimitiveSerializer<JsonPatchOp> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADD': 'add',
    'REPLACE': 'replace',
    'TEST': 'test',
    'REMOVE': 'remove',
    'MOVE': 'move',
    'COPY': 'copy',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'add': 'ADD',
    'replace': 'REPLACE',
    'test': 'TEST',
    'remove': 'REMOVE',
    'move': 'MOVE',
    'copy': 'COPY',
  };

  @override
  final Iterable<Type> types = const <Type>[JsonPatchOp];
  @override
  final String wireName = 'JsonPatchOp';

  @override
  Object serialize(Serializers serializers, JsonPatchOp object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JsonPatchOp deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JsonPatchOp.valueOf(_fromWire[serialized] ?? serialized as String);
}

class _$JsonPatchOperation extends JsonPatchOperation {
  @override
  final JsonPatchOp op;
  @override
  final String path;
  @override
  final JsonObject value;
  @override
  final String from;
  bool __isAdd;
  bool __isReplace;
  bool __isRemove;
  bool __isTest;
  bool __isMove;
  bool __isCopy;

  factory _$JsonPatchOperation(
          [void Function(JsonPatchOperationBuilder) updates]) =>
      (new JsonPatchOperationBuilder()..update(updates)).build();

  _$JsonPatchOperation._({this.op, this.path, this.value, this.from})
      : super._() {
    if (op == null) {
      throw new BuiltValueNullFieldError('JsonPatchOperation', 'op');
    }
    if (path == null) {
      throw new BuiltValueNullFieldError('JsonPatchOperation', 'path');
    }
  }

  @override
  bool get isAdd => __isAdd ??= super.isAdd;

  @override
  bool get isReplace => __isReplace ??= super.isReplace;

  @override
  bool get isRemove => __isRemove ??= super.isRemove;

  @override
  bool get isTest => __isTest ??= super.isTest;

  @override
  bool get isMove => __isMove ??= super.isMove;

  @override
  bool get isCopy => __isCopy ??= super.isCopy;

  @override
  JsonPatchOperation rebuild(
          void Function(JsonPatchOperationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JsonPatchOperationBuilder toBuilder() =>
      new JsonPatchOperationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JsonPatchOperation &&
        op == other.op &&
        path == other.path &&
        value == other.value &&
        from == other.from;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, op.hashCode), path.hashCode), value.hashCode),
        from.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('JsonPatchOperation')
          ..add('op', op)
          ..add('path', path)
          ..add('value', value)
          ..add('from', from))
        .toString();
  }
}

class JsonPatchOperationBuilder
    implements Builder<JsonPatchOperation, JsonPatchOperationBuilder> {
  _$JsonPatchOperation _$v;

  JsonPatchOp _op;
  JsonPatchOp get op => _$this._op;
  set op(JsonPatchOp op) => _$this._op = op;

  String _path;
  String get path => _$this._path;
  set path(String path) => _$this._path = path;

  JsonObject _value;
  JsonObject get value => _$this._value;
  set value(JsonObject value) => _$this._value = value;

  String _from;
  String get from => _$this._from;
  set from(String from) => _$this._from = from;

  JsonPatchOperationBuilder();

  JsonPatchOperationBuilder get _$this {
    if (_$v != null) {
      _op = _$v.op;
      _path = _$v.path;
      _value = _$v.value;
      _from = _$v.from;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JsonPatchOperation other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$JsonPatchOperation;
  }

  @override
  void update(void Function(JsonPatchOperationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$JsonPatchOperation build() {
    final _$result = _$v ??
        new _$JsonPatchOperation._(
            op: op, path: path, value: value, from: from);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
