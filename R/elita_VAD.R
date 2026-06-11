#' ELIta: VAD Dimensions (Valence, Arousal, Dominance)
#'
#' @description
#' A dataset containing scores for 6,905
#' Italian lexical entries (lemmas and emojis) on the VAD dimensions
#' (Valence, Arousal, and Dominance; see Russell 1980)
#'
#' This dataset is a subset of the broader ELIta framework.
#' See [`elita_basic`], for basic discrete emotions (Plutchik's wheel).
#'
#' @docType data
#' @keywords lexicon
#' @name elita_VAD
#' @usage data(elita_VAD)
#' @format A tibble with 6,905 rows and 4 columns:
#' \describe{
#'   \item{lemma}{Italian lemmas and emojis (character).}
#'   \item{valenza}{Valence (unpleasant - pleasant): -4, +4 (double).}
#'   \item{attivazione}{Arousal (calm - excited/active): -4, +4 (double). }
#'   \item{dominanza}{Dominance (submissive/controlled - dominant/in control): -4 to +4 (double). }
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
#'Russell, J. A. (1980). A circumplex model of affect. *Journal of Personality and Social Psychology*, 39(6), 1161–1178.
#' @source
#'GitHub Repository: \url{https://github.com/elianadipalma/ELIta}
#' @note
#' The dataset is distributed under the Creative Commons Universal License (CC0 1.0).
#' @seealso
#' [`elita_basic`], [get_elita()].
#'
#' @examples
#' data(elita_VAD)
#'
#' # To rescale scores to -1, + 1
#' get_elita(dict = "elita_VAD")
"elita_VAD"
