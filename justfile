# Points d'entrée du dépôt (règle commune : `just --list` avant d'agir). Gabarit : scripts/gabarits/justfile.statique, adapté (skill sans build ni déploiement).
set windows-shell := ["bash", "-c"]
set shell := ["bash", "-c"]

# Seul test possible : le script de bascule répond (le comportement de la skill se vérifie à la main dans une session Claude Code)
test:
    bash scripts/arbitrage-toggle.sh status

# Analyse statique du seul script shell du dépôt
lint:
    shellcheck scripts/arbitrage-toggle.sh

# Aucun serveur : la skill se charge en clonant le dépôt dans ~/.claude/skills/arbitrage
dev:
    echo "pas de serveur de dev"

# Rien à construire : skill en prompt pur
build:
    echo "rien à construire"

# Aucun staging : une seule branche main, la release par tag est posée par release.yml
deploy-staging:
    echo "pas de staging : main + tag par release-please"
