import 'standard_schema.dart';

/// Returns the dot-notation path of an [issue] (for example `user.tags.1`), or
/// `null` when the issue has no path or any segment is not a string or number.
///
/// Direct port of `getDotPath` from `@standard-schema/utils`.
String? getDotPath(StandardIssue issue) {
  if (issue.path.isEmpty) return null;
  final dotPath = StringBuffer();
  for (final segment in issue.path) {
    final key = segment is StandardPathSegment ? segment.key : segment;
    if (key is String || key is num) {
      if (dotPath.isNotEmpty) dotPath.write('.');
      dotPath.write(key);
    } else {
      return null;
    }
  }
  return dotPath.toString();
}

/// An [Exception] wrapping the [issues] of a failed Standard Schema validation,
/// exposing the first issue's [message]. The standard way to throw on failure.
///
/// Dart port of `SchemaError` from `@standard-schema/utils`.
class SchemaError implements Exception {
  /// Wraps [issues].
  ///
  /// Throws [ArgumentError] when [issues] is empty because [message] is taken
  /// from the first issue, matching the upstream utility.
  SchemaError(Iterable<StandardIssue> issues) : this._(_snapshotIssues(issues));

  SchemaError._(this.issues) : message = issues.first.message;

  static List<StandardIssue> _snapshotIssues(Iterable<StandardIssue> issues) {
    final issueList = List<StandardIssue>.unmodifiable(issues);
    if (issueList.isEmpty) {
      throw ArgumentError.value(issues, 'issues', 'must not be empty');
    }
    return issueList;
  }

  /// The issues describing why validation failed. Never empty.
  final List<StandardIssue> issues;

  /// The error message, taken from the first issue.
  final String message;

  @override
  String toString() => 'SchemaError: $message';
}
