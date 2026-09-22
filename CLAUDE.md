# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Public MIT Claude Code skill `/arbitrage`: flags when an unvalidated heuristic ("often true") is being treated as an algorithm ("always true") in code, schemas, prompts, specs or architecture decisions. Pure prompt skill — no build, no runtime beyond one toggle script.

## Commands

```bash
# install = clone into the skills dir (Claude Code loads ~/.claude/skills/<name>/SKILL.md)
git clone <repo-url> ~/.claude/skills/arbitrage      # or copy the folder; restart the Claude Code session

# background mode toggle (sentinel file scripts/.active, gitignored)
bash scripts/arbitrage-toggle.sh on|off|status

shellcheck scripts/arbitrage-toggle.sh   # lint
```

No tests. Manual check: open a Claude Code session with the skill installed and run `/arbitrage`, `/arbitrage <text|file>`, `/arbitrage deep <file>`.

## Architecture

- `SKILL.md` — frontmatter (`name: arbitrage`, trigger phrases in `description`, `allowed-tools: Read, Write, Grep, Glob, AskUserQuestion, Agent`) + the whole behaviour. Three depth levels: QUICK (2-3 line inline callout), STANDARD (full `=== ARBITRAGE ===` block: HEURISTIC / ALGORITHMIC / GRAY ZONES + post-analysis workflow), DEEP (adds 3-6 month impact projection, validation tests, decision-log entry; auto-upgrade for spec/story files).
- Post-arbitrage workflow appends to `arbitrage-log.md` (project root or `~/.claude/`) and keeps an `arbitrated` list so background mode does not re-flag accepted risks.
- `scripts/arbitrage-toggle.sh` only creates/removes `scripts/.active` next to itself. Injection is done by a separate `UserPromptSubmit` hook (`arbitrage-inject.sh`, shown in README, not shipped) that exits 0 when the sentinel is absent and otherwise prints the QUICK reminder. Sentinel absent = zero cost.
- `references/examples.md` — eight worked callouts by domain (product, code, DB, prompt engineering) plus two "no arbitrage needed" cases and a template for writing new ones. `references/integrations.md` — running DEEP on stories/RFCs/ADRs/PRDs (absolute keywords, heuristic ACs, downstream tech debt).

## Conventions and gotchas

- Keep `SKILL.md` short: the README explicitly states skills work best when the model holds the whole prompt in working memory. Put new material in `references/`, not in `SKILL.md`.
- Public repo, user-agnostic: no personal paths, project names or private context.
- README is bilingual with mirrored sections (`## English` then `## Français`); any change to usage, output format, install or background mode must be applied to both halves. The French half is written without accents on purpose (plain ASCII); keep that style. `SKILL.md` and `references/` are English only.
- The output block format in `SKILL.md` and both README halves must stay identical (`=== ARBITRAGE [STANDARD|DEEP] ===` ... `=== ===`).
- Contribution scope per README: new examples, `SKILL.md` translations, integration recipes. It is intentionally single-purpose — do not widen it.

<!-- chaine-release -->
## Versions and going live (fleet rule, 2026-09-22)

The rule itself is in the global `CLAUDE.md`, section "Mise en ligne par release PR".
What is specific to this repo:

- **Commits are conventional commits**, refused at write time by the `commit-msg`
  hook in `.git/hooks/`. The prefix is what release-please reads to compute the
  version and write the changelog: a message off-format is a change missing from
  the release notes.
- **Version robot:** release-please, release type `simple`, config
  `release-please-config.json` + `.release-please-manifest.json` at the root,
  starting version `0.0.0`. It runs **on the laptop**, not as a GitHub Action:
  Actions are billing-blocked on private repos since 2026-09-22 (runs fail in 3 s
  with zero steps).
- **One command**, from the workspace root: `bash scripts/release.sh arbitrage-skill`.
  It keeps the release PR up to date on `main`; once that PR is merged, the
  same command tags, publishes the GitHub release, and stops there: tag and changelog only, nothing is deployed.
- **Nothing reaches users until the release PR is merged**, and it is merged only
  after the manual test run. That check is what opens the door, never a blind push.
- **Where the versions live:** https://github.com/Moodtuner997/arbitrage-skill/releases
