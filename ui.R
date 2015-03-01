library(shiny)
library(choroplethrMaps)

data(state.regions, package="choroplethrMaps")

shinyUI(fluidPage(

  titlePanel("Analaysis of US State Violent Crime Rates (1960-2010)"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Year:",
                  sep="",
                  min = 1960,
                  max = 2010,
                  value = 2010),
      
      sliderInput("num_buckets",
                  "Number of colors:",
                  sep="",
                  min = 1,
                  max = 9,
                  value = 7),
      
      checkboxInput("show_abb",
                    "Show State Abbreviations",
                    value = FALSE),

      checkboxInput("include_dc",
                    "Include District of Columbia",
                    value = FALSE),
      
      selectInput("zoom", 
                  label = "Zoom",
                  choices = state.regions$region,
                  multiple = TRUE)
    ),

    mainPanel(
      plotOutput("map"),
      plotOutput("single_hist"),
      plotOutput("all_hist")
    )
  )
))
