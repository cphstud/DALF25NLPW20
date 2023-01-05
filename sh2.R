library(tidyverse)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(shinycssloaders)
library(shinydashboard)


#ui <- fluidPage(
ui <- dashboardPage(
  
  dashboardHeader(
    title = "COV-19",
    titleWidth=350
  ),
  
  dashboardSidebar(
    width=350,
    br(),
    h4("Select inpulllt here", style = "padding-left:20px")
  ),
  
  dashboardBody(
    
  )
)

server <- function(input,output,session) {
  
}

shinyApp(ui,server)
