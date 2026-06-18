#' Summarize sentiment annotations
#'
#' @description
#' Calculates sentiment scores and, optionally, ambiguity metrics, aggregating
#' token-level sentiment annotations to the document level.
#' @keywords functions
#' @param x A data frame containing at least a `doc_id` column and numeric
#'   columns with sentiment scores.
#' @param aggregation Character. `"mean"` (default) or `"sum"`.
#' @param cols Character vector, specifying columns to summarize. If `NULL`
#'   (default), numeric columns will be automatically considered as scores.
#' @param by Character vector, specifying the column(s) to group by. Defaults
#'   to `doc_id`.
#' @param simplify Logical. Defaults to `FALSE`. When `TRUE`, the output will
#'   contain only basic measures (`score` and, where applicable `ambiguity`).
#' @param ambiguity Character. The minimum `polypathy_index` value to
#'   be considered. Can be `"1"`, `"2"`, `"3"` (default), or `"none"`
#'   to disable ambiguity calculation (see Details).
#'   Ignored if the column `polypathy_index` is not present in the input.
#' @details
#' This function takes the output of [sentix_annotate()] or a data frame or
#' tibble withat least a `doc_id` column and sentiment scores (numeric columns).
#'
#' **Metrics Calculated:**
#' * `score`: the average (or sum) of the sentiment columns.
#' * `ambiguity`: `n_poly / n_scored` (if `polypathy_index` is present).
#' * `n_tokens`: total valid tokens, excluding punctuation. UDpipe's CoNLL-U
#'      format expands Multi-Word Tokens (MWTs) into their syntactic components,
#'      including articulated prepositions: e.g., 'nella' becomes 'in' + 'la'.
#'      The count only considers the components (e.g., 'nella' counts for 2
#'      tokens, not 3).
#' * `n_scored`: tokens with _at least one_ sentiment score.
#' * `n_poly`: count of ambiguous tokens, based on the `ambiguity` level
#'      setting, and if the column `polypathy_index` is present in the lexicon.
#' @examples
#' \dontrun{
#' # This example is not executed because it requires the udpipe package and
#' # downloading a model
#' testo <- "Oggi è una bella giornata. Uscirò a fare una passeggiata"
#' # With the output of sentix_annotate
#' ann_df <- sentix_annotate(testo, model = "local")
#' sentix_summarize(ann_df)
#' # With only basic measures
#' sentix_summarize(ann_df, simplify = TRUE)
#' # With custom grouping (e.g., per sentence)
#' sentix_summarize(ann_df, by =c("doc_id", "sentence_id"))
#' # With the output of sentix_annotate, ambiguity and other intermediate
#' # measures
#' ann_df <- sentix_annotate(testo,
#'                           polypathy = TRUE,
#'                           model = "local")
#' sentix_summarize(ann_df)
#' }
#' @seealso [get_sentix()], [`sentix`], [sentix_annotate()]
#' @return A `tibble` with one row per document.
#' @export
#' @importFrom dplyr group_by summarise mutate n across all_of select
#' @importFrom rlang .data
sentix_summarize <- function(
  x,
  aggregation = "mean",
  cols = NULL,
  by = "doc_id",
  simplify = FALSE,
  ambiguity = "3"
) {
  # check doc_id
  missing_groups <- setdiff(by, names(x))
  if (length(missing_groups) > 0) {
    stop(paste0(
      "Input data must contain the specified identifier column(s) (e.g. 'doc_id').\n",
      "Grouping columns not found: ",
      paste(shQuote(missing_groups), collapse = ", ")
    ))
  }

  # check ambiguity
  if (!ambiguity %in% c("1", "2", "3", "none")) {
    stop("Argument 'ambiguity' must be one of: '1', '2', '3', 'none'.")
  }

  # --- Identify sentiment columns ---
  if (is.null(cols)) {
    # with lexicons
    possible_cols <- c(
      "score",
      "valenza",
      "attivazione",
      "dominanza",
      "gioia",
      "tristezza",
      "rabbia",
      "disgusto",
      "paura",
      "fiducia",
      "sorpresa",
      "aspettativa",
      "amore"
    )
    score_cols <- intersect(names(x), possible_cols)

    if (length(score_cols) == 0) {
      # numeric columns, excluding udpipe output
      exclude_cols <- c(
        "doc_id",
        "paragraph_id",
        "sentence_id",
        "token_id",
        "head_token_id",
        "polypathy_index",
        "ambiguity",
        "start",
        "end",
        "term_id",
        "upos_id",
        "dep_rel",
        "misc"
      )
      numeric_cols <- names(x)[vapply(x, is.numeric, logical(1))]
      score_cols <- setdiff(numeric_cols, exclude_cols)
    }
  } else {
    # user defined cols
    missing_cols <- setdiff(cols, names(x))
    # error if one or more cols are not found
    if (length(missing_cols) > 0) {
      stop(paste(
        "Columns not found in data:",
        paste(missing_cols, collapse = ", ")
      ))
    }
    score_cols <- cols
  }

  # general warning (auto detection)
  if (length(score_cols) == 0) {
    warning("No numeric score columns found.")
    return(dplyr::distinct(x, .data$doc_id))
  }

  # --- Preprocessing ---

  # MWT containers
  if ("token_id" %in% names(x)) {
    is_mwt <- grepl("-", x$token_id, fixed = TRUE)
  } else {
    is_mwt <- rep(FALSE, nrow(x))
  }

  x <- x[!is_mwt, ]

  # Punctuation
  if ("upos" %in% names(x)) {
    is_punct <- x$upos == "PUNCT"
  } else if ("pos" %in% names(x)) {
    is_punct <- x$pos == "PUNCT"
  } else {
    is_punct <- rep(FALSE, nrow(x))
  }
  is_punct[is.na(is_punct)] <- FALSE

  # valid tokens
  x$is_valid <- !is_punct

  # check scored rows -> n_scored
  if (length(score_cols) > 0) {
    has_score_matrix <- !is.na(x[score_cols])
    x$.has_any_score <- rowSums(has_score_matrix, na.rm = TRUE) > 0
  }

  # --- Aggregation ---
  agg_fun <- if (aggregation == "sum") sum else mean

  # is_ambiguous if needed
  if (ambiguity != "none") {
    ambiguity_val <- as.numeric(ambiguity)

    is_ambiguous <- function(vals) {
      if (is.factor(vals)) {
        # retrieve labels instead of levels
        lvl_nums <- as.numeric(levels(vals))
        real_vals <- lvl_nums[vals]

        !is.na(real_vals) & real_vals >= ambiguity_val
      } else {
        # Fallback
        val_nums <- if (is.character(vals)) as.numeric(vals) else vals
        !is.na(val_nums) & val_nums >= ambiguity_val
      }
    }
  }

  # sentiment
  summary_df <- x |>
    dplyr::group_by(dplyr::across(dplyr::all_of(by))) |>
    dplyr::summarise(
      # Scores
      dplyr::across(
        dplyr::all_of(score_cols),
        ~ agg_fun(.x, na.rm = TRUE),
        .names = "{.col}"
      ),

      # n_poly:
      n_poly = if ("polypathy_index" %in% names(x) && ambiguity != "none") {
        sum(
          is_ambiguous(.data$polypathy_index) & .data$.has_any_score,
          na.rm = TRUE
        )
      } else {
        NA_real_
      },

      # n_scored
      n_scored = if (length(score_cols) > 0) {
        sum(.data$.has_any_score, na.rm = TRUE)
      } else {
        0
      },

      # n_tokens
      n_tokens = sum(.data$is_valid, na.rm = TRUE),

      .groups = "drop"
    )

  # ambiguity
  if ("polypathy_index" %in% names(x) && ambiguity != "none") {
    summary_df <- summary_df |>
      dplyr::mutate(
        ambiguity = dplyr::if_else(
          .data$n_scored > 0,
          .data$n_poly / .data$n_scored,
          0
        )
      )
  }

  # --- Output ---
  cols_to_keep <- c(by, score_cols)

  # ambiguity
  if ("polypathy_index" %in% names(x) && ambiguity != "none") {
    cols_to_keep <- c(cols_to_keep, "ambiguity")
  }

  # If simplify = FALSE
  if (!simplify) {
    cols_to_keep <- c(cols_to_keep, "n_tokens", "n_scored")
    if ("polypathy_index" %in% names(x) && ambiguity != "none") {
      cols_to_keep <- c(cols_to_keep, "n_poly")
    }
  }

  return(summary_df |> dplyr::select(dplyr::all_of(cols_to_keep)))
}
