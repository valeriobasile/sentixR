#' Sentix 3.1. Affective Lexicon
#'
#' @description
#' Sentix is an affective lexicon for the Italian language (Basile & Nissim
#' 2013; Basile et al. 2025).
#'
#' It includes 68,190 italian lemmas (field `lemma`) with associated affective
#' scores and an index of polypathy (see:
#' Details).
#'
#' @docType data
#' @keywords lexicon
#' @name sentix
#' @usage data(sentix)
#' @format A tibble with 68,190 rows and 4 columns:
#' \describe{
#'   \item{lemma}{Italian lemmas (character).}
#'   \item{score}{Sentiment valence: -1, +1 (double).}
#'   \item{polypathy_index}{Index of ambiguity (see Details): `"0"`, `"1"`, `"2"`, `"3"` (ordered factor).}
#' }
#' @details
#' The `polypathy_index` provides information on the
#' ambivalence and stability of the sentiment scores, on the basis of the
#' original multiple entries for each lemma.
#' The values are interpreted as follows:
#' \itemize{
#'   \item{`"0"`: No multiple entries for the lemma.}
#'   \item{`"1"`: Multiple entries with a low range (`max - min`) of original scores.}
#'   \item{`"2"`: Multiple entries with a high range of original scores.}
#'   \item{`"3"`: Multiple entries with a high range of original scores, and ambivalence (sign change).}
#' }
#' @references
#' Basile, V., & Nissim, M. (2013). Sentiment analysis on Italian tweets. In *Proceedings of the 4th Workshop on Computational Approaches to Subjectivity, Sentiment and Social Media Analysis*, pages 100–107, Atlanta, Georgia. Association for Computational Linguistics. \url{https://aclanthology.org/W13-1614/}.
#'
#' Basile, V., Nissim, M., Bosco, C., Vassallo, M., & Gabrieli, G. (2025).
#' *Sentix* (3.1). Zenodo. \doi{10.5281/zenodo.15609185}.
#'
#' @source
#'
#' * Zenodo Repository: \url{https://zenodo.org/records/15609186}.
#' * GitHub Repository: \url{https://github.com/valeriobasile/sentix}
#' @note
#' The dataset is distributed under the CC BY-SA 4.0 license.
#' @seealso
#' [`MAL`], [get_sentix()]
#' @examples
#' \dontrun{
#' data(sentix)
#' get_sentix()}
"sentix"
