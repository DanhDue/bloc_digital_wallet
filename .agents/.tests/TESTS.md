# `.agents/.tests/` — Test Convention

## Purpose
Lightweight local-CI for AI-modified tools. When the AI modifies any `.agents/skills/<skill>/`
or `.agents/.shared/<tool>/`, it runs the relevant test suite before claiming work is done.

## Directory Layout

```
.agents/.tests/
├── run_tests.py                     ← entry point
├── TESTS.md                         ← this file
└── <skill-name>/
    ├── test_search.py               ← one file per concern
    └── test_data_integrity.py
```

## Trigger Rules (when AI auto-runs)

| Change made to | Tests to run |
|----------------|-------------|
| `.agents/.shared/<tool>/` | `.agents/.tests/<tool>/` |
| `.agents/skills/<skill>/SKILL.md` | `.agents/.tests/<skill>/` (if exists) |
| Any CSV in a data folder | The skill that owns that folder |
| `.agents/.tests/run_tests.py` | `--all` |

## Running

```bash
python3 .agents/.tests/run_tests.py <skill-name>
python3 .agents/.tests/run_tests.py --all
```

## Writing a New Test File

### Required contract
- Filename: `test_*.py`
- Standalone Python 3 script (stdlib only — no pytest/unittest required)
- Exit 0 = all pass, exit 1 = any fail
- Print `✅ label` or `❌ label` for each test case

### Minimal template

```python
#!/usr/bin/env python3
"""Tests for <skill-name>"""
import subprocess, sys
from pathlib import Path

# Project root: 3 levels up (.agents/.tests/<skill>/test_*.py)
BASE = str(Path(__file__).resolve().parents[3])
passed, failed = [], []


def check(label, output, expected_kw, returncode=0):
    ok_code = output.returncode == returncode
    ok_kw = expected_kw.lower() in (output.stdout + output.stderr).lower() if expected_kw else True
    if ok_code and ok_kw:
        passed.append(label)
        print(f"  ✅ {label}")
    else:
        failed.append(label)
        print(f"  ❌ {label}")
        if not ok_kw:
            print(f"     → expected keyword: '{expected_kw}'")
        print(f"     → stdout[:300]: {(output.stdout + output.stderr)[:300]!r}")


# ─── GROUPS ───────────────────────────────────────────────
print("\n📍 GROUP 1: <Group Name>")
# r = subprocess.run(["python3", "path/to/script.py", "query", "--flag", "value"],
#                    capture_output=True, text=True, cwd=BASE)
# check("test label", r, "expected keyword in output")

# ─── FINAL REPORT ─────────────────────────────────────────
total = len(passed) + len(failed)
pct = int(100 * len(passed) / total) if total else 0
print(f"\n{'═' * 55}")
print(f"  TOTAL: {total}  PASSED: {len(passed)} ({pct}%)  FAILED: {len(failed)}")
if failed:
    print(f"\n  ❌ FAILED TESTS:")
    for f in failed:
        print(f"     - {f}")
print(f"{'═' * 55}")
sys.exit(0 if not failed else 1)
```

### Data integrity pattern

```python
import csv
from pathlib import Path

DATA_DIR = Path(__file__).resolve().parents[3] / ".agents/.shared/<tool>/data"

print("\n📍 DATA INTEGRITY")
for fname, min_rows in {
    "navigation.csv": 20,
    "gestures.csv": 20,
}.items():
    fpath = DATA_DIR / fname
    if not fpath.exists():
        failed.append(f"file exists: {fname}")
        print(f"  ❌ MISSING: {fname}")
        continue
    with open(fpath) as f:
        rows = list(csv.reader(f))
    data_rows = len(rows) - 1
    ok = data_rows >= min_rows
    (passed if ok else failed).append(f"row count: {fname}")
    print(f"  {'✅' if ok else '❌'} {fname}: {data_rows} rows (min {min_rows})")
```

## Skill Mapping Reference

| Test folder | Triggered by |
|-------------|-------------|
| `mobile-uiux-promax/` | `.agents/.shared/mobile-uiux-promax/` · `.agents/skills/mobile-uiux-promax/` |
| *(add new rows here as new skills gain test suites)* | |
