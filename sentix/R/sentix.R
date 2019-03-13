#' Sentix
#'
#' A package to compute the sentiment polarity of Italian text using the Sentix lexicon.
#' @keywords sentiment
#' @export load.udpipe sentix.sentiment

sentix.file <- system.file("extdata", "sentix_lemma2.0.tsv", package = "sentix")
udmodel.file <- system.file("extdata", "italian-isdt-ud-2.3-181115.udpipe", package = "sentix")

# load the sentix lexicon
sentix <- read.delim(sentix.file, header=F, quote="", colClasses=c("character", "numeric"))
names(sentix) <- c("lemma", "value")

# function to tokenize and lemmatize the input text using UDpipe
get_lemmas <- function(txt, model){
  annotation <- as.data.frame(udpipe_annotate(model, x = txt))
  return (annotation$lemma)
}

#function to tokenize and lemmatizethe input dataframe using udpipe
get_df_lemmas <- function(txt, model){
  annotation <- as.data.frame(udpipe_annotate(model, x = txt, doc_id = paste("doc", seq_along(txt))))
  new.df <- subset(annotation, select= c("doc_id", "lemma"))
  return (new.df)
}

# function to compute the total sentiment of a text using Sentix
sentix.sentiment <- function(txt, model) {
  lemmas <- get_lemmas(txt, model)
  values <- sentix$value[sentix$lemma %in% lemmas]
  if (length(values) < 1) {
    return (0.0)
  }
  return (mean(values))
}

# function to compute the total sentiment for each document in a dataframe using sentix
#This function requires dplyr!
library(dplyr)
sentix.df.sentiment <- function(txt, model) {
  lemmas <- get_df_lemmas(txt, model)
  sent <- inner_join(lemmas, sentix, by = "lemma")
  sentiment <- sent %>%
    group_by(doc_id) %>%
    mutate(sentimentXdoc = mean(value))

  if (length(sent2$value) < 1) {
    return (0.0)
  }
  return (sentiment)
}



# function to initialize the model
load.udpipe <- function(model.file = udmodel_file) {
  # load the UDpipe model for italian
  udmodel.italian <- udpipe_load_model(file = udmodel.file)
  return (udmodel.italian)
}
