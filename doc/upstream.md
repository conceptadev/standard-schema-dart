# Upstream provenance

`standard_schema` is an independent, unofficial community Dart adaptation of
Standard Schema. It is not endorsed by the upstream project.

Version `0.0.1` was reviewed against upstream commit
[`a60ec0620dba64ddff8217f19e2ce479120af234`](https://github.com/standard-schema/standard-schema/tree/a60ec0620dba64ddff8217f19e2ce479120af234)
from July 13, 2026.

The principal sources are:

- [`packages/spec/src/index.ts`](https://github.com/standard-schema/standard-schema/blob/a60ec0620dba64ddff8217f19e2ce479120af234/packages/spec/src/index.ts)
- [`packages/utils/src/get-dot-path.ts`](https://github.com/standard-schema/standard-schema/blob/a60ec0620dba64ddff8217f19e2ce479120af234/packages/utils/src/get-dot-path.ts)
- [`packages/utils/src/schema-error.ts`](https://github.com/standard-schema/standard-schema/blob/a60ec0620dba64ddff8217f19e2ce479120af234/packages/utils/src/schema-error.ts)

## Language mapping

| Upstream TypeScript | Dart adaptation |
| --- | --- |
| `~standard` property | `standard` getter |
| Phantom `types` property | `Input` and `Output` generics |
| `Result \| Promise<Result>` | `FutureOr<StandardResult<Output>>` |
| Structural props and results | Package-owned immutable Dart values |
| `Record<string, unknown>` JSON Schema | `Map<String, Object?>` |
| Known target string union with extensions | `JsonSchemaTarget` extension type |

`StandardSchemaWithJsonSchemaV1` is a Dart-only convenience for an object that
supports both upstream capabilities through one nominal `standard` getter. It
is not a third upstream interface.

## Update policy

Before each release, maintainers compare the public Dart contract and utilities
with the current upstream sources. When alignment changes, this page records the
new commit and the changelog explains any user-visible difference. Dart-only
decisions remain explicitly labeled and contract changes that affect the
meaning of the standard are raised upstream before being presented as aligned.
