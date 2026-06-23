# Ideas

## Idea 1: Name Tiling by Birth Frequency

Create a dense, full-bleed tiling of all names where the names themselves form the visual field. The composition should fill the viewport from edge to edge, and it can continue vertically so the viewer scrolls through a larger packed surface.

Each name should stay easy to read. Labels can be horizontal or vertical, oriented left or right when vertical, but they should not end up at arbitrary angles. The layout should feel natural and balanced, with names packed as tightly as possible and the overall result feeling roughly square rather than like a loose list or grid.

### Data Encoding

- Use OKLab/OKLCH color for the name text.
- Map birth count to visual intensity on a log scale.
- Lower birth counts should look grayer or less saturated.
- Higher birth counts should look more colorful or intense.
- Map total birth count to text size on a log scale.
- Keep the color mapping conceptual for now: hue, chroma, and lightness can be tuned later once the layout works.

### Layout Direction

The tiling should use a real layout or optimization algorithm, not a simple uniform grid. Candidate approaches:

- Treemap-like packing as a starting point for area-weighted labels.
- Rectangle or bin packing to place measured text boxes tightly.
- Simulated annealing or another optimization pass to improve fit, balance, and edge coverage.
- Force-directed or collision-based refinement to remove awkward overlaps and gaps.

Small size adjustments are allowed after the initial log-scaled sizing, as long as they preserve the relative data signal. The goal is a packed surface that feels intentionally arranged and fully fills the available space.

## Idea 2: Probability Views, Clustering, And Learned Structure

Look beyond total popularity counts and ask a more conditional question: given a year, place, and possibly sex, what was the probability of a particular name? The goal is to treat names as distributions or trajectories over the birth data, not just as ranked totals.

### Probability Scales

Possible scales to explore:

- Raw births.
- Conditional probability within a year, department, and sex group.
- Log probability, so rare and common names can appear on the same visual scale.
- Log odds or standardized deviation from a baseline as later options.

The first useful default is probably log probability, because name probabilities likely span many orders of magnitude. Other scales can reveal different structure: raw births emphasizes mass, while standardized values emphasize names that are unusually common for a specific time or place.

### Names As Vectors

Represent each name as a vector or tensor over dimensions such as year, department, and sex. Each cell could store births, conditional probability, log probability, or a standardized value.

This makes it possible to compare names by:

- Temporal shape.
- Geographic pattern.
- Sex distribution.
- The full combined structure across year, department, and sex.

### Visualization Directions

- Line plots of many names over time.
- Clustered line plots where similarly shaped trajectories are grouped.
- Dendrograms or cluster trees.
- Two-dimensional maps of names from PCA, UMAP, or t-SNE.
- Nearest-neighbor views for a selected name.
- Error or surprise maps showing where a model fails to predict the data.

### Comparison And Clustering

Candidate comparison methods:

- Cosine similarity for normalized vector shape.
- Pearson correlation for centered rise and fall patterns.
- Jensen-Shannon distance when treating names as probability distributions.

Agglomerative hierarchical clustering is the first clustering method to try. It should work well for grouping name trajectories and gives a readable tree structure, which can become part of the visualization through dendrograms or cluster panels.

### Learned Structure

Neural networks could be used as exploratory instruments: the point is not only prediction accuracy, but seeing what structure the model discovers in the data.

Possible training views:

- Autoencoders to compress each name distribution and visualize the latent space.
- Masked prediction models that hide years, places, or sex splits and predict them.
- Forecasting models that predict later popularity from earlier data.
- Denoising models that smooth sparse or noisy name histories.
- Contrastive models that learn embeddings where similar name patterns are close.

Useful visualizations of the learned structure:

- Latent-space maps colored by peak decade, region, sex ratio, total births, or reconstruction error.
- Nearest neighbors under the neural embedding.
- Decoded examples showing what different latent-space regions mean.
- Error maps showing which names, years, departments, or sex splits the model predicts poorly.

### LLM And Name Embeddings

LLM or name-text embeddings can be a secondary lens. They should not replace the birth-data view, but they could help ask whether names that look, sound, or feel linguistically similar also behave similarly over time and space.

Possible directions:

- Use generic text embeddings for names as a baseline.
- Try character-level or name-specific embeddings for spelling, morphology, origin-like patterns, and phonetic similarity.
- Compare linguistic embedding neighborhoods with birth-data neighborhoods.
- Treat embeddings as exploratory context, not as demographic ground truth.
