#' MAL 3.1. Affective Lexicon
#'
#' @description
#' MAL (Morphologically-inflected Affective Lexicon) is an affective lexicon
#' for the Italian language. It expands [`sentix`] with inflected forms from
#' *Morph-it!* (Vassallo et al. 2019; see Zanchetta & Baroni 2005), and can be
#' therefore used without lemmatization.
#'
#' It contains 295,032 inflected forms (field `word`), with associated affective
#' scores, and an index of polypathy.
#'
#' Affective scores are inherited from the corresponding [`sentix`] entries
#' (lemmas).
#'
#' @source
#' Zenodo Repository: \url{https://zenodo.org/records/18709688}.
#' @docType data
#' @keywords lexicon
#' @name MAL
#' @usage data(MAL)
#' @format A tibble with 297,592 rows and 4 columns:
#' \describe{
#'   \item{lemma}{Italian inflected forms (character).}
#'   \item{score}{Sentiment valence: -1, +1 (double).}
#'   \item{polypathy_index}{Index of ambiguity: `"0"`, `"1"`, `"2"`, `"3"` (ordered factor; see [`sentix`] for details).}
#' }
#' @seealso
#' [`sentix`], [get_sentix()]
#' @note
#' The dataset is distributed under the CC BY-SA 4.0 license.
#' @references
#'
#' Vassallo, M., Gabrieli, G., Basile, V., & Bosco, C. (2019). The Tenuousness of Lemmatization in Lexicon-based Sentiment Analysis. In *Proceedings of the Sixth Italian Conference on Computational Linguistics (CLiC-it 2019)*, pages 520–525, Bari, Italy. CEUR Workshop Proceedings. \url{https://aclanthology.org/2019.clicit-1.79/}
#'
#' Zanchetta, E., & Baroni, M. (2005). Morph-it! A free corpus-based morphological resource for the italian language. In *Proceedings of Corpus linguistics Conference Series 2005*, University of Birmingham.
#' \url{https://cris.unibo.it/handle/11585/15321}
#' @examples
#' \dontrun{
#' data(MAL)
#' get_sentix(dict = "MAL")}
"MAL"
