#' Convert a data frame to a Quanteda valence dictionary
#'
#' @description
#' Converts a data frame (tibble) containing a lexicon into a Quanteda dictionary 
#' with valence, to be used with `quanteda.sentiment::textstat_valence()`.
#' Requires the package *Quanteda*. If the `quanteda.sentiment` package is also 
#' installed,
#' the valence attribute will be detected and assigned automatically. Otherwise, 
#' a standard Quanteda dictionary will be created.
#'
#' **Note:** The function cannot handle duplicate entries,
#' and will remove rows with NAs.
#' @keywords functions
#' @param x A `data.frame` or `tibble` with at least one character
#'    column with the terms, and either numeric columns (scores) or a
#'    categorical column (with polarity).
#' @param word_field A string with the name of the column containing the terms.
#'   If `NULL` (the default), the function will try to
#'   detect a column named "lemma" or "word".
#'   If neither is found, it selects the first character column available.
#'
#' @details
#' The names of the numeric columns are used as dictionary keys. When there is
#' only one numeric column, the `word_field` is used as the key name
#' (see `quanteda.sentiment::valence` if installed).
#'
#' 
#' @seealso
#' [df_to_dict()], [df_to_polar()],
#'  \code{\link[quanteda]{dictionary}}
#'
#' @return A `quanteda::dictionary2` object.
#' @export
#' @examples
#' if(requireNamespace("quanteda")){
#' # Create a valence dictionary from elita_VAD
#' data(elita_VAD)
#' elita_dict <- df_to_valence(elita_VAD)
#' }
df_to_valence <- function(x, word_field = NULL) {
  if (!is.data.frame(x)) {
    stop("Input 'x' must be a data.frame or tibble.")
  }
  .check_quanteda_pkgs()
  
  # word_field
  word_field <- .find_word_field(x, word_field)
  
  # scores
  numeric_cols <- names(x)[sapply(x, is.numeric)]
  is_single_score_dict <- length(numeric_cols) == 1
  
  dict_list <- list()
  valence_list <- list()
  for (score_col in numeric_cols) {
    entries <- x[!is.na(x[[score_col]]) & x[[score_col]] !=
                   0, ]
    if (nrow(entries) == 0) {
      next
    }
    terms <- entries[[word_field]]
    scores <- entries[[score_col]]
    # unica colonna
    key_name <- if (is_single_score_dict) {
      word_field
    } else {
      score_col
    }
    dict_list[[key_name]] <- terms
    valence_list[[key_name]] <- stats::setNames(scores, terms)
  }
  if (length(dict_list) == 0) {
    stop("No valid entries found for valence dictionary.")
  }
  quanteda_dict <- quanteda::dictionary(dict_list)
  pkg <- "quanteda.sentiment"
  if (requireNamespace(pkg, quietly = TRUE)) {
    ns <- asNamespace(pkg)
    `valence<-` <- get("valence<-", envir = ns)
    quanteda_dict <- `valence<-`(quanteda_dict, value = valence_list)
  }
  return(quanteda_dict)
}
