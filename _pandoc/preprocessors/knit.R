## #!/usr/bin/env Rscript
# Requirements: kntir, docknitr
# Additional requirements when unsing tikz with knitr: magick, pdftools
# sink(file("/dev/null", "w"), type="message")
args <- commandArgs(trailingOnly = TRUE)
library(docknitr, quietly = TRUE)
quiet <- FALSE
if (length(args) > 2 && args[3] == "quiet") {
   quiet <- TRUE
}
options(texi2dvi = "lualatex")
options(tinytex.engine = "lualatex")
invisible(knitr::knit(args[1], args[2], quiet=quiet))
