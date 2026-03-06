#' Get Sentix-family Lexicons
#'
#' @description
#' A utility function to access Sentix-family lexicons ([`sentix`], [`MAL`]
#' ) with convenient defaults.
#'
#' For all lexicons, it returns by default the key entry (`lemma` or `word`) and
#' `score`
#' columns, suitable for joining. Polarity classification can be computed via
#' [make_polarity()].
#'
#' Other columns (`polypathy_index`) are accessible via arguments.
#'
#'
#' @keywords functions
#' @param dict The name of the lexicon to retrieve. Must be one of: `"sentix"`
#'   (default) or `"MAL"`.
#' @param polypathy Logical. If `TRUE`, the `polypathy_index` column
#'   is included. Defaults to `FALSE`.
#' @param polarity Logical. If `TRUE`, a polarity column is added (computed
#'   via [`make_polarity`]). Defaults to `FALSE`.
#' @param polar_field Character string. The name of the new polarity column.
#'   Defaults to `"polarity"`.
#' @param threshold Numeric. The threshold for [`make_polarity`] (positive value).
#'   Scores within `[-threshold, threshold]` are considered neutral. Defaults to 0.
#'
#' @return A `tibble`.
#'
#' @export
#' @importFrom dplyr %>% select any_of mutate across
#' @importFrom rlang :=
#' @importFrom tidyselect where
#'
#' @seealso
#' [`sentix`], [`MAL`], [get_elita()], [make_polarity()]
#' @examples
#' \dontrun{
#' # Get the default sentix lexicon (key and score)
#' my_dict <- get_sentix()
#'
#' # Get the sentix lexicon with polarity field
#' my_dict <- get_sentix(polarity = TRUE)
#'
#' # Get MAL and polypathy index
#' my_dict_poly <- get_sentix("MAL", polypathy = TRUE)
#' }
get_sentix <- function(dict = "sentix",
                       polypathy = FALSE,
                       polarity = FALSE,
                       polar_field = "polarity",
                       threshold = 0) {
  # Check for supported dictionaries
  supported_dicts <- c("sentix", "MAL")
  .validate_arg(dict, supported_dicts, "lexicon")
  
  # Load the dataset
  lexicon <- get(dict)
  
  # Identify key entry column
  key_col <- if ("lemma" %in% names(lexicon))
    "lemma"
  else
    "word"
  
  # Select columns
  cols_to_keep <- c(key_col, "score")
  if (polypathy && "polypathy_index" %in% names(lexicon)) {
    cols_to_keep <- c(cols_to_keep, "polypathy_index")
  }
  
  if (polarity) {
    lexicon <- lexicon %>%
      mutate(!!polar_field := make_polarity(score, threshold = threshold))
    cols_to_keep <- c(cols_to_keep, polar_field)
    cols_to_keep <- setdiff(cols_to_keep, "score")
  }
  
  lexicon <- lexicon %>%
    select(any_of(cols_to_keep))
  
  return(lexicon)
}
