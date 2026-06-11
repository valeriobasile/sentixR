#' Convert a data frame to a Quanteda polarity dictionary
#'
#' @description
#' Converts a data frame (tibble) containing a lexicon into a Quanteda dictionary
#' with polarity, to be used with `quanteda.sentiment::textstat_polarity()`.
#' Requires the package *Quanteda*. If the `quanteda.sentiment` package is also 
#' installed,
#' the polarity attribute will be detected and assigned automatically. 
#' Otherwise, a standard Quanteda dictionary will be created.
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
#' @param polar_field A string with the name of the column containing the
#'   categories (polarities; i.e. "Positive", "Negative").
#'   Defaults to `"polarity"`.
#' @param polar_map A named character vector to manually map dictionary keys
#'   to standard polarity values (`pos`, `neg`, `neut`). Example:
#'   `c(pos = "Positive", neg = "Negative")`. If `NULL` (default), the
#'   function will attempt to auto-detect the mapping.
#'
#' @details
#' The function handles the sentiment categories as follows:
#' *  The character or factor column (other
#'    than the `word_field`) is used to group terms into the categories
#'    (`polar_field`) that are then associated with the standard
#'    "polarity" attribute ("`pos`", "`neg`", optionally "`neut`";
#'    see `quanteda.sentiment::polarity` if installed).
#' *  The "polarity" attribute is assigned via the `polar_map` argument, or
#'    automatically if the categories in the `polar_field` are explicit:
#'    "positive", "negative" (and, optionally, "neutral"; case-insensitive).
#'
#' @seealso
#'  [df_to_dict()], [df_to_valence()],
#'  \code{\link[quanteda]{dictionary}}
#'
#' @return A `quanteda::dictionary2` object.
#' @export
#' @examples
#' if(requireNamespace("quanteda")){
#' # Create a polarity dictionary from sentix
#' my_dict <- get_sentix(polarity = TRUE)
#' my_pol_dict <- df_to_polar(my_dict)
#' }
df_to_polar <- function(x,
                        word_field = NULL,
                        polar_field = "polarity",
                        polar_map = NULL) {
  if (!is.data.frame(x)) {
    stop("Input 'x' must be a data.frame or tibble.")
  }
  .check_quanteda_pkgs()
  
  # word_field
  word_field <- .find_word_field(x, word_field)
  
  
  if (!(polar_field %in% names(x))) {
    stop(
      "Polarity field not found in the data frame.\nPlease use `polar_field` to specify it manually, or choose `type = 'valence'`."
    )
  }
  
  x <- x[!is.na(x[[polar_field]]) & !is.na(x[[word_field]]), ]
  final_list <- split(x[[word_field]], x[[polar_field]])
  quanteda_dict <- quanteda::dictionary(final_list)
  polarity_list <- list()
  if (!is.null(polar_map)) {
    if (!is.character(polar_map) || is.null(names(polar_map))) {
      stop("polar_map must be a named character vector.")
    }
    polarity_list <- as.list(polar_map)
  } else {
    dict_keys <- names(final_list)
    lk <- tolower(dict_keys)
    if (any(lk %in% c("positive", "pos"))) {
      polarity_list$pos <- dict_keys[lk %in%
                                             c("positive", "pos")]
    }
    if (any(lk %in% c("negative", "neg"))) {
      polarity_list$neg <- dict_keys[lk %in%
                                             c("negative", "neg")]
    }
    if (any(lk %in% c("neutral", "neut"))) {
      polarity_list$neut <- dict_keys[lk %in%
                                               c("neutral", "neut")]
    }
  }
  
  pkg <- "quanteda.sentiment"
  if (requireNamespace(pkg, quietly = TRUE)) {
    if (length(polarity_list) > 0) {
      ns <- asNamespace(pkg)
      `polarity<-` <- get("polarity<-", envir = ns)
      quanteda_dict <- `polarity<-`(quanteda_dict, value = polarity_list)
    } else {
      warning(
        "Polarity attributes were not assigned. Auto-detection failed. Please use `polar_map` to specify the mapping manually",
        call. = FALSE
      )
    }
  }
  
  return(quanteda_dict)
}
