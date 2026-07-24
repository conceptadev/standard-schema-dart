# Design and compatibility

## Scope

This package is a small interoperability layer. It defines contracts that
schema libraries can implement and consumers can recognize without importing a
vendor-specific schema representation.

It intentionally does not define:

- a JSON Schema object model or abstract syntax tree;
- parsing or serialization;
- schema composition builders;
- conversion warnings or diagnostics; or
- a validator implementation.

Those features belong in producer libraries. Keeping them out of the standard
contract lets libraries with very different internal models interoperate.

## Contract map

The upstream TypeScript project defines two V1 interfaces:

| Upstream | Dart | Meaning |
| --- | --- | --- |
| `StandardSchemaV1` | `StandardSchemaV1<Input, Output>` | Validate and optionally transform |
| `StandardJSONSchemaV1` | `StandardJsonSchemaV1<Input, Output>` | Convert input and output sides to JSON Schema |

Both expose a TypeScript `~standard` property. Dart maps that property to the
getter `standard`.

`StandardSchemaWithJsonSchemaV1` is not a third upstream interface. It is a
Dart-only convenience that models an object whose one `standard` getter
satisfies both official contracts.

## Dart mapping decisions

- Dart generics represent input and output types, so the TypeScript phantom
  `types` property is omitted.
- The V1 marker is exposed as a read-only `version` getter fixed at `1`.
- Synchronous and asynchronous validators use `FutureOr`.
- Issue paths accept raw keys and `StandardPathSegment` objects.
- A missing path is represented by an empty list.
- Converter output is `Map<String, Object?>`; ownership and dialect-specific
  behavior stay with the implementing library.
- JSON Schema targets use an extension type so known targets have constants
  while vendor extensions remain possible.

## Compatibility rule

Dart uses nominal typing. A value participates in the standard only when its
class explicitly implements the shared interface from this package. Matching
members alone are not enough.

Consumers should test the narrowest capability they need:

```dart
if (value is StandardSchemaV1<Object?, Object?>) {
  final result = await Future.value(value.standard.validate(input));
}

if (value is StandardJsonSchemaV1<Object?, Object?>) {
  final schema = value.standard.jsonSchema.input(
    const StandardJsonSchemaOptions(
      target: JsonSchemaTarget.draft202012,
    ),
  );
}
```

## Package-owned values

The upstream TypeScript contract relies on structural typing. Dart uses nominal
typing, so producers and consumers must import this shared runtime package to
agree on the same interfaces and values.

The top-level capabilities are interfaces. Their properties, options, results,
issues, and converter objects are immutable values owned by this package.
Producers return `StandardSchemaPropsV1`, `StandardSuccess`,
`StandardFailure`, and the corresponding JSON Schema values rather than
redeclaring structurally similar classes.

This tradeoff gives Dart consumers stable runtime checks and exhaustive pattern
matching over validation results while keeping the package small and free of
runtime dependencies.

## Upstream alignment and approval

The authoritative standard lives at
[standardschema.dev](https://standardschema.dev) and
[`standard-schema/standard-schema`](https://github.com/standard-schema/standard-schema).
This Dart package is independent and unofficial. The exact source revision and
language mapping used by each release are recorded in
[Upstream provenance](upstream.md).

For a proposed contract change:

1. open a local issue describing the Dart use case;
2. identify whether the proposal already exists upstream;
3. when it changes the meaning of the standard, seek upstream approval through
   an upstream issue or pull request;
4. link that decision from the local implementation pull request; and
5. mark any accepted Dart-only convenience explicitly.

This gives experimental integrations a place to develop without representing
them as official standard behavior before upstream approval.
