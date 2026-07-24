# Releasing

This repository uses Release Please for version and changelog pull requests,
GitHub releases for immutable version tags, and pub.dev trusted publishing for
package publication.

## One-time maintainer setup

### 1. Configure pub.dev trusted publishing

The package already exists on pub.dev as `0.0.1-dev.0`, so automated
publishing can be enabled from its Admin tab.

Configure:

- GitHub repository: `conceptadev/standard-schema-dart`
- Tag pattern: `v{{version}}`

No pub.dev token is stored in GitHub. The official Dart publishing workflow
uses a short-lived GitHub OIDC identity.

### 2. Confirm GitHub Actions permissions

The Release Please workflow uses the repository's built-in `GITHUB_TOKEN` to
maintain release pull requests, create tags and releases, and explicitly
dispatch the publishing workflow at the new tag. No long-lived pub.dev or
GitHub credential is required.

If the organization restricts workflow permissions, allow GitHub Actions to
create and approve pull requests for this repository. The workflow itself
declares only the permissions required for releases and dispatch.

An optional repository-scoped `RELEASE_PLEASE_TOKEN` secret remains supported
for organizations that require a GitHub App or separate automation identity.

### 3. Protect release tags

Create a repository ruleset for `v*` tags and restrict tag creation to
maintainers or the release automation identity.

## Initial `0.0.1` release

The repository is bootstrapped at `0.0.1`, matching `pubspec.yaml`,
`CHANGELOG.md`, and `.release-please-manifest.json`.

After the initial package pull request is reviewed and merged:

1. confirm CI passes on `main`;
2. create the `v0.0.1` GitHub release from the merged commit;
3. confirm the **Publish to pub.dev** workflow succeeds; and
4. verify https://pub.dev/packages/standard_schema shows `0.0.1`.

This one-time bootstrap establishes the baseline Release Please uses for later
versions.

## Subsequent releases

1. Merge normal pull requests with Conventional Commit titles.
2. Release Please opens or updates a release pull request.
3. Review its version, `pubspec.yaml`, and `CHANGELOG.md`.
4. Merge the release pull request.
5. Release Please creates the `v<version>` tag and GitHub release.
6. Release Please dispatches the official Dart workflow at that tag, which
   publishes through OIDC. A direct tag push also triggers the same workflow.

The publishing workflow checks pub.dev first, so rerunning it for an immutable
version completes without attempting a duplicate upload.

Before merging a release pull request, confirm the proposed version follows
Semantic Versioning and that CI's publish dry run has no warnings.

Published versions are immutable. Never amend an existing changelog section or
move an existing release tag; prepare a new version instead.
