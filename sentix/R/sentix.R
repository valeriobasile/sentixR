#' Sentix
#'
#' A package to compute the sentiment polarity of Italian text using the Sentix lexicon.
#' @param txt The text to analyze.
#' @keywords sentiment
#' @export sentiment
#' @examples
#' sentiment()

# load the sentix lexicon
sentix <- read.delim("sentix_lemma2.0.tsv", header=F, quote="", colClasses=c("character", "numeric"))
names(sentix) <- c("lemma", "value")


# function to tokenize and lemmatize the input text using UDpipe
get_lemmas <- function(txt){
  # load the UDpipe model for italian
  udmodel_italian <- udpipe_load_model(file = "italian-isdt-ud-2.3-181115.udpipe")
  annotation <- as.data.frame(udpipe_annotate(udmodel_italian, x = txt))
  return (annotation$lemma)
}

# function to compute the total sentiment of a text using Sentix
sentiment <- function(txt) {
  lemmas <- get_lemmas(txt)
  values <- sentix$value[sentix$lemma %in% lemmas]
  if (length(values) < 1) {
    return (0.0)
  }
  return (mean(values))
}
