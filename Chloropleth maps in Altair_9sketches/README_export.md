# Export autonome — Chloropleth maps in Altair, 9 sketches

Ce dossier est un export **autonome** du notebook des 9 sketches du mini-projet
*Baby Names* (CSC_4IG07 — Visualisation, Télécom Paris). Tout ce qu'il faut pour
l'exécuter sur une autre machine est inclus.

## Prérequis

- **Python 3.12** (ou ≥ 3.10) accessible en ligne de commande (`python`).
- Windows pour le script `run_9sketches.bat` (sur macOS/Linux, lancer les mêmes
  étapes à la main, voir ci-dessous).

## Démarrage rapide (Windows)

```bat
run_9sketches.bat
```

Le script : (1) installe les dépendances de `requirements.txt`, (2) exécute le
notebook avec **papermill** → `Chloropleth maps in Altair_9sketches_out.ipynb`,
(3) scanne la sortie et signale toute cellule en erreur (`_debug_report.py`),
(4) applique la passe de visibilité des contrôles interactifs
(`_patch_altair_control_visibility.py`).

## Équivalent manuel (toutes plateformes)

```bash
python -m pip install -r requirements.txt
python -m papermill "Chloropleth maps in Altair_9sketches.ipynb" "Chloropleth maps in Altair_9sketches_out.ipynb" --kernel python3
python _debug_report.py "Chloropleth maps in Altair_9sketches_out.ipynb"
python _patch_altair_control_visibility.py "Chloropleth maps in Altair_9sketches_out.ipynb"
```

## Contenu

| Fichier | Rôle |
|---|---|
| `Chloropleth maps in Altair_9sketches.ipynb` | Notebook source (les 9 sketches interactifs) |
| `Chloropleth maps in Altair_9sketches_out.ipynb` | Version **exécutée** (papermill), incluse pour consultation immédiate |
| `dpt2020.csv` | Données INSEE des prénoms 1900-2020 (séparateur `;`) |
| `departements-version-simplifiee.geojson` | Contours des départements (France métropolitaine) |
| `requirements.txt` | Dépendances Python |
| `run_9sketches.bat` | Exécution + débogage automatisés (Windows) |
| `_debug_report.py` | Scan des erreurs du notebook exécuté |
| `_patch_altair_control_visibility.py` | Passe de visibilité des contrôles Altair |
| `README.fr.md` | Rétrospective complète du projet |
| `altair_dn_decade.json` | Table département × prénom × période (~980 k lignes) utilisée par la carte 2.4 |
| `altair-data-*.json` | Données externes des graphiques, référencées par la version exécutée |
| `sketch_*.png` | Rendus de vérification des 9 sketches |

## Important — fichiers de données externes

Les graphiques stockent leurs données dans des fichiers **`altair-data-*.json`**
et **`altair_dn_decade.json`** situés à côté des notebooks
(`alt.data_transformers.enable('json')`). Pour que la version exécutée s'affiche
avec son interactivité (listes déroulantes de prénoms, jauges de dates et de
comptage, survols), **gardez tous les fichiers dans le même dossier** et ouvrez le
notebook depuis ce dossier (Jupyter ou VS Code). Une ré-exécution régénère ces
fichiers de toute façon.

## Les 9 sketches

- **Viz 1 (évolution temporelle)** : 1.5 streamgraph Top-N sur fenêtre · 1.2 bump
  chart (K jusqu'à 40) · 1.13 comparaison de prénoms (3 listes sur les 15 270 noms,
  recherche, Top-K de fenêtre).
- **Viz 2 (effet régional)** : 2.4 carte (tout prénom + jauge de période) · 2.2
  heat-map relative par ligne · 2.6 petites cartes multiples.
- **Viz 3 (effet de genre)** : 3.5 nuage parts garçons/filles · 3.2 barres
  divergentes par part · 3.3 disposition par penchant de genre.
