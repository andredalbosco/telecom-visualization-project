# Implementation initiale, semaine 2

Projet : Baby Names, IGR204  
Page du sujet : https://perso.telecom-paristech.fr/eagan/class/igr204/baby-names

Ce dossier contient l'implementation initiale demandee en semaine 2. Le but etait de choisir une solution pour chacune des trois questions du mini-projet et de produire une premiere version fonctionnelle avec Altair.

## a ouvrir

Pour lire le rendu sans rien relancer :

```text
Chloropleth maps in Altair_9sketches_out.ipynb
```

Pour voir le code source :

```text
Chloropleth maps in Altair_9sketches.ipynb
```

Les fichiers `sketch_*.png` sont les captures a utiliser pour une revue rapide ou un post de forum.

## questions traitees

1. Evolution des prenoms dans le temps.
2. Effet regional dans les prenoms.
3. Effet de genre dans les prenoms.

Le notebook contient neuf sketches Altair, trois par question. Cette branche correspond a une premiere implementation, pas a la version finale raffinee de la semaine 4.

## donnees

- `dpt2020.csv` contient les donnees INSEE des prenoms par departement, de 1900 a 2020.
- `departements-version-simplifiee.geojson` contient les contours des departements.
- `altair_dn_decade.json` sert a la carte regionale interactive.
- `altair-data-*.json` contient les donnees exportees par Altair.

Ces fichiers doivent rester dans le meme dossier que les notebooks. Les graphiques du notebook execute les chargent par chemin local.

## visualisations

### 1. evolution temporelle

- Streamgraph Top-N sur une fenetre d'annees.
- Bump chart par decennie.
- Comparaison de prenoms avec selection manuelle et recherche.

### 2. effet regional

- Carte choroplethe interactive par prenom et periode.
- Heat-map prenom par departement.
- Petites cartes multiples pour comparer plusieurs prenoms.

### 3. effet de genre

- Nuage masculin/feminin.
- Barres divergentes selon la part de genre.
- Positionnement des prenoms selon leur tendance de genre.

## relancer

Windows :

```bat
run_9sketches.bat
```

macOS ou Linux :

```bash
python -m pip install -r requirements.txt
python -m papermill "Chloropleth maps in Altair_9sketches.ipynb" "Chloropleth maps in Altair_9sketches_out.ipynb" --kernel python3
python _debug_report.py "Chloropleth maps in Altair_9sketches_out.ipynb"
python _patch_altair_control_visibility.py "Chloropleth maps in Altair_9sketches_out.ipynb"
```

Les gros fichiers CSV et JSON sont suivis par Git LFS.
