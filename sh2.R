library(tidyverse)
library(tidyverse)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(shinycssloaders)
library(shinydashboard)
library(logr)
library(DBI)
library(RMariaDB)


con <- dbConnect(MariaDB(),
                 host="localhost",
                 user="root",
                 password="root123",
                 db="reviews"
)

source("baseTrustPilotScrape.R")

log_open("log/log.txt")


#ui <- fluidPage(
ui <- dashboardPage(
  
  dashboardHeader(
    title = "COV-19",
    titleWidth=350
  ),
  
  dashboardSidebar(
    width=350,
    br(),
    h4("Select input here", style = "padding-left:20px"),
   #  
   #  selectInput(
   #    inputId = "mtr",
   #    label = "Select Metric",
   #    choices = sort(colnames(dat)[4:ncol(dat)]),
   #    selected = "new_confirmed"
   #  ),
   #  
   # selectInput( inputId = "ctr",
   #    multiple = T,
   #    label = "Select countries to compare",
   #    choices = sort(unique(dat$country_name)),
   #    selected = c("Denmark","Norway","Germany")
   #  ),
   textInput("domain", label = h3("Domæne tjek hos Trustpilot")),
    dateRangeInput( inputId = "dR", label = "Select date range", start = "2020-01-01", end = "2020-12-31" )
  ),
  
  dashboardBody(
   # create tabs 
    tabsetPanel(
      type="tabs",
      id="ts",
      tabPanel(
        title="Country View",
        plotOutput("plot_data_country")
      ),
      tabPanel(
        title="Reviews",
        "Reviews",
        dataTableOutput("tbl")
      )
    )
  )
)

server <- function(input,output,session) {
  
  #dat <- dbReadTable(con,"reviews")
  clean_data_review <- reactive({
    res <- dbExistsTable(con, input$domain)
    if (res==T) {
    log_print("going for existing domain",console = F)
    log_print(input$domain,console = F)
      dat <- dbReadTable(con,input$domain)
    } else {
      
      doScrape(input$domain)
      dat <- dbReadTable(con,"homedk")
    }
  })
  
  output$tbl <- renderDataTable({
    clean_data_review()
  })
  # generate data here
  
  # clean_data_review <- reactive({
  # clean_dat <- dat %>% 
  #   select(!subregion1_name) %>% 
  #   #filter(country_name=="Canada" & date >= "2020-01-01" & date <= "2020-12-31") %>% 
  #   filter(country_name %in% input$ctr & date >= input$dR[1] & date <= input$dR[2]) %>% 
  #   group_by(country_name, date) %>% 
  #   summarise_all(sum) %>% 
  #   #select( country_name, date, "matric") %>% 
  #   select( country_name, date, input$mtr) %>% 
  #   set_names(c("country_name","date","metric")) %>% 
  #   arrange(date)
  # })
  # 
  # # done data 
  # 
  # output$plot_data_country <- renderPlot({
  # ggplot (data=clean_data_country(), aes(y=metric,x=date, color=country_name))+
  #   geom_line(size=1.5) +
  #   labs(color="Country Name")
  # })
  
}

shinyApp(ui,server)
