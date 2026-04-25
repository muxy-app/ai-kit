---
description: Apply a confirmed code review. Run after /review and after the user has accepted (or edited) the critique.
---

Delegate to the `review-applier` agent.

Input: the most recent review output in this session (or a review the user pastes/edits).

The applier:
1. Parses items into Must fix / Should fix / Suggestions kept.
2. Routes each item to the right specialist agent (parallel where independent).
3. Runs `build-verifier`.
4. Reports: applied count, skipped count (with reason), verification result.

The user then commits with the project's `review` ritual:
```
git commit -m "review"
```

Do not commit. Do not push. Do not expand scope beyond the confirmed review.
