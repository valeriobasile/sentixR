#' Classify sentiment scores into polarity categories
#'
#' @description
#' Utility function for adding polarity columns to sentiment lexicons, to be used
#' within \code{\link[dplyr]{mutate}}.
#'
#' Classifies numeric sentiment scores into "positive", "negative", or "neutral",
#' based on a specified threshold (defaults to 0).
#'
#' @keywords functions
#' @param score A numeric vector of sentiment scores.
#' @param threshold A numeric vector. 
#'   If length 1 (i.e. `threshold = 0.125)`), it must be a positive value, 
#'   that will be used as absolute 
#'   threshold; if length 2 (i.e. `threshold = c(0.125, -0.135)`), it must 
#'   contain one positive (or 0) and one negative (or 0) value. 
#'   Defaults to 0.
#'   
#'   Scores `>= threshold` and `<= -threshold` will be classified as "positive" 
#'   and "negative", respectively. 0 is always classified as "neutral".
#' 
#' @return A character vector with "positive", "negative", or "neutral".
#' @importFrom dplyr case_when
#' @examples
#' \dontrun{
#' library(dplyr)
#' sentix |> 
#'   mutate(polarity = make_polarity(score))
#'
#' # with custom threshold
#' elita_VAD |>
#'   mutate(across(where(is.numeric), 
#'                       ~ make_polarity(.x, 0.125)))
#'   
#' # with custom asymmetric thresholds
#' get_sentix("MAL") |> 
#'  mutate(polarity = make_polarity(score, 
#'                                  threshold = c(0.125, -0.135)))
#'
#' # with the results of sentix_annotate
#' sentix_annotate(recensioni_tv, model = "local")  |> 
#'   mutate(polarity = make_polarity(score, .125)) 
#' }
#' @export
make_polarity <- function(score, threshold = 0) {
  if (!is.numeric(score)) stop("`score` must be numeric.")

  if (length(threshold) == 1) {
    if (threshold < 0) stop("`threshold` must be a positive value.")
    pos_cut <- threshold
    neg_cut <- -threshold
  } else if (length(threshold) == 2) {
    if (max(threshold) < 0 || min(threshold) > 0) {
      stop("When providing two values, `threshold` must contain one positive (or 0) and one negative (or 0) value.")
    }
    pos_cut <- max(threshold)
    neg_cut <- min(threshold)
  } else {
    stop("`threshold` must be a numeric vector of length 1 or 2.")
  }

  dplyr::case_when(
    score == 0 ~ "neutral",
    score >= pos_cut ~ "positive",
    score <= neg_cut ~ "negative",
    TRUE ~ "neutral"
  )
}
