# Governance

`standard_schema` is maintained by the
[Concepta GitHub organization](https://github.com/conceptadev).

## Decision process

Routine fixes and documentation changes are approved through normal pull
request review. Public API and compatibility decisions require:

1. an issue describing the use case and compatibility impact;
2. evidence of the corresponding upstream contract, or a clear explanation
   of why Dart requires a different mapping;
3. tests and public documentation; and
4. approval from a Concepta maintainer.

Maintainers may request an upstream issue or pull request before accepting a
change that claims to represent the Standard Schema specification.

## Official and unofficial behavior

This repository is an independent, unofficial Dart port. Acceptance here does
not make an addition part of the upstream Standard Schema specification.

An addition is treated as canonical only when it maps an accepted upstream
contract. Dart-specific conveniences may be accepted when they are clearly
named and documented as **Dart-only**, do not distort the upstream contracts,
and can evolve independently.

If upstream acceptance is uncertain, the preferred sequence is:

1. discuss the need in this repository;
2. open an issue or proposal with the upstream project;
3. record the upstream decision; and
4. implement the accepted mapping here through a reviewed pull request.

## Releases

Release Please proposes semantic versions and changelog updates from
Conventional Commit history. A Concepta maintainer reviews and merges the
release pull request. The resulting tag publishes to pub.dev through trusted
OIDC automation.

The initial stable `0.0.1` release is bootstrapped once; subsequent releases
use the same automated path described in [doc/releasing.md](doc/releasing.md).
