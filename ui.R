library(shiny)
library(choroplethrMaps)
require(markdown)

data(state.regions, package="choroplethrMaps")

shinyUI(fluidPage(

  titlePanel("Analysis of US State Violent Crime Rates (1960-2010)"),

  fluidRow(column(12, includeMarkdown("1.md"))),
  
  fluidRow(column(12, includeMarkdown("2.md"))),
  
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

    mainPanel(plotOutput("map")),
    
  ),
  
  fluidRow(column(12, includeMarkdown("3.md"))),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("states", 
                  label = "States",
                  choices = state.regions$region,
                  selected = c("california", "new york", "texas", "florida"),
                  multiple = TRUE)
    ),
    
    mainPanel(plotOutput("time_series")),
    
  )
  
))
