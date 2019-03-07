#' Sentix
#'
#' A package to compute the sentiment polarity of Italian text using the Sentix lexicon.
#' @keywords sentiment
#' @export sentiment

sentix_file <- system.file("extdata", "sentix_lemma2.0.tsv", package = "sentix")
udmodel_file <- system.file("extdata", "italian-isdt-ud-2.3-181115.udpipe", package = "sentix")

# load the sentix lexicon
sentix <- read.delim(sentix_file, header=F, quote="", colClasses=c("character", "numeric"))
names(sentix) <- c("lemma", "value")


# function to tokenize and lemmatize the input text using UDpipe
get_lemmas <- function(txt){
  # load the UDpipe model for italian
  udmodel_italian <- udpipe_load_model(file = udmodel_file)
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
