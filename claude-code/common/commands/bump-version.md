---
description: Bump project version and create git tag
disable-model-invocation: true
argument-hint: [patch | minor | major | X.Y.Z]
---

# Bump Version

Bump the project version, create a git tag, and commit/push.

## Arguments (optional)

- `patch` - Bump patch version (0.1.0 → 0.1.1)
- `minor` - Bump minor version (0.1.0 → 0.2.0)
- `major` - Bump major version (0.1.0 → 1.0.0)
- `X.Y.Z` - Set specific version (e.g., `1.2.3`)
- (no argument) - Auto-detect appropriate bump based on changes

## Instructions

1. **Check for uncommitted changes**:
   ```bash
   git status
   ```
   - If uncommitted changes exist: ABORT
   - "Uncommitted changes. Run `/commit-and-push` or `/commit-bump-push` first."

2. **Find current version** — check in priority order:
   - `pyproject.toml` → `version = "X.Y.Z"`
   - `VERSION` file → contains just `X.Y.Z`
   - If neither exists: create `VERSION` with `0.0.0` and use that

3. **Check if current version is already tagged**:
   ```bash
   git tag -l "vX.Y.Z"
   ```
   - If tag does NOT exist for current version → just create the tag (no bump needed)
   - If tag exists → proceed with version bump

4. **Determine bump type** based on argument ($ARGUMENTS):
   - If `patch`: increment Z
   - If `minor`: increment Y, reset Z to 0
   - If `major`: increment X, reset Y and Z to 0
   - If specific version (X.Y.Z format): use that version
   - If no argument: default to `patch`

5. **Update version** in whichever source was found in step 2:
   - `pyproject.toml` → update the `version = "..."` line
   - `VERSION` → overwrite file with new version string
   - Also update `__init__.py` with `__version__` (if exists)

6. **Commit version bump**:
   ```bash
   git add -A
   git commit -m "Bump to vX.Y.Z"
   ```

7. **Create tag**:
   ```bash
   git tag vX.Y.Z
   ```

8. **Push**:
   ```bash
   git push && git push --tags
   ```

9. **Report**:
   - `Version: X.Y.Z → A.B.C`
   - `Tagged: vA.B.C`
   - `Pushed`
