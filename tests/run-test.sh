#!/usr/bin/env bash
# Quick validation: check that training files exist and are well-formed.
# Run: bash tests/run-test.sh

set -euo pipefail

PASS=0
FAIL=0
WARN=0

check() {
  local desc="$1" result="$2"
  if [ "$result" = "pass" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  elif [ "$result" = "warn" ]; then
    echo "  WARN: $desc"
    WARN=$((WARN + 1))
  else
    echo "  FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Training Validation ==="
echo ""

# Check 1: CLAUDE.md exists
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  check "~/.claude/CLAUDE.md exists" "pass"
elif [ -f "CLAUDE.md" ]; then
  check "CLAUDE.md exists (project-level)" "pass"
else
  check "CLAUDE.md not found" "fail"
fi

# Check 2: CLAUDE.md has content
claude_file="${HOME}/.claude/CLAUDE.md"
[ ! -f "$claude_file" ] && claude_file="CLAUDE.md"
if [ -f "$claude_file" ]; then
  lines=$(wc -l < "$claude_file")
  if [ "$lines" -gt 20 ]; then
    check "CLAUDE.md has sufficient content ($lines lines)" "pass"
  else
    check "CLAUDE.md is too short ($lines lines) — may not be effective" "warn"
  fi
fi

# Check 3: Key rules present
if [ -f "$claude_file" ]; then
  if grep -qi "YAGNI\|over-?engineer\|minimal\|简洁\|最简" "$claude_file" 2>/dev/null; then
    check "Anti-over-engineering rules found" "pass"
  else
    check "No anti-over-engineering rules" "warn"
  fi

  if grep -qi "parameterized\|参数化\|injection\|注入" "$claude_file" 2>/dev/null; then
    check "Security rules found" "pass"
  else
    check "No security rules" "warn"
  fi

  if grep -qi "plan.*first\|计划先行\|先.*计划\|confirm\|确认" "$claude_file" 2>/dev/null; then
    check "Plan-first rules found" "pass"
  else
    check "No plan-first rules" "warn"
  fi
fi

# Check 4: Hooks exist (if .claude/settings.json exists)
if [ -f ".claude/settings.json" ]; then
  check ".claude/settings.json exists" "pass"
  if command -v jq >/dev/null 2>&1; then
    hook_count=$(jq '[.hooks | to_entries[].value | length] | add // 0' .claude/settings.json 2>/dev/null || echo 0)
    if [ "$hook_count" -gt 0 ]; then
      check "Hooks configured: $hook_count" "pass"
    else
      check "No hooks configured" "warn"
    fi

    # Check for security
    mode=$(jq -r '.permissions.defaultMode // "unknown"' .claude/settings.json 2>/dev/null || echo "unknown")
    if [ "$mode" = "bypassPermissions" ]; then
      check "DANGER: permissions set to bypassPermissions" "fail"
    elif [ "$mode" = "askEveryTime" ]; then
      check "Permissions: askEveryTime (safe)" "pass"
    else
      check "Permissions mode: $mode" "warn"
    fi
  fi
fi

# Check 5: jq available
if command -v jq >/dev/null 2>&1; then
  check "jq installed" "pass"
else
  check "jq not installed (some hooks need it)" "warn"
fi

echo ""
echo "=== Results: $PASS pass, $FAIL fail, $WARN warn ==="

if [ "$FAIL" -gt 0 ]; then
  echo "Some checks failed. See above for details."
  exit 1
elif [ "$WARN" -gt 0 ]; then
  echo "Some warnings. Review above for potential improvements."
  exit 0
else
  echo "All checks passed."
  exit 0
fi
