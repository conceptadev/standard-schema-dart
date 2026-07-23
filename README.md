# standard_schema

[![CI](https://github.com/conceptadev/standard-schema-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/conceptadev/standard-schema-dart/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/standard_schema.svg)](https://pub.dev/packages/standard_schema)
[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

Vendor-neutral Standard Schema contracts for Dart validators and JSON Schema
converters.

`standard_schema` is an independent Dart port of the contract family described
by [standardschema.dev](https://standardschema.dev). It is maintained by
[Concepta](https://github.com/conceptadev) and is not an official package of,
or endorsed by, the upstream Standard Schema project.

## What this package standardizes

The package exposes two upstream contracts and one Dart convenience:

| Dart API | Purpose | Upstream status |
| --- | --- | --- |
| `StandardSchemaV1<Input, Output>` | Validate or transform an unknown value | Official V1 contract |
| `StandardJsonSchemaV1<Input, Output>` | Convert input/output types to JSON Schema | Official V1 contract |
| `StandardSchemaWithJsonSchemaV1<Input, Output>` | Expose both contracts through one Dart getter | Dart-only convenience |

Unversioned aliases are available for convenience, but compatibility checks
should prefer the V1 names.

Libraries implement these small surfaces and consumers call them without
depending on a vendor-specific schema tree. The package does not define a JSON
schema model, parser, renderer, or warning system; those stay in vendor
packages.

That distinction is intentional:

- A **Standard Schema contract** lets otherwise unrelated libraries validate
  values or produce JSON Schema through a shared interface.
- A **JSON Schema model** is a library-specific object tree used to construct,
  parse, transform, or render a schema document.

See [Design and compatibility](doc/design.md) for the complete mapping and the
process for proposing upstream-facing changes.

## Install

```console
dart pub add standard_schema
```

Import the validation and conversion contracts:

```dart
import 'package:standard_schema/standard_schema.dart';
```

## Compatibility checks

In Dart, compatibility is nominal: a value is a Standard Schema when it
implements the shared interface from this package.

```dart
if (schema is StandardSchemaV1<Object?, Object?>) {
  final result = await Future.value(schema.standard.validate(value));
}

if (schema is StandardJsonSchemaV1<Object?, Object?>) {
  final json = schema.standard.jsonSchema.input(
    const StandardJsonSchemaOptions(target: JsonSchemaTarget.draft07),
  );
}
```

The JSON Schema maps returned by converters are owned by the implementing
library. Consumers should treat them as JSON Schema for the requested target,
not as canonical byte-for-byte output shared by every vendor.

## Dart mapping notes

This package intentionally maps the upstream TypeScript contract into Dart
idioms:

- `~standard` is exposed as the normal Dart getter `standard`.
- TypeScript's phantom `types` field is omitted because Dart generics carry
  input and output types.
- A missing issue path is represented as an empty list, which is also the root
  path.
- Path keys are permissive `Object` values. Utilities such as `getDotPath`
  render only string and number keys and return `null` for other keys.

## Implement a schema

```dart
import 'package:standard_schema/standard_schema.dart';

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
        StandardIssue(message: 'Expected a non-empty string'),
      ]);
    },
  );
}
```

## Expose JSON Schema conversion

```dart
import 'package:standard_schema/standard_schema.dart';

final class RequiredStringJsonSchema
    implements StandardJsonSchemaV1<Object?, String> {
  const RequiredStringJsonSchema();

  @override
  StandardJsonSchemaPropsV1<Object?, String> get standard =>
      StandardJsonSchemaPropsV1(
        vendor: 'example',
        jsonSchema: StandardJsonSchemaConverter(
          input: (options) {
            if (options.target != JsonSchemaTarget.draft07) {
              throw UnsupportedError('Only Draft-7 is supported.');
            }

            return {'type': 'string'};
          },
          output: (options) => {'type': 'string'},
        ),
      );
}
```

Converters return plain JSON Schema maps (`Map<String, Object?>`). They may
throw when a schema cannot be represented for the requested target.
The concrete JSON Schema output is owned by the implementing library; this
package only defines the converter contract.

## Implement both traits

`StandardSchemaWithJsonSchemaV1` is a Dart-only convenience — not a separate
upstream interface. It models the structural intersection of the two official
`~standard` Props when one getter must satisfy both traits.

```dart
import 'package:standard_schema/standard_schema.dart';

final class RequiredStringSchemaWithJson
    implements StandardSchemaWithJsonSchemaV1<Object?, String> {
  const RequiredStringSchemaWithJson();

  @override
  StandardSchemaWithJsonSchemaPropsV1<Object?, String> get standard =>
      StandardSchemaWithJsonSchemaPropsV1(
        vendor: 'example',
        validate: (value, [options]) {
          if (value is String && value.isNotEmpty) {
            return StandardSuccess(value);
          }

          return StandardFailure([
            StandardIssue(message: 'Expected a non-empty string'),
          ]);
        },
        jsonSchema: StandardJsonSchemaConverter(
          input: (options) {
            if (options.target != JsonSchemaTarget.draft07) {
              throw UnsupportedError('Only Draft-7 is supported.');
            }

            return {'type': 'string'};
          },
          output: (options) => {'type': 'string'},
        ),
      );
}
```

## Utilities

Optional helpers for consuming validation issues live in a separate, opt-in
library, mirroring upstream's `@standard-schema/utils` package. Import it
explicitly:

```dart
import 'package:standard_schema/utils.dart';
```

- `getDotPath(issue)` renders raw path keys and `StandardPathSegment(key: ...)`
  entries in dot notation (for example `user.tags.1`), or returns `null` when
  the issue has no path or contains a key that is not a string or number.
- `StandardSchemaError(issues)` wraps a failure's issues as a throwable whose
  `message` is the first issue's message.

```dart
final result = await Future.value(schema.standard.validate(value));

if (result is StandardFailure) {
  // Render each issue's path in dot notation:
  for (final issue in result.issues) {
    print('${getDotPath(issue) ?? '<root>'}: ${issue.message}');
  }

  // Or throw the whole failure as a single error:
  throw StandardSchemaError(result.issues);
}
```

## Versioning and support

The package follows [Semantic Versioning](https://semver.org/). Before `1.0.0`,
minor versions may contain intentional API changes; patch releases remain
backward compatible.

The minimum supported Dart SDK is declared in `pubspec.yaml`. CI tests that
minimum version and the current stable SDK.

## Contributing and releases

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) before
opening a pull request. Maintainer decisions and the approval path for
unofficial or upstream-facing additions are described in
[GOVERNANCE.md](GOVERNANCE.md).

Versions, changelog entries, tags, GitHub releases, and pub.dev publication are
automated. Maintainer setup and the release runbook live in
[doc/releasing.md](doc/releasing.md).

## License and attribution

This package is licensed under the BSD 3-Clause License. The interfaces are
based on the MIT-licensed upstream Standard Schema project; see
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
