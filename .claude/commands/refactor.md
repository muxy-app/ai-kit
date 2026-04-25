---
description: Plan a focused refactor of a specific file or area (e.g. CodeEditorRepresentable.swift). Plan-only; does not implement until you confirm.
---

Delegate to the `refactor-planner` agent.

Target: $ARGUMENTS

The planner:
1. Reads the target and its dependents.
2. Identifies natural seams.
3. Proposes 3-6 extractable units, each shippable as an independent PR (matching the team's pattern from PRs #181-184).
4. Asks via AskUserQuestion which seams to take.

After approval, the planner hands off to the orchestrator to execute the chosen extractions.

Do not commit. Do not push. Each PR must leave the project building.
