#!/usr/bin/Rscript
# sink(file("/dev/null", "w"), type="message")
args <- commandArgs(trailingOnly = TRUE)
library(docknitr, quietly = TRUE)
quiet <- FALSE
if (length(args) > 2 && args[3] == "quiet") {
   quiet <- TRUE
}

invisible(knitr::knit(args[1], args[2], quiet=quiet))
