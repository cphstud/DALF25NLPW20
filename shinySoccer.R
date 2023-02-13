library(shiny)
library(purrr)
library(DT)
library(ggplot2)
library(dplyr)


players=read.csv("allplayers.csv")

ui <- fluidPage(
  titlePanel("Soccer player data"),
  sidebarLayout(
    sidebarPanel(
      h3("Select the categorial variable:"),
      selectizeInput(inputId = "var","frequency of variable",select="", choices=c("vore","genus","order","conservation")),
      br(),
      h3("Select the numerical variable:"),
      selectizeInput(inputId = "catvar","distribution of variable",select="brainwt", choices=c("vore","genus","order","conservation")),
      br(),
      sliderInput("size","Size of points on graf",min = 1,max = 10,value = 5,step = 1),
      checkboxInput("consv",h3("Color Code consv statu", style="color:red;"),FALSE)
    ),
    mainPanel(
      plotOutput("sleepPlot"),
      plotOutput("distPlot"),
      textOutput("info"),
      tableOutput("table")
    )
  )
)

server <- function(input,output) {
  # handle output
  observe({print(input$var)})
  
  output$sleepPlot <- renderPlot(
    ggplot(df, aes_string(x=input$var)) +
      geom_bar()
  )
  output$distPlot <- renderPlot(
    ggplot(df, aes_string(x=input$numvar)) +
      geom_histogram()
  )
  # )
  # output$uiidoftext <- renderText(
  #   # words
  # )
  # output$uiidoftable <- renderTable(
  #   # words
  # )
  # 
  # handle input
}



shinyApp(ui = ui, server = server)

