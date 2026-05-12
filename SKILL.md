---
name: arbitrage
description: "Use when user says /arbitrage, 'check my assumptions', 'is this always true', 'review this spec/prompt/schema for logic', 'is this assumption safe', or 'am I oversimplifying'. Detects when an unvalidated hypothesis is treated as an absolute rule — in code, DB schema, spec, prompt, or architecture decision. Three levels: QUICK (inline), STANDARD (/arbitrage), DEEP (/arbitrage deep)."
allowed-tools: Read, Write, Grep, Glob, AskUserQuestion, Agent
---

# /arbitrage — Heuristic vs Algorithmic guardrail

## Concept

This skill detects when a **heuristic** (empirical rule, observed pattern — often true, not always) is being treated as an **algorithm** (closed contract, deterministic, no exceptions).

That's a bet — are you taking it on purpose or by accident?

---

## Depth levels

### QUICK (background / inline)
- Trigger: background mode active, or obvious heuristic in a live exchange
- Format: 2–3 line callout inside the normal answer
- No post-analysis workflow

### STANDARD (`/arbitrage` or `/arbitrage <text|file>`)
- Trigger: explicit call
- Format: full ARBITRAGE block (classification + impact + suggestions)
- Post-analysis workflow proposed

### DEEP (`/arbitrage deep <file>` or `/arbitrage` on a spec file)
- Trigger: `deep` keyword, or auto-detection on a spec/story file
- Format: full block + 3–6 month impact projection + concrete validation tests + decision-log entry
- Cross-reference: flag heuristics that create downstream tech debt in stories/specs

---

## Mode 1 — Standalone

### Triggers

- `/arbitrage` → analyse the last exchange or current prompt (STANDARD)
- `/arbitrage <text>` → analyse provided text (STANDARD)
- `/arbitrage <file-path>` → read and analyse file (STANDARD, auto-upgrades to DEEP for spec/story files)
- `/arbitrage deep <file-path>` → deep analysis (DEEP)

### Analysis process

1. **Scan** every decision, design choice, business rule, logic condition, format constraint
2. **Classify** each element:
   - **HEURISTIC**: empirical rule, often true, based on observation or intuition
   - **ALGORITHMIC**: closed contract, deterministic, precise expectation
   - **GRAY ZONE**: presented as algorithmic but resting on an unvetted heuristic premise
3. **Evaluate** consequences for each heuristic and gray zone
4. **(DEEP only)** Project impact at 3–6 months + propose validation tests

### Output format — ARBITRAGE block

```
=== ARBITRAGE [STANDARD|DEEP] ===

HEURISTIC (to test / challenge)
- <element> — Why: <explanation>
  Impact if hard-coded as algo: <concrete consequence, edge cases>
  Suggestion: <validate via test/data, or accept as reversible>

ALGORITHMIC (closed contract, OK)
- <element> — Clear contract, no ambiguity

GRAY ZONES (arbitrate BEFORE coding)
- <element> — Presented as: <belief>. Reality: <what could happen>
  Arbitration question: <concrete question to settle>

[DEEP only]
IMPACT 3–6 MONTHS
- DB schema: <impact>
- System prompt: <impact>
- Business logic: <impact>
- Tech debt: <impact>

SUGGESTED VALIDATION TESTS
- <falsifiable test per heuristic>

=== ===
```

---

## Mode 2 — Persistent background (via hook)

### Activation

Toggle ON/OFF via the included script:

```bash
bash scripts/arbitrage-toggle.sh on   # enable
bash scripts/arbitrage-toggle.sh off  # disable
```

Mechanism: a sentinel file (`scripts/.active`) + a `UserPromptSubmit` hook that injects the QUICK reminder into each prompt when the sentinel is present. Sentinel absent = zero cost (no injection).

See the project README for the minimal hook script and `settings.json` wiring.

### QUICK behaviour (default in background)

**Heuristic detected** → inline callout:

```
> **[ARBITRAGE]** "<element>" is a bet, not a contract.
> If hard-coded: <consequence>. <1-line question or suggestion>.
```

**Auto-escalation to STANDARD** when:
- 3+ heuristics in the same exchange
- Architecture decision (schema choice, API structure, system-prompt constraint)
- A spec/story file is open or referenced

**Nothing to flag** → total silence.

### Background rules

1. **Silence by default** — speak ONLY when a heuristic is detected
2. **Inline first** — QUICK is the primary format. STANDARD is for escalation only
3. **No interruption** — the callout slots into the response, doesn't replace content
4. **Progressive pedagogy** — first detection of a pattern: explain. After that: just flag
5. **Respect prior arbitrations** — if the user has explicitly arbitrated or marked `accepted-risk`, don't re-flag

---

## Post-arbitrage workflow (STANDARD and DEEP)

After each analysis, propose:

### 1. Log the decision

Append to `arbitrage-log.md` (project root or `~/.claude/`):

```
## <date> — <element>
- **Classification**: heuristic | gray-zone
- **Context**: <where and why>
- **Decision**: accepted-risk | needs-test | needs-refactor
- **Notes**: <justification>
```

### 2. Generate a validation test

Propose a concrete test (script, DB query, user scenario) to validate or invalidate the heuristic.

### 3. Mark as arbitrated

Add the element to an `arbitrated` list so the background mode doesn't re-flag it.

---

## Examples

See `references/examples.md` for eight concrete cases by domain (product, code, DB, prompt engineering).

## Spec/story integrations

See `references/integrations.md` for tips on running DEEP analysis on structured spec or story files (BMAD, agile stories, RFCs, ADRs).
