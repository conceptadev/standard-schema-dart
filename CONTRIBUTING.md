# Contributing

Thank you for helping improve `standard_schema`.

## Development setup

Install a Dart SDK supported by `pubspec.yaml`, then run:

```console
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
dart run example/standard_schema_example.dart
dart pub publish --dry-run
```

The repository's Conductor setup runs `dart pub get` when a workspace is
created and provides test and example run actions.

## Proposing a change

Open an issue before making a contract-level change. A proposal should state:

1. whether it mirrors an accepted upstream Standard Schema change;
2. whether it is a Dart mapping required by the language;
3. the compatibility and versioning impact; and
4. tests or examples that demonstrate the intended behavior.

Additions that are not part of the upstream standard must use an explicit
`Dart-only` label in documentation and remain separable from the canonical
interfaces. See [GOVERNANCE.md](GOVERNANCE.md) and
[doc/design.md](doc/design.md).

## Pull requests

- Keep each pull request focused.
- Use a Conventional Commit title, such as `fix: preserve issue path keys`.
- Add or update tests for behavior changes.
- Update public API documentation and examples when necessary.
- Do not edit the package version or released changelog sections in feature
  pull requests. Release Please owns those changes.
- Confirm formatting, analysis, tests, and the publish dry run pass.

By contributing, you agree that your contribution is licensed under this
repository's BSD 3-Clause License.
