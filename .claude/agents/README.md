# Muxy agent swarm

Orchestrator-driven swarm tuned to Muxy's actual architecture (deep-analyzed from source + commit history + PRs, not just docs).

## Entry points (slash commands)

| Command | Use when | Routes to |
|---|---|---|
| `/ship <description>` | Feature or non-trivial change. Plans, implements, tests, verifies. | `orchestrator` |
| `/fix <description>` | Small fix (<50 LOC, single concern). Skips planning. | `orchestrator` (quick mode) |
| `/review` | Review current branch vs main. Read-only critique. | `code-reviewer` |
| `/address-review` | Apply the confirmed review. Stops at "ready to commit". | `review-applier` |
| `/refactor <target>` | Plan a focused extraction of a monolith. | `refactor-planner` |

All commands stop at "ready to commit". You commit and push.

## Specialist agents (delegated to by orchestrator/applier)

**Domain owners** (one per architectural cluster):
- `terminal-lifecycle` — libghostty, NSView surface lifecycle, C interop
- `vcs-git` — Git ops, parsers, VCS UI, PR state machine
- `state-reducer` — AppState, WorkspaceReducer, dispatch
- `swiftui-views` — Views (non-VCS/Markdown/Editor), layout, components
- `editor-syntax` — CodeEditor, syntax tokenizer/highlighter, grammars
- `markdown-preview` — Markdown rendering, anchor sync, Mermaid
- `remote-mobile` — MuxyServer + MuxyMobile + MuxyShared, iOS protocol
- `ai-usage` — Provider parsers, OAuth, token reading
- `notifications` — OSC → store → UI → sound (cross-cutting)
- `persistence` — CodableFileStore, schema migrations

**Cross-cutting helpers**:
- `test-writer` — Swift Testing, fixture-driven
- `build-verifier` — `scripts/checks.sh` + `swift test`
- `ui-verifier` — launches app, captures recordings
- `code-reviewer` — read-only critique against CLAUDE.md
- `review-applier` — applies confirmed reviews
- `refactor-planner` — plans monolith extractions

## How it works

```
/ship "add markdown table-of-contents"
  └─ orchestrator
      ├─ (plans, asks questions if needed)
      ├─ markdown-preview (anchor logic)
      ├─ swiftui-views (UI surface)        ← parallel
      ├─ test-writer (fixture tests)       ← parallel
      ├─ build-verifier
      └─ ui-verifier
        → "Files: X, Y, Z. Tests: 3 added. PR: 'Add markdown TOC'. Recording: /tmp/..."
```

```
/review
  └─ code-reviewer
      → critique with path:line citations

(you confirm or edit)

/address-review
  └─ review-applier
      ├─ routes each item to the right specialist (parallel)
      ├─ build-verifier
      → "Applied 4. Skipped 1 (out of scope). ✅ Ready to commit as 'review'."
```

## Hard rules baked into every agent

- No commits, no pushes, no `--no-verify`.
- CLAUDE.md compliance: no comments, no cached NSViews, off-main I/O, security first.
- Schema changes require defaults or a migration.
- libghostty surface lifecycle is paired and audited.
- Communication is terse — no narration, AskUserQuestion only for genuine ambiguity, only during planning.

## Updating

Files in `.claude/agents/*.md` are plain Markdown with YAML frontmatter. Edit any agent to adjust scope or rules. Edit `.claude/commands/*.md` to adjust how commands route.
