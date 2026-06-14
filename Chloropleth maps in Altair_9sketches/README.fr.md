# Mini-projet Baby Names - Carte choroplèthe Altair

Réalisation : Julien Gimenez  
Cours : CSC_4IG07 - Visualisation, Télécom Paris

## Objectif

Ce livrable traite la visualisation 2 de l'énoncé `doc/Mini-project_ Baby Names — James Eagan.html` : déterminer s'il existe un effet régional dans les prénoms de naissance en France.

La réalisation principale est dans :

- `Chloropleth maps in Altair_JulienGimenez.ipynb`
- `Chloropleth maps in Altair_JulienGimenez_FR.ipynb`

Les sorties générées sont :

- `choropleth_LUCIEN.html` et `choropleth_LUCIEN.png`
- `choropleth_LUCIEN_FR.html` et `choropleth_LUCIEN_FR.png`

## Améliorations apportées

La carte ne colore plus les départements par effectif brut, car cela revient surtout à cartographier la population. Elle utilise maintenant un taux de naissances pour 1000, calculé par département.

Le dénominateur du taux inclut aussi les lignes `_PRENOMS_RARES`, car elles représentent des naissances réelles. Ces lignes sont exclues uniquement du comptage du prénom choisi.

La Corse est réintégrée en fusionnant les géométries `2A` et `2B` sous le code historique `20`, utilisé dans le fichier INSEE.

Le prénom `LUCIEN` est agrégé sur toutes les années et les deux sexes, afin d'obtenir un seul polygone par département.

La sortie graphique combine désormais :

- une carte choroplèthe par quantiles avec une rampe `viridis`,
- une projection conique conforme adaptée à la France métropolitaine,
- un classement des 12 départements au taux le plus élevé,
- des infobulles détaillées dans l'export HTML,
- un survol lié entre carte et classement dans l'export HTML,
- des assertions de cohérence avant rendu.

Les libellés visibles de la figure FR (titre, sous-titre, légende, infobulles, classement) sont en français **accentué**. Un test de rendu a confirmé que la version actuelle de `vl-convert-python` exporte correctement les accents et les guillemets « » en PNG : le contournement ASCII précédent n'est donc plus nécessaire et a été retiré.

## Ancrage dans le cours

Les choix suivent les points étudiés dans `cours/` :

- `2d — Geospatial Maps` : une choroplèthe peut confondre géographie et population ; le taux pour 1000 corrige cet effet.
- `3 — Tasks` : la vue vise les tâches `Compare`, `Find extremum`, `Characterize distribution` et `Find anomalies`.
- `4 — Perception` et Munzner : la couleur convient au motif spatial, mais la position/longueur est meilleure pour comparer précisément ; d'où le classement adjacent.
- Notebooks Altair : utilisation de `mark_geoshape`, `Tooltip`, composition de vues, sélection au survol et échelles adaptées aux distributions asymétriques.

## Parcours de décision (rétrospective)

Le livrable s'est construit par itérations, chaque étape découlant d'une observation
concrète (exécution ou rendu visuel) plutôt que d'une hypothèse.

1. **Faire tourner avant de juger.** Premier réflexe : exécuter le notebook de bout
   en bout via papermill pour laisser les erreurs se révéler. → a exposé d'abord le
   `geopandas` manquant, puis le `TypeError` sur la colonne `geometry`.
2. **Corriger à la cause.** Le `.sum()` qui échoue sous pandas 2.x est résolu en
   agrégeant les effectifs sur le dataframe « plat » (et non en sommant la géométrie),
   ce qui est aussi plus juste sémantiquement.
3. **Outiller la boucle run → debug.** `run.bat`/`run_FR.bat` exécutent puis lancent
   `_debug_report.py`, qui inspecte le notebook *exécuté* et remonte toute cellule en
   erreur avec un code de sortie exploitable.
4. **Consulter le rendu, pas seulement le code.** Étape charnière : ouvrir le PNG. La
   carte « marchait » mais ne *répondait pas à la question* — elle cartographiait la
   population (Paris écrasant l'échelle).
5. **Pertinence d'abord.** D'où le **taux pour 1000** (avec dénominateur incluant
   `_PRENOMS_RARES`, qui sont de vraies naissances), l'**agrégation des deux sexes**
   (polygones superposés), et la **réintégration de la Corse** (`20` vs `2A`/`2B`),
   défaut repéré en voyant l'île manquante.
6. **Lisibilité guidée par l'image.** L'échelle linéaire écrasait ~63 % des
   départements dans une teinte unique → passage à une **classification par
   quantiles**. Puis, le cours géospatial aidant, une **projection conique conforme**
   pour rendre à l'Hexagone sa forme correcte.
7. **De la carte à la tâche (Munzner).** La couleur lit mal une valeur précise : on
   adjoint un **classement des 12 plus forts taux** (position/longueur) et un
   **survol lié** carte ↔ barres dans l'export HTML.
8. **Robustesse et finition.** Assertions de cohérence avant rendu, nettoyage des
   lignes sans géométrie, artefacts EN/FR **distincts** (`_FR`) pour qu'un run
   n'écrase plus l'autre, et — après vérification du rendu PNG — **rétablissement des
   accents** dans la figure FR.

Fil conducteur : **laisser l'exécution et le rendu visuel dicter la correction
suivante**, et ancrer chaque choix graphique dans le matériel de `cours/`.

## Notebook complémentaire : les 9 sketches sélectionnés

`Chloropleth maps in Altair_9sketches.ipynb` implémente les **9 croquis retenus**
par l'équipe dans `../process selection #1/selection_process_deliberated`
(top 3 du *Reverse Borda Count* pour chacune des 3 questions du projet). Chaque
cellule exporte un PNG (`sketch_<id>_*.png`) pour inspection.

- **Viz 1 — évolution temporelle** : `1.5` streamgraph Top-N (jusqu'à 50) avec
  sélection `Mixed / Boys / Girls` et **légende cliquable** (isole un prénom),
  `1.2` classement / *bump chart* par décennie avec sélection `Mixed / Boys / Girls`
  (survol pour surligner), `1.13` couches superposées avec Top-K, sélection
  `Mixed / Boys / Girls`, et jusqu'à 20 slots `Name` désactivables.
- **Viz 2 — effet régional** : `2.4` carte + **liste de prénoms** (menu déroulant)
  et **survol** des départements, `2.6` petites cartes multiples par prénom avec
  slider de décennie et jauge de 3 à 6 cartes (échelles indépendantes,
  **survol partagé**), puis `2.2` heat-map prénom × département avec slider de
  décennie et sélection `Mixed / Boys / Girls`.
- **Viz 3 — effet de genre** : `3.5` nuage masculin/féminin (droite de parité)
  **animé par décennie** (curseur), `3.2` barres divergentes avec slider de
  décennie, Top-N jusqu'à 300 et classement `Mixed / Boys / Girls`, `3.3`
  disposition F↔M par popularité **animée par année** (curseur).

### Interactivité ajoutée (jauges, animation, sélection)

Comme l'illustraient les croquis (curseurs temporels de 2.9 / 3.x, « animé ? » de
3.3 et 3.5, survol de 1.3, liste cochable de 2.4), la version interactive offre :

- des **listes déroulantes de prénoms sur la liste complète** (les 15 270 noms,
  saisie au clavier supportée par le `<select>` du navigateur) : **1.13 propose
  jusqu'à 20 slots `Name`**, tous à `(none)` par défaut, avec une jauge
  **Name slots shown** qui décide combien de dropdowns sont visibles et peuvent
  tracer une courbe ;
  un champ de recherche libre ajoute une courbe violette ; **2.4** propose un
  dropdown (le champ de recherche le surclasse quand il est rempli) ;
- des **jauges de dates sur chaque graphique, de façon adaptée** :
  fenêtre d'années « From/To » (1.5, 1.13), fenêtre de décennies (1.2), sliders de
  décennie pour **2.2**, **2.6**, **3.2**, **3.5** et curseur d'année sur les
  121 années (3.3). **2.4** garde une jauge glissante par décennie alimentée par
  une table département × prénom × décennie de ~980 000 lignes servie en **JSON
  externe référencé par URL**, avec une case *All years* pour l'agrégat 1900-2020,
  décochée par défaut ;
- des **jauges de comptage partout, dans le même esprit** : profondeur de
  classement K (1.2, **3→40**, échelle de rangs auto-ajustée), nombre de lignes du
  heat-map (2.2, **5→300**), nombre de prénoms de 3.2 (**10→300**), nombre
  d'étiquettes (3.5, **0→200**), nombre de points par année (3.3, **50→1000**), en
  plus du Top-N de 1.5 et du nombre de cartes de 2.6 (**3→6**, avec masquage des
  dropdowns de prénoms excédentaires) ; **1.13** ajoute un mode **Top-K de la fenêtre** (0→30,
  0 = désactivé) : les K prénoms les plus populaires de l'intervalle From/To se
  tracent en fines courbes colorées sous les choix manuels ;
- une **jauge « Top N » sur 1.5** (3 → 50) : le streamgraph affiche les N prénoms
  les plus populaires **sur la fenêtre temporelle choisie** — le classement est
  recalculé côté client (total par prénom sur la fenêtre via `joinaggregate`, puis
  `dense_rank`), avec l'empilement centré natif de Vega-Lite et les noms toujours
  écrits sur les bandes à leur pic dans la fenêtre. Ex. : 1900-1930 fait ressortir
  MARIE/JEAN/LOUIS ; 1990-2020 fait apparaître les prénoms récents ;
- des sélections de sexe en anglais (`Mixed`, `Boys`, `Girls`) sur **1.5**, **1.2**,
  **1.13**, **2.2** et **3.2**. Pour 2.2, le Top-N est recalculé par décennie et
  par sexe, et les départements sans naissance sont encodés à zéro plutôt que
  laissés comme cellules blanches ;
- de l'**animation** : faire glisser le curseur de 3.5 fait dériver les prénoms de
  part et d'autre de la droite de parité ; celui de 3.3 fait évoluer la répartition
  par genre année après année ; le slider de 2.6 fait voyager les bastions
  régionaux de décennie en décennie ;
- légende cliquable (1.5), **survol** lié (1.2, 2.4, 2.6).

### Couverture des données et « visualisable »

Pour que « tous les noms / toutes les années » reste exploitable :

- **1.13** embarque la série annuelle **complète** (~249 000 paires année × prénom) ;
  le contexte grisé reste limité au top-30 pour la lisibilité, mais la recherche
  trace n'importe quel prénom par-dessus. Piège technique : une échelle de couleur
  catégorielle à 15 000 entrées faisait exploser l'export → couleur fixe pour la
  courbe sélectionnée.
- **2.4** s'appuie sur la table **complète** département × prénom × période
  (~980 000 lignes : les 13 décennies + l'agrégat *All years*), écrite une fois par
  pandas dans `altair_dn_decade.json` et **référencée par URL** ; les polygones sont
  joints au rendu par un **lookup** Vega (stockés une fois, pas une fois par
  prénom). Particularité découverte au débogage : `chart.save(...png)` **inline**
  les DataFrames mais ne télécharge pas les données URL — le PNG est donc rendu
  depuis un instantané DataFrame de l'état par défaut (JEAN, décennie 1980), tandis
  que le graphique affiché reste interactif sur la table URL (chargée par le
  navigateur).
- **3.5** trace **tous** les prénoms mixtes de la décennie choisie (les axes log
  imposent ≥ 1 naissance de chaque sexe — contrainte du design, pas un
  échantillonnage).
- **3.3** trace les 300 prénoms les plus donnés de l'année choisie (au-delà, des
  points de 3 naissances illisibles) ; le curseur, lui, couvre bien toutes les
  années.

Les PNG capturent l'état par défaut (aucun slot manuel actif dans 1.13, Top-K
visible, `JEAN` en 1980 pour 2.4, six cartes en 2010 pour 2.6, décennie 2010 pour
2.2/3.2, décennie/année 2000 pour 3.5/3.3), tous vérifiés visuellement via
`verify_9sketches_contact_sheet.png`.

**Mémoire et poids des fichiers** : l'exécution a d'abord échoué en `MemoryError`
(la machine faisait tourner en parallèle un benchmark de ~6 Go, ne laissant
~2,5 Go libres, et le notebook embarquait ~50 Mo de données dans chaque spec).
Deux corrections structurelles, déboguées d'après l'output papermill :

1. `alt.data_transformers.enable('json')` — les données des graphiques vont dans
   des fichiers externes `altair-data-*.json` (comme dans le tutoriel Altair), ce
   qui garde les plus grosses tables hors des specs Vega-Lite. Conséquence :
   notebook exécuté et exports HTML doivent rester **à côté** de ces fichiers pour
   s'afficher, et le `_out.ipynb` des 9 sketches reste volontairement plus lourd
   parce qu'il conserve les sorties Altair interactives.
2. Chargement « économe » du CSV : dtypes `category` à la lecture (les 15 270
   chaînes de prénoms stockées une fois), année dérivée des **122 catégories**
   `annais` plutôt que de 3,5 M de chaînes, puis retour à des colonnes objets aux
   chaînes partagées — plusieurs centaines de Mo économisés, l'exécution tient
   dans l'enveloppe disponible.

Choix appuyés sur `cours/` : couleurs séquentielles/divergentes perceptuellement
uniformes et lisibles par les daltoniens, **position/longueur** pour comparer
précisément (barres, nuage), **streamgraph/bump** pour volume et rang dans le temps,
et projection conique conforme pour les cartes. Les derniers défauts repérés en
**consultant les PNG** et le notebook exécuté ont été corrigés : sélections
`Mixed / Boys / Girls` en anglais, Top-N étendus (1.5 à 50, 2.2 et 3.2 à 300),
jusqu'à 20 slots `Name` tous à `(none)` par défaut dans 1.13, slider de décennie
pour 2.2/2.6/3.2, case *All years* décochée par défaut dans 2.4, jauge de 3 à
6 cartes dans 2.6, échelles indépendantes pour 2.6, matrice 2.2 complétée à zéro,
et expression Vega de 2.4 restaurée (`? :`) après l'erreur JavaScript
`Unexpected token :`. Le `_out.ipynb` exécuté conserve les outputs `text/html`
Altair afin que les sketches restent interactifs, avec un patch post-run qui masque
les dropdowns `Name 0X` excédentaires de 1.13 et 2.6 selon le nombre de slots/cartes
sélectionné.

### Revue multi-agents et révision (critique → correction → vérification)

Les 9 rendus ont ensuite été passés à une **revue par agents** : un expert par
graphique relisait *à la fois* le PNG produit **et** le croquis de départ, notait la
fidélité et la lisibilité (principes Munzner/perception), puis proposait des
corrections concrètes ; une synthèse priorisait. Le fil rouge des critiques : **on
traçait des effectifs bruts là où la question porte sur une proportion**, si bien
que quelques prénoms géants (MARIE, JEAN ≈ 2 M) écrasaient l'échelle et noyaient le
signal. Corrections appliquées :

- **2.2** — passage à une couleur **relative au maximum de chaque ligne** (et
  départements d'outre-mer retirés) : chaque prénom révèle enfin sa propre géographie
  au lieu d'un aplat uniforme.
- **3.2** — barres en **part de genre** (pleine largeur) **triées du plus masculin au
  plus féminin** : les prénoms mixtes (CLAUDE, DOMINIQUE) ressortent au centre.
- **3.5** — axes en **part par sexe** (‰ des garçons vs ‰ des filles, comme le
  croquis), taille en √, droite de parité = unisexe.
- **3.3** — axe en **logit** de la part masculine (centre = unisexe, extrêmes
  comprimés) + classe de genre en 3 couleurs ; les rares prénoms **co-ed** sont
  nommés (SACHA, MORGAN, ANDRÉA…), sous-titre explicitant que presque tous les
  prénoms français sont fortement genrés.
- **1.5** — les noms sont **écrits dans les bandes** (à leur pic) comme le croquis.
- **1.2** — seuls les prénoms passés un jour dans le **top 3** sont colorés/étiquetés
  (le reste en gris) et les étiquettes qui se chevauchaient sont décalées.
- **1.13 / 2.4** — l'élément sélectionné est **nommé sur le rendu statique** (courbe
  rouge étiquetée, nom du prénom inscrit sur la carte), repères WWI/WWII ajoutés.

Une seconde passe d'agents **vérifiait de façon adverse** que chaque correction avait
bien pris et n'introduisait pas de régression ; les points confirmés (chevauchements
résiduels de 1.2, repères non étiquetés de 1.13, étiquettes co-ed manquantes de 3.3)
ont été corrigés puis re-rendus. Le survol orange de 2.4, signalé « absent », ne
l'est pas : il est **interactif** et n'apparaît donc pas sur un PNG statique (aucun
département n'y est survolé) — il fonctionne dans l'export HTML.

Exécution :

```bat
.\run_9sketches.bat
```

## Exécution

Les exécutions doivent se faire via les scripts batch :

```bat
.\run.bat
.\run_FR.bat
.\run_9sketches.bat
```

Chaque script :

1. installe ou rafraîchit les dépendances de `requirements.txt`,
2. exécute le notebook avec papermill,
3. lance `_debug_report.py` sur le notebook exécuté,
4. pour `run_9sketches.bat`, conserve les outputs HTML Altair complets dans le
   notebook exécuté, injecte la visibilité dynamique des contrôles dropdown de 1.13
   et 2.6, puis affiche la durée totale du run en millisecondes et secondes.

Les sorties papermill sont :

- `Chloropleth maps in Altair_JulienGimenez_out.ipynb`
- `Chloropleth maps in Altair_JulienGimenez_FR_out.ipynb`
- `Chloropleth maps in Altair_9sketches_out.ipynb`

Dernière vérification effectuée sur `run_9sketches.bat` : papermill se termine sans
erreur, `_debug_report.py` ne détecte aucune cellule en erreur, l'output
`Chloropleth maps in Altair_9sketches_out.ipynb` conserve ses sorties riches
`text/html` pour l'interaction, contient deux patchs de visibilité dynamique des
contrôles, et les PNG séparés sont vérifiés dans `verify_9sketches_contact_sheet.png`.

## Fichiers utiles

| Fichier | Rôle |
|---|---|
| `dpt2020.csv` | Données INSEE des prénoms par année, sexe et département |
| `departements-version-simplifiee.geojson` | Contours utilisés pour la France métropolitaine |
| `Chloropleth maps in Altair_JulienGimenez.ipynb` | Notebook principal |
| `Chloropleth maps in Altair_JulienGimenez_FR.ipynb` | Version française alignée |
| `run.bat` | Exécution et débogage du notebook principal |
| `run_FR.bat` | Exécution et débogage du notebook FR |
| `_debug_report.py` | Scan des erreurs dans les notebooks exécutés |
| `_patch_altair_control_visibility.py` | Patch HTML post-run qui masque les contrôles dropdown excédentaires de 1.13 et 2.6 |
| `requirements.txt` | Dépendances Python |
| `prompt_codex_history.txt` | Historique verbatim des prompts utilisateur (session Codex) |
| `prompt_claude_history.txt` | Historique verbatim des prompts utilisateur (session Claude Code) |
| `Chloropleth maps in Altair_9sketches.ipynb` | Les 9 sketches retenus, implémentés pour les 3 questions |
| `run_9sketches.bat` | Exécution + débogage du notebook des 9 sketches |
| `sketch_*.png` | Rendus exportés des 9 sketches (générés au run) |
| `doc/…James Eagan.html` (+ `_FR.html`) | Énoncé du mini-projet (source + traduction française) |

## Pistes restantes

- Paramétrer le prénom du notebook principal via papermill plutôt que de garder
  `LUCIEN` en dur.
- Ajouter une vérification visuelle automatisée plus stricte que la planche PNG
  manuelle, par exemple comparaison de dimensions, variance et zones non blanches.
