## 0.0.1

### Added

- Extract `standard_schema` into its own public repository with standalone
  package metadata, documentation, contribution guidance, CI, and automated
  releases.
- Add canonical `StandardTypedV1`, `StandardSchemaV1`, and
  `StandardJsonSchemaV1` names. The dev.0 names remain available as aliases.
- Add `StandardPathSegment` and the opt-in `utils.dart` library with
  `getDotPath` and the upstream-compatible `SchemaError`.
- Add a complete package example covering validation, transformed output,
  JSON Schema conversion, and dot-path rendering.
- Add consumer guides for forms, API boundaries, component and tool catalogs,
  AI structured output, and configuration loading.
- Record the exact upstream source revision, Dart mapping decisions, and
  package discovery topics.

### Changed

- Fix the V1 props marker at `version == 1`; constructors no longer accept an
  arbitrary version.
- Make props implementations final and snapshot failure issues, issue paths,
  and schema-error issues into unmodifiable lists.

## 0.0.1-dev.0

Initial development release published from the Ack repository to reserve the
`standard_schema` name on pub.dev.

### Added

- Add the unversioned Standard Schema validation and JSON Schema converter
  contracts, shared props, validation results/issues, converter options, and
  JSON Schema target constants.
- Add a Dart-only combined interface for implementers that expose validation
  and JSON Schema conversion from one `standard` getter.
