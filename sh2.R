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
   # create tabs 
    tabsetPanel(
      type="tabs",
      #type="pills",
      id="ts",
      tabPanel(
        title="Country View"
      ),
      tabPanel(
        title="T2",
        "Tab 2"
      )
    )
  )
)

server <- function(input,output,session) {
  
}

shinyApp(ui,server)
