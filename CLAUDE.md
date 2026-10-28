# arbitrage-skill

## Règles inconditionnelles
- Dépôt public MIT : tout ce qui est suivi est lisible par tous, historique compris. Aucun chemin local, hôte, e-mail, nom de projet ou contexte privé dans un fichier ni dans un message de commit ; les idées privées restent dans `IDEES.md` (ignoré).
- Skill en prompt pur, mono-objet : ne pas élargir son périmètre. `SKILL.md` reste court (le modèle doit le tenir en mémoire de travail) ; toute matière nouvelle va dans `references/`.
- Le README est bilingue (`## English` puis `## Français`, sections en miroir) : tout changement d'usage, de format de sortie, d'installation ou de mode d'arrière-plan s'applique aux deux moitiés. Le bloc `=== ARBITRAGE [STANDARD|DEEP] ===` … `=== ===` reste identique dans `SKILL.md` et les deux moitiés.
- Une seule branche `main`, release-please type `simple` : `release.yml` tourne sur un runner GitHub (jamais auto-hébergé sur un dépôt public), fusionne la release PR et pose le tag ; rien n'est déployé.
- Architecture, conventions et fichiers : `docs/architecture.md`.

<!-- gen:debut -->
Dépôt `Moodtuner997/arbitrage-skill` (projet `arbitrage-skill`, arbitrage-skill, statut pause). Déploiement : aucun (pas de déploiement).
Avant toute action : `gh issue list --label etat` (l'issue État, vérité opérationnelle), `git fetch --prune`, `just --list` (points d'entrée uniformes : test, lint, dev, build, deploy-staging).
Tâches = issues GitHub ; état du dépôt = issue épinglée État ; mémoire longue = nœud `02-projets/arbitrage-skill.md` du second cerveau. Rien d'autre ne fait foi.
Enveloppe : PR vers `dev`, fusion si CI verte ; `staging` et `main` n'avancent que par tag (release.yml, release.sh). Secrets jamais lus. Généré par scripts/claude-md-gen.py : ne pas éditer ce bloc.
<!-- gen:fin -->

## Pièges
- Une idée privée dans un fichier suivi : `IDEES.md` a dû être ignoré dans `.gitignore` (bd64bc3, 2026-10-12).
- Pas de workflow de revue qui utilise un jeton sur ce dépôt public : la revue automatique a d'abord été limitée au propriétaire, puis retirée (9ed3036, bb1f34f, 2026-10-01/02).
- La release PR ne doit pas afficher une CI en échec : corrigé par la pause avant fusion dans `release.yml` (fed1aeb, refs ou-jouer#349).
- Un message de commit hors format conventionnel disparaît des releases ; `docs`, `chore`, `ci`, `test`, `style` ne publient rien (1d136e3, #4).
- Aucun chemin absolu Windows (lettre de disque) dans un fichier suivi : gitleaks refuse le push (règle commune des dépôts).
- Le README français s'écrit sans accents (quelques titres et tirets font exception) ; `SKILL.md` et `references/` sont en anglais seulement (`docs/architecture.md`).
- `scripts/.active` (témoin du mode arrière-plan) est ignoré : ne jamais le suivre (`.gitignore`).
- `just lint` appelle `shellcheck`, absent du poste (code 127 le 2026-10-28) : à installer avant de compter sur lui.
