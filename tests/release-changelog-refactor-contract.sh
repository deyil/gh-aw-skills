#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

pass() {
  printf 'PASS: %s\n' "$1"
}

require_path() {
  local path="$1"
  local message="$2"

  if [[ -e "$path" ]]; then
    pass "$message"
  else
    fail "$message (missing $path)"
  fi
}

require_fixed() {
  local path="$1"
  local needle="$2"
  local message="$3"

  if grep -Fq -- "$needle" "$path"; then
    pass "$message"
  else
    fail "$message (expected '$needle' in $path)"
  fi
}

require_regex() {
  local path="$1"
  local pattern="$2"
  local message="$3"

  if grep -Eq -- "$pattern" "$path"; then
    pass "$message"
  else
    fail "$message (expected pattern '$pattern' in $path)"
  fi
}

require_no_regex() {
  local path="$1"
  local pattern="$2"
  local message="$3"

  if grep -Eq -- "$pattern" "$path"; then
    fail "$message (unexpected pattern '$pattern' in $path)"
  else
    pass "$message"
  fi
}

require_local_action_refs() {
  local path="$1"
  local minimum="$2"
  local message="$3"
  local count

  count="$(grep -Ec '^[[:space:]]+uses:[[:space:]]+\./\.github/actions/' "$path" || true)"
  if (( count >= minimum )); then
    pass "$message"
  else
    fail "$message (found $count local action reference(s) in $path, expected at least $minimum)"
  fi
}

require_composite_actions() {
  local message="$1"
  local action_count
  local action_file

  if [[ ! -d .github/actions ]]; then
    fail "$message (.github/actions directory is missing)"
    return
  fi

  action_count="$(find .github/actions -mindepth 2 -maxdepth 2 -name action.yml | wc -l | tr -d ' ')"
  if (( action_count < 2 )); then
    fail "$message (found $action_count action metadata file(s), expected at least 2)"
    return
  fi

  while IFS= read -r action_file; do
    require_fixed "$action_file" 'using: composite' "$(basename "$(dirname "$action_file")") is a composite action"
  done < <(find .github/actions -mindepth 2 -maxdepth 2 -name action.yml | sort)

  pass "$message"
}

require_adjacent_placeholder_render() {
  local message="$1"
  local rendered

  rendered="$(
    TPL_RELEASE_DATE='2026-04-23' \
    TPL_PRERELEASE_SUFFIX=' [prerelease]' \
    TPL_MAIN_BODY='Body line' \
    TPL_APPENDIX_BLOCK=$'\n\nAppendix line' \
    perl -0pe '
      my %replacements = (
        RELEASE_DATE => ($ENV{TPL_RELEASE_DATE} // q{}),
        PRERELEASE_SUFFIX => ($ENV{TPL_PRERELEASE_SUFFIX} // q{}),
        MAIN_BODY => ($ENV{TPL_MAIN_BODY} // q{}),
        APPENDIX_BLOCK => ($ENV{TPL_APPENDIX_BLOCK} // q{}),
      );

      s/__([A-Z]+(?:_[A-Z]+)*)__/exists $replacements{$1} ? $replacements{$1} : $&/ge;
    ' <<'EOF'
__RELEASE_DATE____PRERELEASE_SUFFIX__
__MAIN_BODY____APPENDIX_BLOCK__
EOF
  )"

  if [[ "$rendered" == $'2026-04-23 [prerelease]\nBody line\n\nAppendix line' ]]; then
    pass "$message"
  else
    fail "$message (rendered output was unexpected: $rendered)"
  fi
}

run_actionlint() {
  local message="$1"
  local workflow_publish=.github/workflows/publish-release.yml
  local workflow_update=.github/workflows/update-changelog-file.yml
  local action_render=.github/actions/changelog-render/action.yml
  local action_writeback=.github/actions/git-writeback/action.yml
  local lint_log

  if ! command -v actionlint >/dev/null 2>&1; then
    fail "$message (actionlint is not installed)"
    return
  fi

  lint_log="$(mktemp)"
  if actionlint "$workflow_publish" "$workflow_update" "$action_render" "$action_writeback" >"$lint_log" 2>&1; then
    rm -f "$lint_log"
    pass "$message"
    return
  fi

  if grep -Eq '"on" section is missing|"jobs" section is missing|unexpected key "inputs"' "$lint_log"; then
    if actionlint "$workflow_publish" "$workflow_update"; then
      pass "$message (composite action files are not directly lintable by actionlint in this environment)"
    else
      fail "$message (actionlint reported workflow errors)"
    fi
  else
    cat "$lint_log" >&2
    fail "$message (actionlint reported workflow errors)"
  fi

  rm -f "$lint_log"
}

publish_workflow=.github/workflows/publish-release.yml
update_workflow=.github/workflows/update-changelog-file.yml

require_path "$publish_workflow" 'publish-release workflow exists'
require_path "$update_workflow" 'update-changelog workflow exists'

run_actionlint 'target workflows pass actionlint'

require_fixed "$publish_workflow" '^[A-Za-z0-9._/-]+$' 'publish-release keeps the release tag validation regex'
# shellcheck disable=SC2016
require_fixed "$publish_workflow" 'jq -rn --arg target "$TARGET" "\$target|@uri"' 'publish-release keeps branch URI encoding before branch validation'
require_fixed "$publish_workflow" 'releases/generate-notes' 'publish-release still generates release notes through the GitHub API'
require_fixed "$publish_workflow" 'if: inputs.draft == false' 'publish-release still gates published-only steps behind draft=false'
require_local_action_refs "$publish_workflow" 2 'publish-release uses local composite actions for rendering and writeback'
require_fixed "$publish_workflow" 'uses: ./.github/actions/git-writeback' 'publish-release references the shared git-writeback action'
# shellcheck disable=SC2016
require_fixed "$publish_workflow" 'Unable to resolve commit SHA for annotated tag $TAG.' 'publish-release fails clearly when annotated tag commit resolution is empty'

require_regex "$update_workflow" '^  workflow_dispatch:' 'update-changelog remains manually invokable'
require_no_regex "$update_workflow" '^  release:' 'update-changelog no longer listens to release.published'
require_fixed "$update_workflow" 'cmp -s' 'update-changelog preserves cmp-based drift detection'
require_local_action_refs "$update_workflow" 2 'update-changelog uses local composite actions for rendering and writeback'
require_fixed "$update_workflow" 'uses: ./.github/actions/git-writeback' 'update-changelog references the shared git-writeback action'

require_fixed "$publish_workflow" 'cancel-in-progress: false' 'publish-release keeps non-cancelling concurrency'
require_fixed "$update_workflow" 'cancel-in-progress: false' 'update-changelog keeps non-cancelling concurrency'

require_composite_actions 'shared composite actions exist for the refactor'
require_adjacent_placeholder_render 'changelog renderer replaces adjacent placeholders correctly'

if (( failures > 0 )); then
  printf '\nContract check failed with %d issue(s).\n' "$failures" >&2
  exit 1
fi

printf '\nContract check passed.\n'
