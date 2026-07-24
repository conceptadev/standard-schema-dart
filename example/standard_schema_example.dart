import 'package:standard_schema/standard_schema.dart';
import 'package:standard_schema/utils.dart';

final class RequiredStringSchema implements StandardSchemaV1<Object?, String> {
  const RequiredStringSchema();

  @override
  StandardSchemaPropsV1<Object?, String> get standard => StandardSchemaPropsV1(
    vendor: 'example',
    validate: (value, [options]) {
      if (value is String && value.isNotEmpty) {
        return StandardSuccess(value);
      }

      return StandardFailure([
        StandardIssue(
          message: 'Expected a non-empty string',
          path: ['user', 'name'],
        ),
      ]);
    },
  );
}

final class StringToIntSchema implements StandardSchemaV1<Object?, int> {
  const StringToIntSchema();

  @override
  StandardSchemaPropsV1<Object?, int> get standard => StandardSchemaPropsV1(
    vendor: 'example',
    validate: (value, [options]) {
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return StandardSuccess(parsed);
        }
      }

      return StandardFailure([
        StandardIssue(message: 'Expected an integer string', path: ['age']),
      ]);
    },
  );
}

final class RequiredStringWithJsonSchema
    implements StandardSchemaWithJsonSchemaV1<Object?, String> {
  const RequiredStringWithJsonSchema();

  @override
  StandardSchemaWithJsonSchemaPropsV1<Object?, String> get standard =>
      StandardSchemaWithJsonSchemaPropsV1(
        vendor: 'example',
        validate: const RequiredStringSchema().standard.validate,
        jsonSchema: StandardJsonSchemaConverter(
          input: (options) => {
            r'$schema': options.target,
            'type': 'string',
            'minLength': 1,
          },
          output: (options) => {'type': 'string', 'minLength': 1},
        ),
      );
}

Future<void> main() async {
  final name = await validateInput(const RequiredStringSchema(), 'Ada');
  final age = await validateInput(const StringToIntSchema(), '42');
  print('Validated: $name is $age');

  final schema = const RequiredStringWithJsonSchema();
  print(modelInputSchema(schema));

  try {
    await validateInput(schema, '');
  } on SchemaError catch (error) {
    for (final issue in error.issues) {
      final path = getDotPath(issue) ?? '<root>';
      print('$path: ${issue.message}');
    }
  }
}

Future<Output> validateInput<Input, Output>(
  StandardSchemaV1<Input, Output> schema,
  Object? value,
) async {
  final result = await Future.value(schema.standard.validate(value));

  return switch (result) {
    StandardSuccess(value: final output) => output,
    StandardFailure(issues: final issues) => throw SchemaError(issues),
  };
}

Map<String, Object?> modelInputSchema<Input, Output>(
  StandardJsonSchemaV1<Input, Output> schema,
) {
  return schema.standard.jsonSchema.input(
    const StandardJsonSchemaOptions(target: JsonSchemaTarget.draft202012),
  );
}
