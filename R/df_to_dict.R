#' Convert a data frame to a Quanteda dictionary with polarity or valence
#'
#' @description
#' Converts a data frame (tibble) containing a lexicon into a Quanteda dictionary
#' with valence or polarity. 
#' Requires the package *Quanteda*. If the `quanteda.sentiment` package is also 
#' installed,
#' the polarity or valence attributes will be detected and assigned automatically. 
#' Otherwise, 
#' a standard Quanteda dictionary will be created.
#'
#' The function is a wrapper for [df_to_valence()] and [df_to_polar()],
#' automatically determining, where possible,
#' the most appropriate type of dictionary for the input
#' data frame (see Details).
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
#' @param type The type of dictionary to create. Can be `"auto"` (the default),
#'   `"valence"`, or `"polarity"`.
#' @param polar_field A string with the name of the column containing the
#'   categories (polarities; i.e. "Positive", "Negative").
#'   Defaults to `"polarity"`. Ignored for valence dictionaries.
#' @param polar_map A named character vector to manually map dictionary keys
#'   to standard polarity values (`pos`, `neg`, `neut`). Example:
#'   `c(pos = "Positive", neg = "Negative")`. If `NULL` (default), the
#'   function will attempt to auto-detect the mapping.
#'
#' @details
#' The function handles the sentiment scores or categories as follows:
#' *   **Valence Dictionaries**: The names of the numeric columns are used
#'     as dictionary keys. When there is only one
#'     numeric column, the `word_field` is used as the key name
#'     (see `quanteda.sentiment::valence` if installed).
#' *   **Polarity Dictionaries**:
#'     *  The character or factor column (other
#'        than the `word_field`) is used to group terms into the categories
#'        (`polar_field`) that are then associated with the standard
#'        "polarity" attribute ("`pos`", "`neg`", optionally "`neut`";
#'        see `quanteda.sentiment::polarity` if installed).
#'     *  The "polarity" attribute is assigned via the `polar_map` argument, or
#'        automatically if the categories in the `polar_field` are explicit:
#'        "positive", "negative" (and, optionally, "neutral"; case-insensitive).
#'
#' @seealso
#'  [df_to_dict()], [df_to_polar()],
#'  \code{\link[quanteda]{dictionary}}
#'
#' @return A `quanteda::dictionary2` object.
#' @export
#' @examples
#' \dontrun{
#' # only numeric fields are present
#' my_dict <- get_sentix()
#' df_to_dict(my_dict)
#'
#' # no numeric fields are present
#' my_dict <- get_sentix(polarity = TRUE)
#' df_to_dict(my_dict)
#' }
df_to_dict <- function(x,
                       word_field = NULL,
                       type = "auto",
                       polar_field = "polarity",
                       polar_map = NULL) {
  if (!is.data.frame(x)) {
    stop("Input 'x' must be a data.frame or tibble.")
  }
  .check_quanteda_pkgs()
  
  # type
  numeric_cols <- names(x)[sapply(x, is.numeric)]
  has_numeric <- length(numeric_cols) > 0
  has_categorical <- polar_field %in% names(x)
  
  if (type == "auto") {
    if (has_numeric) {
      type <- "valence"
    } else if (has_categorical) {
      type <- "polarity"
    } else {
      stop("Could not detect dictionary type. Please specify `type`.")
    }
  }
  if (type == "valence") {
    # Check per avvisare l'utente di argomenti inutili
    if (!is.null(polar_map) || !missing(polar_field)) {
      message(
        "Note: arguments `polar_field` and `polar_map` are ignored for valence dictionaries."
      )
    }
    
    return(df_to_valence(x, word_field = word_field))
  } else if (type == "polarity") {
    return(
      df_to_polar(
        x,
        word_field = word_field,
        polar_field = polar_field,
        polar_map = polar_map
      )
    )
  } else {
    stop("Invalid `type`. Choose from 'auto', 'valence', or 'polarity'.")
  }
}
