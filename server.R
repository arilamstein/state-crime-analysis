list.of.packages <- c("choroplethr", "choroplethrMaps", "Quandl", "lubridate", "reshape2", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(choroplethr)
library(Quandl)
library(lubridate)
library(reshape2)
library(ggplot2)

# get and format the full crime dataset from Quandle
# See https://www.quandl.com/FBI_UCR/USCRIME_TYPE_VIOLENTCRIMERATE-U-S-Crimes-by-crime-Violent-Crime-Rate
df_quandl                 = Quandl("FBI_UCR/USCRIME_TYPE_VIOLENTCRIMERATE", authcode="zB7yia7wQxdazfUxxQv4")
colnames(df_quandl)       = tolower(colnames(df_quandl))
df_quandl$year            = year(df_quandl$year)
df_quandl$"united states" = NULL

# creates a df that's in a format for calls to boxplot()
source("boxplot.R")

get_data_by_year = function(year, include_dc)
{
  df           = df_quandl[df_quandl$year == year, -1]
  df           = data.frame(region = colnames(df), value=as.numeric(df[1,]), row.names=NULL)
  df$region    = as.character(df$region)
  if (!include_dc)
  {
    df = df[df$region != "district of columbia", ]
  }
  df
}

shinyServer(function(input, output) {
  observe({
    # get input from UI
    num_buckets = input$num_buckets
    year        = input$year
    show_abb    = input$show_abb
    include_dc  = input$include_dc
    states      = input$states
    zoom        = NULL
    if (length(input$zoom) > 0)
    {
      zoom = input$zoom
    }

    # get df
    df = get_data_by_year(year, include_dc)
    
    if (show_abb) {
      output$map <- renderPlot({
        state_choropleth(df, paste0(year, " State Violent Crime Rate"), "Crimes per 100,000 People", num_buckets, zoom)
      })
    } else {
      output$map <- renderPlot({
        choro              = StateChoropleth$new(df)
        choro$title        = paste0(year, " State Violent Crime Rate")
        choro$show_labels  = FALSE
        choro$legend       = "Crimes per 100,000 People"
        choro$set_zoom(zoom)
        choro$set_num_colors(num_buckets)
        choro$render()
      })
    }
    
    output$single_hist = renderPlot({
      boxplot(df$value, ylab = "Crimes per 100,000 People", main = paste0(year, " State Violent Crime Rate"))
    })
  
    output$all_hist = renderPlot({
      if (include_dc) {
        boxplot(df_boxplot[, -1], ylab = "Crimes per 100,000 People", main = "State Violent Crime Rate, All Years")
      } else {
        boxplot(df_boxplot[df_boxplot$region != "district of columbia", -1], ylab = "Crimes per 100,000 People", main = "State Violent Crime Rate, All Years\nExcluding Washington, DC")
      }
    })
    
    output$time_series = renderPlot({
      cols = c("year", input$states)
      df = df_quandl[, colnames(df_quandl) %in% cols]
      meltdf = melt(df,id="year")
      colnames(meltdf)[2] = "State"
      ggplot(meltdf, aes(x=year, y=value, colour=State, group=State)) + 
        geom_line() + 
        labs(x="Year", y="Crimes per 100,000 People", title="US State Crime Rate Over Time") 
      })
    
  })
})