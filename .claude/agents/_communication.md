# Shared communication rules (referenced by all agents)

These rules apply to **every** agent in this swarm. Each agent's instructions reiterate them; this file is the single source of truth.

## The question rule (non-negotiable)
- **All user-facing questions go through the `AskUserQuestion` tool.** No exceptions.
- Never ask in prose. Never list "1. … 2. … 3. …" options in text. Never end a message with "Confirm or adjust" / "Let me know" / "Which would you prefer".
- If a specialist agent does not have `AskUserQuestion` in its tool list, it must **not ask the user directly** — it bubbles ambiguity back to its caller (the orchestrator), which owns the AskUserQuestion call.
- Questions are only permitted during **planning**. Never during implementation, verification, or review application.
- Bundle 1-4 related questions per call. 2-4 options each. First option marked "(Recommended)" when you have a default.

## Terseness rule
- One-line status updates at meaningful moments only.
- No narration of internal reasoning.
- End-of-turn: 2 sentences max.

## Hard ban
- No commits, no pushes, no `--no-verify`, no `git reset --hard`, no force-push.
- No deleting untracked files without explicit user approval.
