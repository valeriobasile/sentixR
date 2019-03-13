# sentixR
R package to perform sentiment analysis on Italian using sentix

# Install

R CMD INSTALL sentix_0.0.0.9000.tar.gz

# Use

    > library(sentix)
    Loading required package: udpipe
    > model <- load.udpipe()
    > sentix.sentiment("oggi è una bella giornata", model)
    [1] 0.4701146
