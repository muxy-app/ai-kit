# Muxy AI Kit

Optional agent swarm configuration for the [Muxy](https://github.com/muxy-app/muxy) app. It ships a curated set of slash commands you can drop into your Muxy checkout for either [Claude Code](https://claude.com/claude-code) (`.claude/commands`) or [opencode](https://opencode.ai) (`.opencode/command`).

## Install

Run this from the **root of your Muxy folder**. You'll be prompted to choose Claude or opencode:

```bash
curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash
```

Or pass the target directly:

```bash
curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash -s -- claude
curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash -s -- opencode
```

The installer **replaces** the existing commands folder for the chosen target.

## What it does

1. Downloads the `main` branch tarball of `muxy-app/ai-kit` into a temp dir.
2. Replaces `.claude/commands/` (Claude) or `.opencode/command/` (opencode) with the kit's `commands/`.

## Uninstall

```bash
rm -rf .claude/commands     # or .opencode/command
```
