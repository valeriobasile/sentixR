#' Get ELIta-family Lexicons
#'
#' @description
#' A utility function to access ELIta-family lexicons ([`elita_basic`],
#' [`elita_VAD`]) with convenient defaults.
#'
#' For all lexicons, it returns the key entry (`lemma` or `word`) and `score`
#' columns, suitable for joining.
#'
#' For `elita_VAD`, which contains scores on a -4 to +4 scale, scores are
#' "centered" by default (divided by 4 to map to a -1 to +1 theoretical range).
#' @keywords functions
#' @param dict The name of the lexicon to retrieve. Must be one of:
#'   `"elita_VAD"` (default) or `"elita_basic"`.
#' @param rescale Character string indicating the rescaling method applied to
#'   the scores. Options are:
#'   \itemize{
#'     \item{\code{"default"}: For `elita_VAD` = `"centered"`. For `elita_basic` = `"none"`.}
#'     \item{\code{"none"}: No rescaling is applied.}
#'     \item{\code{"centered"}: Scores are divided by their theoretical maximum (4 for `elita_VAD`) to map to -1/+1.}
#'     \item{\code{"normalized"}: Scores are normalized empirically to -1/+1 (`score / max(abs(.x), na.rm = TRUE)`).}
#'   }
#'   This argument only applies `elita_VAD`. `elita_basic` scores are within
#'   0,1,
#' @return A `tibble`.
#'
#' @export
#' @importFrom dplyr %>% mutate across
#' @importFrom tidyselect where
#'
#' @seealso
#' [`elita_VAD`], [`elita_basic`], [get_sentix()]
#' @examples
#' \dontrun{
#' # Get the default elita_VAD lexicon (centered scores)
#' my_dict_VAD <- get_elita("elita_VAD")
#'
#' # Get elita_VAD without any rescaling
#' my_dict_VAD <- get_elita("elita_VAD", rescale = "none")
#'
#' # Get elita_basic lexicon
#' my_dict_basic <- get_elita("elita_basic")
#' }
get_elita <- function(dict = "elita_VAD", rescale = "default") {
  # Check supported dictionaries
  supported_dicts <- c("elita_VAD", "elita_basic")
  .validate_arg(dict, supported_dicts, "lexicon")
  
  # Check supported rescaling methods
  supported_rescale <- c("default", "none", "centered", "normalized")
  .validate_arg(rescale, supported_rescale, "rescaling method")
  
  # Load the dataset
  lexicon <- get(dict)
  
  # Apply rescaling
  if (dict == "elita_VAD") {
    if (rescale == "centered" ||
        (rescale == "default" && dict == "elita_VAD")) {
      lexicon <- lexicon %>%
        mutate(across(where(is.numeric), ~ .x / 4))
    } else if (rescale == "normalized") {
      lexicon <- lexicon %>%
        mutate(across(where(is.numeric), ~ .x / max(abs(.x), na.rm = TRUE)))
    } else if (rescale == "none" && dict == "elita_VAD") {
      
    }
  } else if (dict == "elita_basic" && rescale != "default") {
    warning(
      paste(
        "Rescaling is not applicable to 'elita_basic'.",
        "No rescaling was performed."
      )
    )
  }
  return(lexicon)
}
