#' Internal utility functions
#'
#' @keywords internal
#' @noRd

# Checks if quanteda is installed
.check_quanteda_pkgs <- function() {
  if (!requireNamespace("quanteda", quietly = TRUE)) {
    stop("Package `quanteda` is required for this function.", call. = FALSE)
  }
}

# Auto-detects the word field if not specified
.find_word_field <- function(x, word_field) {
  if (!is.null(word_field)) {
    return(word_field)
  }
  
  if ("lemma" %in% names(x)) {
    return("lemma")
  } else if ("word" %in% names(x)) {
    return("word")
  } else {
    # Find first character column
    char_cols <- names(x)[sapply(x, is.character)]
    if (length(char_cols) > 0) {
      found_col <- char_cols[1]
      message(
        paste(
          "`word_field` not specified. Using the first character column found:",
          found_col
        )
      )
      return(found_col)
    } else {
      stop("No character column found to use as `word_field`.")
    }
  }
}

# Generic argument validator
.validate_arg <- function(arg_value, valid_options, arg_name) {
  if (!(arg_value %in% valid_options)) {
    stop(paste0(
      "Unsupported ",
      arg_name,
      ". Please choose one of: ",
      paste(valid_options, collapse = ", ")
    ))
  }
}
