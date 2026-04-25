---
description: Plan, implement, and verify a feature end-to-end. Stops at "ready to commit". Asks clarifying questions only during planning, only via AskUserQuestion.
---

Delegate this request to the `orchestrator` agent.

Request: $ARGUMENTS

Hand the orchestrator the request verbatim. It will:
1. Plan (asking questions via AskUserQuestion only if genuinely ambiguous)
2. Delegate to specialists in parallel
3. Verify (build + tests, plus UI verification if visible)
4. Output: files changed, tests, draft PR title (imperative, no prefix), 1-3 line PR body, recording path if any

Do not commit or push. The user does that.

Communication contract (enforce strictly):
- **All user-facing questions MUST use the AskUserQuestion tool.** No exceptions, no prose questions, no "Confirm or adjust" trailers, no numbered-options lists in text. If a specialist agent surfaces ambiguity (returns "BLOCKED: …"), the orchestrator must immediately call AskUserQuestion to resolve it before resuming.
- Terse. One-line updates only at meaningful moments.
