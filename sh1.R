library(tidyverse)
library(shiny)
library("shinyWidgets")
library("DT")
library("shinycssloaders")
library("shinydashboard")
#==============
# GET WORLD MAP
#==============

ui <- fluidPage(
  title = "Hi",
  titlePanel("Title here"),
  "Hi world",
  br(),
  
  selectInput(
    inputId = "fi",
    label = "Vælg et tal",
    choices=c(1:10)
  ),
  numericInput(
    inputId = "si",
    label = "Vælg et tal",
    value = 5,
    min = 1,max = 20,step = 1
  ),
  
  verbatimTextOutput( "power")
)

server <- function(input,output) {
  observe({
    print(input$fi)
    print("Kuer")
  })
  make_power <- function(x,y) {as.numeric(x)**as.numeric(y)}
  output$power <- renderText({ make_power(input$fi,input$si) })
  
}
shinyApp(ui,server)

# create plot


