---
description: Review the current branch's changes against main for code quality, correctness, and Muxy-specific concerns
---

Review the current branch's changes against `main` for code quality and correctness, with special attention to the fact that **Muxy is a shipped macOS app with many installs** — breaking changes, persisted-data migrations, and regressions in libghostty integration are high-impact.

## Process

1. Run `git diff main...HEAD --stat` then `git diff main...HEAD` to scope and read all changes. If there are no commits ahead of `main`, fall back to `git diff` (staged + unstaged).
2. Read every changed file **fully** (not just diff hunks). This is mandatory — review reasons must cite real surrounding context, not just the patch. State explicitly in the Summary which files were read in full.
3. For each category below, list findings as `path/to/File.swift:line — issue (why it matters, suggested fix)`. If a category is clean, say so in one line and move on.
4. **Always produce recommendations before merging.** Even an "Approve" verdict must include a non-empty **Top recommendations** list — improvements, follow-ups, or test gaps to address before merge. Only return an empty list if you can justify, per category, that there is genuinely nothing to improve. Default to surfacing nits rather than silently approving.
5. End with a **Verdict** (Approve / Approve with nits / Request changes) and the **Top recommendations** list (at least 3 items unless the PR is truly trivial), ordered by severity.
6. If you find issues unrelated to the PR's stated purpose, put them in a separate **Out-of-scope findings** section — per `CLAUDE.md`, these are reported but not auto-fixed.

Do NOT apply fixes. Per `CLAUDE.md`: "Apply review recommendations only after user's confirmation." After presenting the review, tell the user they can run `/address-review` to apply the confirmed findings (the `review-applier` agent routes each item to the right specialist and stops at "ready to commit" as a `review` commit).

## Review categories

**Shipped-app safety (highest priority — Muxy has many installs)**

- Breaking changes to persisted JSON shapes: `~/Library/Application Support/Muxy/projects.json`, `CommandShortcutStore`, any new `Codable` stores. Adding non-optional fields without defaults, renaming keys, or changing enum raw values silently corrupts existing users' data.
- Missing `Codable` migration / defaulting strategy for new fields (use optionals or `decodeIfPresent` with sensible defaults).
- Changes to file paths, bundle identifiers, `UserDefaults` keys, or Keychain item names that would orphan existing user state.
- Default keyboard shortcut changes that override a user's customization without migration.
- Ghostty config (`~/.config/ghostty/config`) handling — never overwrite, never delete.

**libghostty / GhosttyKit integration**

- Surface lifecycle: `ghostty_surface_t` created on window-attach, destroyed on detach. Look for leaks, double-frees, or use-after-free across tab/split close.
- `GhosttyService` is a singleton — one `ghostty_app_t` per process. New code must not create a second app instance.
- 120 fps tick timer and Metal layer interactions must stay on the main thread.
- C interop: pointer ownership, `Unmanaged`, `withCString`, callback context pointers — any mistake here crashes shipped users.
- Clipboard callbacks routed through `GhosttyService` — don't bypass.

**NSViewRepresentable correctness** (per `CLAUDE.md` pitfalls)

- `makeNSView` must return a fresh view, never a cached/reused one.
- Views that need to survive tab switches must stay mounted (ZStack + opacity), not conditionally removed.
- `updateNSView` must be idempotent and cheap.
- Flag any new view registry / cache that could re-introduce the blank-view bug.

**Security**

- Command/path injection in any shell-out, `Process` invocation, or path passed to libghostty.
- Secrets, tokens, API keys hardcoded.
- Unsafe deserialization (`JSONDecoder` on untrusted input without validation).
- Sandbox / entitlement implications of new capabilities.
- File operations using user-supplied paths without normalization.

**Maintainability** (per `CLAUDE.md`: "No commenting allowed")

- Comments added to source files — should be removed; code must be self-explanatory.
- Naming that requires a comment to understand.
- Tight coupling between `AppState`, `ProjectStore`, view layer, and `GhosttyService`.
- Duplicated logic that belongs in a shared service.
- Dead code, unused imports, unused `@State`/`@Observable` properties.
- `docs/architecture.md` out of date relative to architectural changes in this PR (per `CLAUDE.md`, it "must always be up to date").

**Scalability & performance**

- Work on the main thread that should be off it (file I/O, JSON encode/decode of large stores, sync network).
- Unbounded growth: tab/split trees, observer arrays, `NotificationCenter` subscriptions never removed.
- `@Observable` properties that trigger excessive view invalidation in hot paths (terminal render loop, tick timer).
- Retain cycles in closures captured by long-lived objects (`GhosttyService`, `AppState`, NSView delegates).
- Timer / `DispatchSourceTimer` / `Combine` subscriptions not cancelled on deinit.

**Clean code & architecture**

- Functions doing too many things; extract pure helpers.
- Deep nesting — prefer early returns (per `CLAUDE.md`).
- Magic numbers/strings (frame rates, key codes, file names) — hoist to named constants.
- Patterns inconsistent with neighbouring files (SwiftUI vs AppKit boundaries, `@Observable` vs `ObservableObject`, file layout).
- "Hacky" workarounds — flag and suggest a root-cause fix (per `CLAUDE.md`: "Don't patch symptoms, fix root causes").
- Native-only rule: no third-party deps where Apple frameworks suffice.

**Tests & tooling**

- Testable logic without tests (per `CLAUDE.md`: "If the feature is testable, then you must write tests").
- `scripts/checks.sh --fix` likely not run — flag any swiftformat/swiftlint violations visible in the diff.
- PR description over 3 lines (per `CLAUDE.md`).
- Missing screenshot/recording for UI changes (per `CLAUDE.md`).

## Output format

```
## Summary
<1–2 lines: what the PR does, overall impression>

## Shipped-app safety
- ...

## libghostty integration
- ...

## NSViewRepresentable
- ...

## Security
- ...

## Maintainability
- ...

## Scalability & performance
- ...

## Clean code & architecture
- ...

## Tests & tooling
- ...

## Out-of-scope findings
- ...

## Top recommendations (must not be empty before merging)
1. ...
2. ...
3. ...

## Verdict
<Approve | Approve with nits | Request changes> — <one-line reason>

## Next step
Ask the user whether to apply the recommendations above.
```
