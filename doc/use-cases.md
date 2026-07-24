# Consumer use cases

Standard Schema separates two roles:

- **Producers** are validator or schema libraries that implement one or both
  shared capabilities.
- **Consumers** are forms, routers, component catalogs, AI tools, configuration
  loaders, and other libraries that accept those capabilities without knowing
  the producer's private schema model.

Application developers keep using the producer's normal schema object. They
pass that object to any consumer that accepts the matching Standard Schema
interface.

## Validate an API boundary

A router can validate unknown request data and give a typed value to the
handler:

```dart
import 'dart:async';

import 'package:standard_schema/standard_schema.dart';
import 'package:standard_schema/utils.dart';

Future<Output> validateRequest<Input, Output>(
  StandardSchemaV1<Input, Output> schema,
  Object? body,
) async {
  final result = await Future.value(schema.standard.validate(body));

  return switch (result) {
    StandardSuccess(value: final output) => output,
    StandardFailure(issues: final issues) => throw SchemaError(issues),
  };
}
```

The handler depends only on `StandardSchemaV1`; the application chooses the
actual validator library.

## Render form field errors

Form consumers can map issues to stable field names without understanding the
producer:

```dart
import 'package:standard_schema/standard_schema.dart';
import 'package:standard_schema/utils.dart';

Map<String, String> fieldErrors(StandardFailure<Object?> failure) {
  return {
    for (final issue in failure.issues)
      getDotPath(issue) ?? '<root>': issue.message,
  };
}
```

`getDotPath` returns `null` for root issues and for paths that cannot be
represented safely in dot notation.

## Describe component or model input

A component catalog, tool registry, or structured-output integration usually
needs the input side of a schema:

```dart
import 'package:standard_schema/standard_schema.dart';

Map<String, Object?> modelInputSchema<Input, Output>(
  StandardJsonSchemaV1<Input, Output> schema,
) {
  return schema.standard.jsonSchema.input(
    const StandardJsonSchemaOptions(
      target: JsonSchemaTarget.draft202012,
    ),
  );
}
```

The producer owns the returned JSON Schema map and may reject targets it cannot
represent.

## Input versus output

Validation may transform data. For example, a schema can accept an integer
string as input and return an `int` as output:

- use `jsonSchema.input(...)` to describe data supplied by a form, API caller,
  component, or model;
- use `jsonSchema.output(...)` to describe the validated runtime value.

Consumers should accept the narrowest capability they need:
`StandardSchemaV1` for validation or `StandardJsonSchemaV1` for conversion.
Use the Dart-only `StandardSchemaWithJsonSchemaV1` only when the same API truly
requires both.
