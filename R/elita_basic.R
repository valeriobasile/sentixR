#' ELIta: Basic Emotions
#'
#' @description
#' A dataset containing scores for 6,905 Italian lexical entries (lemmas and
#' emojis) on the eight basic emotions of Plutchik’s wheel together with the
#' dyad _love_, formed by the combination of _trust_ and _joy_ (Plutchik 1980).
#' It uses a scale from "non associated" (0), "weakly associated" (0.25),
#' "moderately associated" (0.75) to "strongly associated" (1).
#'
#' This dataset is a subset of the broader ELIta framework: see
#' [`elita_VAD`], for the VAD dimensional approach (Valence, Arousal, and
#' Dominance)
#'
#' @docType data
#' @keywords lexicon
#' @name elita_basic
#' @usage data(elita_basic)
#' @format A tibble with 6,905 rows and 10 columns:
#' \describe{
#'   \item{lemma}{Italian lemmas and emojis (character).}
#'   \item{gioia}{Joy: 0, +1, (double).}
#'   \item{tristezza}{Sadness: 0, +1, (double).}
#'   \item{rabbia}{Anger: 0, +1, (double).}
#'   \item{disgusto}{Disgust: 0, +1, (double).}
#'   \item{paura}{Fear: 0, +1, (double).}
#'   \item{fiducia}{Trust: 0, +1, (double).}
#'   \item{sorpresa}{Surprise: 0, +1, (double).}
#'   \item{aspettativa}{Anticipation: 0, +1, (double).}
#'   \item{amore}{Love: 0, +1, (double).}
#' }
#'
#'
#' @references
#' Di Palma, E. (2024a). ELIta: A New Italian Language Resource for Emotion Analysis.
#' \emph{Proceedings of the 10th Italian Conference on Computational Linguistics (CLiC-it 2024)}, 297–307.
#' \url{https://aclanthology.org/2024.clicit-1.36/}
#'
#' Di Palma, E. (2024b). ELIta (Emotion Lexicon for Italian).
#' \url{http://hdl.handle.net/20.500.11752/OPEN-1036}
#'
#'Plutchik, R. (1980). A general psychoevolutionary theory of emotion. In R. Plutchik & H. Kellerman (eds.), *Theories of Emotion* (pp. 3–33). Academic Press.
#' @source
#'GitHub Repository: \url{https://github.com/elianadipalma/ELIta}
#' @note
#' The dataset is distributed under the Creative Commons Universal License (CC0 1.0).
#' @seealso
#' [`elita_VAD`], [get_elita()].
#'
#' @examples
#' data(elita_basic)
#' get_elita(dict = "elita_basic")
"elita_basic"
