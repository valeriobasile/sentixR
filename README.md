# sentixR
R package to perform sentiment analysis on Italian using sentix

# Install

R CMD INSTALL sentix_0.0.0.9000.tar.gz

# Use

## To analyse a single document
    > library(sentix)
    Loading required packages: udpipe, dplyr
    > model <- load.udpipe()
    > sentix.sentiment("oggi è una bella giornata", model)
    [1] 0.4701146

## To analyse a dataframe of documents

    > df <- data.frame(id = c(1,2,3), text = c("Oggi è una bella giornata",
                                               "Non mi sento molto bene",
                                               "Il sole splende, ma c'è un brutto vento"))
    > model <- load.udpipe()
    > sentix.df.sentiment(df$text, model)
       A tibble: 9 x 4
       Groups:   doc_id [3]
       doc_id lemma      value sentimentXdoc
        <chr>  <chr>      <dbl>         <dbl>
      1 doc 1  oggi     0.199          0.470
      2 doc 1  bello    0.741          0.470
      3 doc 2  non     -0.583         -0.0242
      4 doc 2  sentire -0.00604       -0.0242
      5 doc 2  molto    0.104         -0.0242
      6 doc 2  bene     0.389         -0.0242
      7 doc 3  sole     0.225          0.162
      8 doc 3  ma       0.875          0.162
      9 doc 3  brutto  -0.615          0.162
