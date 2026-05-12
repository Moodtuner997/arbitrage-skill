# Spec / story integrations

DEEP mode is especially valuable on structured documents that drive downstream code:

- Agile / BMAD stories
- RFCs
- ADRs (Architecture Decision Records)
- System-prompt specifications
- Product PRDs

## What arbitrage looks for in these files

1. **Heuristic acceptance criteria** — ACs resting on an unvalidated hypothesis ("the user always wants X", "in 90% of cases Y"). Classify as GRAY ZONE.
2. **Absolute keywords** — `always`, `never`, `every`, `all`, `none`, `must always`. Flag systematically as potential gray zones.
3. **Downstream tech debt** — a heuristic in a story → impact on DB schema, API contract, system prompt. Project at 3–6 months.

## Output recommendations

For each heuristic detected in a spec/story:

- Propose a **falsifiable validation criterion** (a concrete test that could prove the heuristic wrong)
- Propose a **risk line** in the document (`accepted-risk` + justification)
- If projected tech debt is critical: suggest splitting the story / spec

## Integration with story-based workflows (BMAD-style)

If you use a story-driven workflow:

1. Run `/arbitrage deep <story-file>` before validating the story
2. Add detected heuristics as testable ACs or as documented accepted-risks
3. If 2+ critical heuristics are found, consider splitting the story

The skill acts as a counterweight before a story is considered "ready for dev".

## File-type detection

You can wire the skill to auto-upgrade to DEEP for paths or extensions that signal a spec file (e.g. `*.story.md`, `*.spec.md`, `adr/*.md`, `rfc/*.md`). Implementation is left to the host project — keep it explicit and visible.
