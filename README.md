# sentixR
R package to perform sentiment analysis on Italian using sentix

# Install

R CMD INSTALL sentix_0.1.tar.gz

# Use

    > library(sentix)
    Loading required package: udpipe
    > model <- load.udpipe()
    > sentiment("oggi è una bella giornata")
    [1] 0.3121985
