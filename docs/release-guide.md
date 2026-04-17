# Release Guide

## Version Source

Package version lives in:

- [`wally.toml`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/wally.toml)

Current version: `0.2.0`

## Semantic Versioning Policy

- `MAJOR`: breaking API/protocol/config changes
- `MINOR`: backward-compatible features
- `PATCH`: backward-compatible fixes only

## Branch Policy

- feature and release work targets `dev`
- merge to mainline when validated

## Release Checklist

1. Update docs for API/network/config changes.
2. Bump version in `wally.toml`.
3. Run validation:
   - `./scripts/format.ps1`
   - `./scripts/lint.ps1`
   - `./scripts/build.ps1`
4. Commit on `dev`.
5. Tag with semantic version.

## Example Commands

```bash
git switch dev
git add -A
git commit -m "feat: release v0.3.0 with <summary>"
git tag -a v0.3.0 -m "Release v0.3.0"
git push -u origin dev
git push origin v0.3.0
```

## Consumer Upgrade Example

In consuming game:

```toml
[dependencies]
brainrot-framework = "muratcan/brainrot-framework@0.3.0"
```

Then:

```bash
wally install
```

