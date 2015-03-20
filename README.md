# An Analysis of US State Historic Crime Rates

This application contains an interactive analysis of US historic crime rates using the R programming language and the [shiny](http://shiny.rstudio.com/) framework. 

You can view the running application [here](https://arilamstein.shinyapps.io/state-crime-rate-analysis/), though if you see an error message that means that I have exausted my free monthly quota at [shinyapps.io](http://www.shinyapps.io/). In that case you can install the application yourself by typing the following from an R console:

```
# install.packages("shiny")
library(shiny)
shiny::runGitHub("state-crime-analysis", "arilamstein")
```