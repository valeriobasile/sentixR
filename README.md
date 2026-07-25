# sentixr


<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/sentixr)](https://cran.r-project.org/package=sentixr)
[![](https://img.shields.io/badge/doi-10.32614/CRAN.package.sentixr-blue.svg)](https://doi.org/10.32614/CRAN.package.sentixr)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://cranlogs.r-pkg.org/badges/sentixr)](https://cran.r-project.org/package=sentixr)

<!-- badges: end -->

R package to perform sentiment analysis on Italian texts, including four
lexicons in tidy format (tibbles): Sentix, MAL, ELIta VAD and basic
emotions (Plutchik’s wheel of emotions).

## Overview

The package provides two main functions to perform sentiment analysis on
Italian texts:

- `sentix_annotate()`: Annotates a text or a dataframe of texts with
  sentiment scores from the selected lexicon, using *udpipe* for
  parsing, and *dplyr* for joining the lexicon.
- `sentix_summarize()`: Summarizes the sentiment scores from the
  annotated dataframe, providing overall sentiment metrics per document
  (or segments) and auxiliary metrics that can be used to evaluate the
  results, recompute scores, or apply custom aggregation strategies.

It also provides utility functions to manage the included lexicons,
allowing them to be easily used also within other frameworks such as
*Tidytext* and *Quanteda*.

- `get_sentix()`, `get_elita()` and `make_polarity()`, to extract and
  use them in custom analyses;
- `df_to_valence()`, `df_to_polar()` (plus the wrapper `df_to_dict()`)
  to convert tidy lexicons into Quanteda dictionaries.

## Install

From CRAN:

``` r
install.packages("sentixr")
```

From GitHub:

``` r
# install.packages("remotes") 
remotes::install_github("valeriobasile/sentixr", 
                         build_vignettes = TRUE)
```

## Lexicons

While the package is published under a GPL-3.0 license, lexicons are
provided under separate terms (CC BY-SA and CC0 1.0 Universal).

Please check the individual lexicon documentation for details.

<table style="width:99%;">
<colgroup>
<col style="width: 6%" />
<col style="width: 25%" />
<col style="width: 10%" />
<col style="width: 13%" />
<col style="width: 42%" />
</colgroup>
<thead>
<tr>
<th>Lexicon</th>
<th></th>
<th>Entries</th>
<th>Features</th>
<th>Source and License</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>sentix</code></td>
<td>Sentix 3.1 <span class="citation"
data-cites="basile_sentiment_2013 basile_sentix_2025">(Basile and Nissim
2013; Basile et al. 2025)</span></td>
<td>68,190 lemmas</td>
<td>Scores (-1, 1), polypathy index</td>
<td><p><a href="https://github.com/valeriobasile/sentix">GitHub</a>, <a
href="https://doi.org/10.5281/zenodo.15609185">Zenodo</a>,</p>
<p>CC BY-SA</p></td>
</tr>
<tr>
<td><code>MAL</code></td>
<td>MAL 3.1 <span class="citation"
data-cites="vassallo_tenuousness_2019 vassallo_polarity_2020">(Vassallo
et al. 2019, 2020)</span></td>
<td>295,032 inflected forms</td>
<td>Inherited from Sentix</td>
<td><p><a href="https://doi.org/10.5281/zenodo.18709687"
title="repository">Zenodo</a></p>
<p>CC BY-SA</p></td>
</tr>
<tr>
<td><code>elita_basic</code></td>
<td>ELIta <span class="citation" data-cites="20.500.11752/OPEN-1036">(Di
Palma 2024)</span></td>
<td>6,905 lemmas + emojis</td>
<td>Plutchik’s emotions (0, 1)</td>
<td><p><a href="https://github.com/elianadipalma/ELIta">GitHub</a></p>
<p>CC0 1.0 Universal</p></td>
</tr>
<tr>
<td><code>elita_VAD</code></td>
<td>—</td>
<td>6,905 lemmas + emojis</td>
<td>VAD (-4 / +4)</td>
<td><p><a href="https://github.com/elianadipalma/ELIta">GitHub</a></p>
<p>CC0 1.0 Universal</p></td>
</tr>
</tbody>
</table>

## Usage

``` r
library(sentixr)
```

### Main workflow

The sentiment analysis workflow consists of two main steps: annotation
(`sentix_annotate`) and summarization (`sentix_summarize`).

``` r
# Single text
# annotate with defaults
sentix_annotate("Oggi è una bella giornata. Esco a fare una passeggiata") |>
  # summarize by document - default
  sentix_summarize()
```

    # A tibble: 1 × 4
      doc_id score n_tokens n_scored
      <chr>  <dbl>    <int>    <int>
    1 doc1   0.176       10        9

### Annotate

`sentix_annotate()` annotates texts with sentiment scores from the
selected lexicon, after parsing them with *udpipe*. For large corpora,
the user may optionally specify the number of cores to use, via the
argument `parallel.cores`, which is inherited from *udpipe* and passed
to `udpipe::udpipe()`.

#### Managing the udpipe model

The `model` argument allows specifying a custom **udpipe model**. If no
model is given, the function will automatically download the default
Italian udpipe model. After the first run, the downloaded model can be
reused.

``` r
# Using a model in the working directory
sentix_annotate(testi, model = "local")
```

``` r
# Loading a pre-downloaded model
model <- udpipe::udpipe_load_model("italian-isdt-ud-2.5-191206.udpipe")
```

#### With multiple texts and dataframe

The function, like *udpipe*, accepts as input single texts, multiple
texts (a character vector, a list or a list of tokens), or dataframes
with `text` and `doc_id` columns.

The function also helps the user specify custom column names and manage
document identifiers, which are safely passed to `udpipe::udpipe()`.
Note that, however, other columns in the dataframe are ignored.

``` r
# Example dataframe with doc_id and text fields
data(recensioni_tv)

# Annotate the dataframe directly}
anno_df <- sentix_annotate(
  recensioni_tv,
  # loaded model
  model = model
)

head(anno_df)
```

      doc_id sentence_id token_id    token    lemma  upos     score
    1   doc1           1        1   Ottimo   ottimo   ADJ 1.0000000
    2   doc1           1        2 prodotto prodotto  NOUN 0.0000000
    3   doc1           1        3        ,        , PUNCT        NA
    4   doc1           1        4       la       il   DET        NA
    5   doc1           1        5  qualità  qualità  NOUN 0.3631757
    6   doc1           1      6-7    dell'     <NA>  <NA>        NA

#### With a different lexicon

By default, `sentix_annotate()` uses the Sentix lexicon. To use a
different lexicon, specify it with the `dict` argument.

``` r
# Use ELIta lexicon with VAD scores
anno_vad <- sentix_annotate(recensioni_tv, model = model, dict = "elita_VAD")
```

### Summarize

`sentix_summarize()` computes overall sentiment scores and auxiliary
metrics per document (or other segments, via the argument `by`) from the
annotated dataframe.

``` r
sentix_summarize(
  anno_df,
  # summarize by sentence
  by = c("doc_id", "sentence_id")
)
```

    # A tibble: 7 × 5
      doc_id sentence_id   score n_tokens n_scored
      <chr>        <int>   <dbl>    <int>    <int>
    1 doc1             1  0.274        12        9
    2 doc2             1 -0.253         4        3
    3 doc2             2 -0.0818       11        6
    4 doc3             1  0.244        15        9
    5 doc4             1  0.178         4        3
    6 doc4             2  0.0965       12        9
    7 doc5             1 -0.0187       15        9

When using lexicons with multiple features (e.g., ELIta), all features
are summarized.

``` r
sentix_summarize(anno_vad)
```

    # A tibble: 5 × 6
      doc_id  valenza attivazione dominanza n_tokens n_scored
      <chr>     <dbl>       <dbl>     <dbl>    <int>    <int>
    1 doc1    0.500       -0.0971    0.285        12        6
    2 doc2    0.0414       0.387     0.0957       15        7
    3 doc3    0.402        0.208     0.125        15        3
    4 doc4    0.0714      -0.0296    0.0954       16        7
    5 doc5   -0.00667      0.0554    0.0342       15        6

## How to Cite

If you use *sentixr* in your research, please cite it as follows:

Vardanega, A., Basile, V., Vassallo, M., Gabrieli, G. & Di Palma, E.
(2026). sentixr (Versione 0.2.0)
https://github.com/valeriobasile/sentixR

## Authors

- Vardanega, Agnese (Università di Teramo) (mantainer)

- Basile, Valerio (Università di Torino)

- Vassallo, Marco (CREA-PB)

- Gabrieli, Giuliano (CREA-PB)

- Di Palma, Eliana (Università di Torino)

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-basile_sentiment_2013" class="csl-entry">

Basile, Valerio, and Malvina Nissim. 2013. “Sentiment Analysis on
Italian Tweets.” In *Proceedings of the 4th Workshop on Computational
Approaches to Subjectivity, Sentiment and Social Media Analysis*,
100–107. <https://aclanthology.org/W13-1614/>.

</div>

<div id="ref-basile_sentix_2025" class="csl-entry">

Basile, Valerio, Malvina Nissim, Cristina Bosco, Marco Vassallo, and
Giuliano Gabrieli. 2025. “Sentix.”
<https://github.com/valeriobasile/sentix>.

</div>

<div id="ref-20.500.11752/OPEN-1036" class="csl-entry">

Di Palma, Eliana. 2024. “ELIta (Emotion Lexicon for Italian).”
<http://hdl.handle.net/20.500.11752/OPEN-1036>.

</div>

<div id="ref-vassallo_tenuousness_2019" class="csl-entry">

Vassallo, Marco, Giuliano Gabrieli, Valerio Basile, and Cristina Bosco.
2019. “The Tenuousness of Lemmatization in Lexicon-Based Sentiment
Analysis.” In *Proceedings of the Sixth Italian Conference on
Computational Linguistics*, 2481:1–6. Ceur.
<https://iris.unito.it/bitstream/2318/1725233/1/paper74.pdf>.

</div>

<div id="ref-vassallo_polarity_2020" class="csl-entry">

———. 2020. “Polarity Imbalance in Lexicon-Based Sentiment Analysis.” In
*Proceedings of the Seventh Italian Conference on Computational
Linguistics CLiC-It 2020 : Bologna, Italy, March 1-3, 2021*, edited by
Felice Dell’Orletta, Johanna Monti, and Fabio Tamburini, 457–63. Collana
Dell’associazione Italiana Di Linguistica Computazionale. Accademia
University Press. <https://doi.org/10.4000/books.aaccademia.8964>.

</div>

<div id="ref-zanchetta_morphit_2005" class="csl-entry">

Zanchetta, Eros, and Marco Baroni. 2005. “Morph-It! A Free Corpus-Based
Morphological Resource for the Italian Language.” In *Proceedings of
Corpus Linguistics Conference Series 2005 (ISSN 1747-9398)*, 1:1–12.
University of Birmingham.

</div>

</div>
