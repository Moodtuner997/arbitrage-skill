# CLAUDE.md — arbitrage-skill

Public MIT Claude Code skill `/arbitrage`: flags when an unvalidated heuristic ("often true") is being treated as an algorithm ("always true") in code, schemas, prompts, specs or architecture decisions. Pure prompt skill — no build, no runtime beyond one toggle script.

## Before any action

- Public repo: everything committed is world-readable, history included. No personal paths, hosts, emails, project names or private context, in files or in commit messages. Private notes stay in `IDEES.md` (gitignored).
- State lives in the issues and releases; there is no HANDOFF. Check reality first: `git fetch --prune`, `git status`, `git log -5 origin/main`.

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
- README is bilingual with mirrored sections (`## English` then `## Français`); any change to usage, output format, install or background mode must be applied to both halves. The French body is written without accents (a few headings and dashes are not ASCII); keep that style. `SKILL.md` and `references/` are English only.
- The output block format in `SKILL.md` and both README halves must stay identical (`=== ARBITRAGE [STANDARD|DEEP] ===` ... `=== ===`).
- Contribution scope per README: new examples, `SKILL.md` translations, integration recipes. It is intentionally single-purpose — do not widen it.

<!-- chaine-release -->
## Release

Single branch `main`. Conventional Commits (`<type>(<scope>): <description>`): release-please (type `simple`) builds the version and changelog from them. `.github/workflows/release.yml` runs on every push to `main` on a GitHub-hosted runner (never a self-hosted one on a public repo), merges the release PR itself and stops at tag + changelog; nothing is deployed. Versions: https://github.com/Moodtuner997/arbitrage-skill/releases

## Mistakes not to repeat

- Do not keep private ideas in a tracked file: `IDEES.md` had to be gitignored (bd64bc3, 2026-10-12).
- Do not run a token-backed review workflow on this public repo: an automated review was first restricted to the owner, then removed (9ed3036, bb1f34f, 2026-10-01/02).
- Do not let the release PR show a failing CI status: fixed in fed1aeb (2026-10-06).
