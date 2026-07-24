import 'dart:io';

final _versionPattern = RegExp(
  r'^[0-9]+\.[0-9]+\.[0-9]+(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$',
);

void main(List<String> arguments) {
  if (arguments.length > 1) {
    stderr.writeln('Usage: dart run tool/verify_version.dart [version]');
    exitCode = 64;
    return;
  }

  final pubspecVersion = _readPubspecVersion();
  final changelogVersion = _readChangelogVersion();
  final expectedVersion = arguments.firstOrNull;

  final errors = <String>[
    if (!_versionPattern.hasMatch(pubspecVersion))
      'pubspec.yaml has an invalid semantic version: $pubspecVersion',
    if (changelogVersion != pubspecVersion)
      'CHANGELOG.md starts with $changelogVersion, but pubspec.yaml uses '
          '$pubspecVersion',
    if (expectedVersion != null && expectedVersion != pubspecVersion)
      'Expected $expectedVersion, but pubspec.yaml uses $pubspecVersion',
  ];

  if (errors.isNotEmpty) {
    for (final error in errors) {
      stderr.writeln('ERROR: $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Version metadata is consistent: $pubspecVersion');
}

String _readPubspecVersion() {
  final match = RegExp(
    r'^version:\s*(\S+)\s*$',
    multiLine: true,
  ).firstMatch(File('pubspec.yaml').readAsStringSync());

  if (match == null) {
    throw const FormatException('pubspec.yaml has no top-level version');
  }
  return match.group(1)!;
}

String _readChangelogVersion() {
  final match = RegExp(
    r'^##\s+(\S+)\s*$',
    multiLine: true,
  ).firstMatch(File('CHANGELOG.md').readAsStringSync());

  if (match == null) {
    throw const FormatException('CHANGELOG.md has no version heading');
  }
  return match.group(1)!;
}
