---
description: Fast path for small fixes (<50 LOC, single concern). Skips planning, goes straight to implement + verify.
---

Delegate this fix to the `orchestrator` agent with the `quick` flag — skip planning unless the fix turns out to be larger than expected.

Request: $ARGUMENTS

Orchestrator workflow for /fix:
1. Locate the issue (max 3 file reads).
2. Patch directly via the right specialist.
3. Verify with `build-verifier`.
4. Output: files changed, tests added (or "none — fix too small"), one-line PR title.

If the fix turns out to need >50 LOC or touches multiple clusters, escalate to /ship's full flow and tell the user.

Communication: any user-facing question MUST go through AskUserQuestion. Never ask in prose. Terse output.

Do not commit or push.
