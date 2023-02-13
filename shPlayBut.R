library(DBI)
library(RMariaDB)
library(tidyverse)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(shinycssloaders)
library(shinydashboard)

data.eurodan=readRDS("tpreviews.rds")

conrv <- dbConnect(MariaDB(),
                   host="localhost",
                   user="root",
                   password="root123",
                   db="reviews"
                   )


#sqlInterpolate()

dbWriteTable(conrv,"reviews",data.eurodan, overwrite = TRUE)

ui <- fluidPage(
  titlePanel("Button"),
  sidebarPanel(
    textInput("name","Your name"),
    textInput("role","Your job"),
    actionButton("submit","Update")
  ),
  mainPanel(
    textOutput("n1",container = span),
    textOutput("n2",concontainer = span)
  )
)

server <- function(input,output,session) {
  on1 <- renderText({
    isolate(paste("Jeg hedder ",input$name))
  })
  on2 <- renderText({
    isolate(paste("Jeg hedder ",input$role))
  })
  observe({
    input$submit
    output$n1 <- on1
    output$n2 <- on2
  })
}

shinyApp(ui=ui, server=server)