# arbitrage

[**English**](#english) · [**Français**](#français)

A Claude Code skill that flags when an unvalidated hypothesis is being treated as an absolute rule — in code, schemas, prompts, or architecture decisions.

Un skill Claude Code qui detecte les hypotheses non validees traitees comme des regles absolues — dans le code, les schemas, les prompts ou les decisions d'architecture.

---

## English

### What it does

In natural language as in code, we often treat a frequent observation as a universal law. That slippage produces fragile systems. This skill spots it.

It distinguishes:

- **Heuristic** — empirical rule, often true, based on observation or intuition.
- **Algorithmic** — closed contract, deterministic, precise expectation.
- **Gray zone** — presented as algorithmic but resting on an unvetted heuristic premise.

When you write `if language == "fr": apply_formal_tone()`, that's a bet (Quebec, francophone Africa, French startups have different registers). The skill calls it out so you decide on purpose, not by accident.

### Usage

Three depth levels:

| Trigger | Level | Output |
|---|---|---|
| Background flag, inline detection | **QUICK** | 2–3 line callout inside the normal answer |
| `/arbitrage` or `/arbitrage <text\|file>` | **STANDARD** | Full classification block + post-analysis workflow |
| `/arbitrage deep <file>` | **DEEP** | Standard block + 3–6 month impact projection + validation tests |

Trigger phrases the skill recognises:

- `/arbitrage`
- "check my assumptions"
- "is this always true"
- "am I oversimplifying"
- "review this spec/prompt/schema for logic"
- "is this assumption safe"

### Install

Claude Code looks for skills in `~/.claude/skills/<skill-name>/SKILL.md`.

```bash
git clone https://github.com/Moodtuner997/arbitrage-skill.git ~/.claude/skills/arbitrage
```

Or copy the folder manually into `~/.claude/skills/arbitrage/`. Restart your Claude Code session.

### Optional: background mode

Background mode injects a brief QUICK reminder before every prompt while active.

```bash
bash scripts/arbitrage-toggle.sh on      # enable
bash scripts/arbitrage-toggle.sh off     # disable
bash scripts/arbitrage-toggle.sh status  # current state
```

The toggle drops a sentinel file (`.active`) next to the script. To wire it into Claude Code's prompt pipeline, add a `UserPromptSubmit` hook that reads the sentinel and injects the QUICK reminder. See [Background mode](#background-mode) below.

### Background mode

The toggle alone does nothing — it just flips a flag. The actual injection is done by a `UserPromptSubmit` hook in your Claude Code settings.

Minimal hook script (`arbitrage-inject.sh`):

```bash
#!/usr/bin/env bash
ACTIVE_FILE="$HOME/.claude/skills/arbitrage/scripts/.active"
[ -f "$ACTIVE_FILE" ] || exit 0
cat <<'EOF'
[arbitrage:on] Apply QUICK arbitrage rules: silently scan for heuristics treated as algorithms. If found, drop a 2–3 line callout inside your normal answer. If nothing — stay silent.
EOF
```

Register it in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      { "command": "bash ~/.claude/skills/arbitrage/scripts/arbitrage-inject.sh" }
    ]
  }
}
```

Sentinel absent = zero cost (the script exits immediately).

### Output format

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

### Examples

See [`references/examples.md`](references/examples.md) for eight concrete cases (product, code, DB, prompt engineering).

### Origin

The concept came from reflecting on the linguistics of bullshit (Orwell, *Politics and the English Language*, jargon and wooden language). The pattern is the same in code and in speech: treating a frequent observation as a universal law produces brittle systems.

The skill was extracted from a private workflow and generalised for public use.

### License

MIT — see [`LICENSE`](LICENSE).

### Contributing

This is intentionally a tiny, single-purpose skill. PRs welcome for:

- New examples in `references/examples.md`
- Translations of `SKILL.md`
- Integration recipes for other tooling

Keep `SKILL.md` short — Claude Code skills work best when the model can hold the whole prompt in working memory.

---

## Français

### Ce que ça fait

En langue naturelle comme en code, on traite souvent une observation frequente comme une loi universelle. Ce glissement produit des systemes fragiles. Ce skill le repere.

Il distingue :

- **Heuristique** — regle empirique, souvent vraie, basee sur l'observation ou l'intuition.
- **Algorithmique** — contrat ferme, deterministe, attendu precis.
- **Zone grise** — presentee comme algorithmique mais reposant sur une premisse heuristique non arbitree.

Quand tu ecris `if language == "fr": apply_formal_tone()`, c'est un pari (Quebec, Afrique francophone, startups FR ont des registres differents). Le skill le signale pour que tu decides expres, pas par accident.

### Usage

Trois niveaux de profondeur :

| Declencheur | Niveau | Sortie |
|---|---|---|
| Flag en background, detection inline | **QUICK** | Encart 2–3 lignes dans la reponse normale |
| `/arbitrage` ou `/arbitrage <texte\|fichier>` | **STANDARD** | Bloc complet de classification + workflow post-analyse |
| `/arbitrage deep <fichier>` | **DEEP** | Bloc standard + projection d'impact 3–6 mois + tests de validation |

Phrases declencheurs reconnues :

- `/arbitrage`
- "check my assumptions"
- "is this always true"
- "am I oversimplifying"
- "review this spec/prompt/schema for logic"
- "is this assumption safe"

### Installation

Claude Code cherche les skills dans `~/.claude/skills/<nom-du-skill>/SKILL.md`.

```bash
git clone https://github.com/Moodtuner997/arbitrage-skill.git ~/.claude/skills/arbitrage
```

Ou copier le dossier manuellement dans `~/.claude/skills/arbitrage/`. Relancer la session Claude Code.

### Optionnel : mode background

Le mode background injecte un rappel QUICK bref avant chaque prompt tant qu'il est actif.

```bash
bash scripts/arbitrage-toggle.sh on      # activer
bash scripts/arbitrage-toggle.sh off     # desactiver
bash scripts/arbitrage-toggle.sh status  # etat courant
```

Le toggle pose un fichier sentinelle (`.active`) a cote du script. Pour le brancher dans le pipeline de prompts de Claude Code, ajouter un hook `UserPromptSubmit` qui lit la sentinelle et injecte le rappel QUICK. Voir le script ci-dessus dans la section English.

### Format de sortie

```
=== ARBITRAGE [STANDARD|DEEP] ===

HEURISTIQUE (a tester / challenger)
- <element> — Pourquoi : <explication>
  Impact si encode en algo : <consequence concrete, cas edge>
  Suggestion : <valider par test/data, ou assumer comme reversible>

ALGORITHMIQUE (contrat ferme, OK)
- <element> — Contrat clair, pas d'ambiguite

ZONES GRISES (a arbitrer AVANT de coder)
- <element> — Presente comme : <croyance>. Realite : <ce qui pourrait arriver>
  Question d'arbitrage : <question concrete a trancher>

[DEEP uniquement]
IMPACT 3–6 MOIS
- Schema DB : <impact>
- Prompt system : <impact>
- Logique metier : <impact>
- Dette technique : <impact>

TESTS DE VALIDATION SUGGERES
- <test falsifiable par heuristique>

=== ===
```

### Exemples

Voir [`references/examples.md`](references/examples.md) pour huit cas concrets (produit, code, DB, prompt engineering).

### Origine

Le concept vient d'une reflexion sur la linguistique du bullshit (Orwell, *Politics and the English Language*, jargon et langue de bois). Le pattern est le meme en code et en langage : traiter une observation frequente comme une loi universelle produit des systemes fragiles.

Le skill a ete extrait d'un workflow prive puis generalise pour usage public.

### Licence

MIT — voir [`LICENSE`](LICENSE).

### Contribuer

Skill volontairement petit et mono-objectif. PRs bienvenues pour :

- Nouveaux exemples dans `references/examples.md`
- Traductions de `SKILL.md`
- Recettes d'integration pour d'autres outils

Garder `SKILL.md` court — les skills Claude Code marchent mieux quand le modele tient tout le prompt en memoire de travail.
