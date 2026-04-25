# Muxy AI Kit

Optional Claude Code agent swarm configuration for the [Muxy](https://github.com/muxy-app/muxy) app. It ships a curated `.claude/` folder (agents + slash commands) that you can drop into your Muxy checkout when you want AI-assisted workflows, and skip otherwise.

## Install

Run this from the **root of your Muxy folder**. It downloads the latest `.claude/` from this repo and replaces the local one (any existing `.claude/` is backed up to `.claude.bak-<timestamp>`).

```bash
curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash
```

Or, if you prefer to inspect before running:

```bash
curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh -o install.sh
less install.sh
bash install.sh
```

## What it does

1. Verifies you're in a git repo (the target Muxy folder).
2. Downloads the `main` branch tarball of `muxy-app/ai-kit` into a temp dir.
3. Backs up your existing `.claude/` to `.claude.bak-<timestamp>` (if present).
4. Copies the kit's `.claude/` into the current directory.

## Uninstall

```bash
rm -rf .claude
```

Restore a backup with `mv .claude.bak-<timestamp> .claude`.
