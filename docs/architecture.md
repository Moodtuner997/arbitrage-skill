# Architecture et conventions

Skill Claude Code publique (MIT) `/arbitrage` : elle signale quand une heuristique non validée (« souvent vrai ») est traitée comme un algorithme (« toujours vrai ») dans du code, des schémas, des prompts, des spécifications ou des décisions d'architecture. Skill en prompt pur : pas de build, pas d'exécution hormis un script de bascule.

## Commandes

```bash
# installation = cloner dans le dossier des skills (Claude Code charge ~/.claude/skills/<nom>/SKILL.md)
git clone <repo-url> ~/.claude/skills/arbitrage      # ou copier le dossier ; relancer la session Claude Code

# mode arrière-plan (fichier témoin scripts/.active, ignoré par git)
bash scripts/arbitrage-toggle.sh on|off|status

shellcheck scripts/arbitrage-toggle.sh   # lint
```

Pas de tests. Vérification manuelle : ouvrir une session Claude Code avec la skill installée et lancer `/arbitrage`, `/arbitrage <texte|fichier>`, `/arbitrage deep <fichier>`.

## Architecture

- `SKILL.md` : frontmatter (`name: arbitrage`, phrases déclencheuses dans `description`, `allowed-tools: Read, Write, Grep, Glob, AskUserQuestion, Agent`) et tout le comportement. Trois niveaux de profondeur : QUICK (encadré de 2-3 lignes en ligne), STANDARD (bloc complet `=== ARBITRAGE ===` : HEURISTIC / ALGORITHMIC / GRAY ZONES, plus le flux d'après-analyse), DEEP (ajoute une projection d'impact à 3-6 mois, des tests de validation, une entrée de journal de décision ; montée automatique pour les fichiers de spécification ou de story).
- Le flux d'après-arbitrage ajoute une entrée à `arbitrage-log.md` (racine du projet ou `~/.claude/`) et tient une liste `arbitrated` pour que le mode arrière-plan ne resignale pas un risque accepté.
- `scripts/arbitrage-toggle.sh` crée ou supprime seulement `scripts/.active` à côté de lui. L'injection est faite par un hook `UserPromptSubmit` séparé (`arbitrage-inject.sh`, montré dans le README, non livré) qui sort en 0 si le témoin est absent, sinon affiche le rappel QUICK. Témoin absent = coût nul.
- `references/examples.md` : huit encadrés travaillés par domaine (produit, code, base de données, prompt engineering), deux cas « pas d'arbitrage nécessaire » et un gabarit pour en écrire d'autres. `references/integrations.md` : usage de DEEP sur des stories, RFC, ADR, PRD (mots absolus, critères d'acceptation heuristiques, dette technique en aval).

## Conventions

- `SKILL.md` reste court : le README énonce que les skills fonctionnent mieux quand le modèle tient tout le prompt en mémoire de travail. La matière nouvelle va dans `references/`.
- Le README est bilingue avec des sections en miroir (`## English` puis `## Français`) : tout changement d'usage, de format de sortie, d'installation ou de mode arrière-plan s'applique aux deux moitiés. Le corps français est écrit sans accents (quelques titres et tirets ne sont pas ASCII) ; garder ce style. `SKILL.md` et `references/` sont en anglais seulement.
- Le format du bloc de sortie dans `SKILL.md` et dans les deux moitiés du README doit rester identique (`=== ARBITRAGE [STANDARD|DEEP] ===` … `=== ===`).
- Périmètre de contribution selon le README : nouveaux exemples, traductions de `SKILL.md`, recettes d'intégration. La skill est volontairement mono-objet : ne pas l'élargir.

## Publication

Branche unique `main`. Commits conventionnels (`<type>(<portée>): <description>`) : release-please (type `simple`) construit version et changelog. `.github/workflows/release.yml` tourne à chaque push sur `main`, sur un runner GitHub (jamais auto-hébergé sur un dépôt public), fusionne lui-même la release PR et s'arrête au tag et au changelog ; rien n'est déployé. Versions : https://github.com/Moodtuner997/arbitrage-skill/releases
