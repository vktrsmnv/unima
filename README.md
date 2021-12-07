# Term Paper Template for Uni Mannheim
This R package provides a template for writing term papers for Uni Mannheim in R Markdown, and compiling to PDF via the LaTeX.


## Installation
``` r
# The package isn't on CRAN - install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("vktrsmnv/unima-template")
library(unima)
```

## Usage
The easiest way to use the template is with RStudio, via *File -> New File -> R Markdown...*.
In the dialog box, click 'From Template', then find the new 'Uni Mannheim Term Paper' option, choose a name for your manuscript (e.g., 'LastnameDataessay'), then click OK. 
Alternatively, you can run this line in the Console:

``` r
rmarkdown::draft(file = "LastnameDataessay.Rmd", template = "unima", package = "unima", create_dir = TRUE)
```

A new folder named *LastnameDataessay* is created, and you see an open **LastnameDataessay.Rmd** file.

If you click 'Knit', it compiles to the example PDF output with the illustration content from **LastnameDataessay.Rmd**.

By default, the template creates a subfolder inside you working directory folder (i.e. you Rstudio project). 
If you want the files instead to be added to your project directory without adding an extra subfolder, run this:

``` r
rmarkdown::draft(file = "LastnameDataessay.Rmd", template = "unima", package = "unima", create_dir = FALSE)
```

