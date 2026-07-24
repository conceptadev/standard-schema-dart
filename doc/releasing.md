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

### 2. Configure Release Please credentials

Create a repository-scoped fine-grained token or GitHub App credential with
`Contents: write` and `Pull requests: write`. If Release Please will apply or
manage issue labels, also grant `Issues: write`. Store the credential as the
repository secret `RELEASE_PLEASE_TOKEN`.

The workflow falls back to `GITHUB_TOKEN`, which can maintain release pull
requests and create GitHub releases. GitHub suppresses new workflow runs caused
by resources created with `GITHUB_TOKEN`, however, so the dedicated credential
is required for a release-created tag to trigger the separate pub.dev publish
workflow automatically.

Keep the credential limited to this repository and these release permissions.

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
6. The tag triggers the official Dart workflow, which publishes through OIDC.

Before merging a release pull request, confirm the proposed version follows
Semantic Versioning and that CI's publish dry run has no warnings.

Published versions are immutable. Never amend an existing changelog section or
move an existing release tag; prepare a new version instead.
