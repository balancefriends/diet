import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:diet_built_value/src/json_patch.dart';

part 'serializers.g.dart';

@SerializersFor([JsonPatchOperation, JsonPatchOp])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
