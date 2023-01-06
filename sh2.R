library(tidyverse)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(shinycssloaders)
library(shinydashboard)

dat <- readRDS("data/subregion_agg.rds")


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
    
    selectInput(
      inputId = "mtr",
      label = "Select Metric",
      choices = sort(colnames(dat)[4:ncol(dat)]),
      selected = "new_confirmed"
    ),
    
   selectInput( inputId = "ctr",
      multiple = T,
      label = "Select countries to compare",
      choices = sort(unique(dat$country_name)),
      selected = c("Denmark","Norway","Germany")
    ),
    
    dateRangeInput(
      inputId = "dR",
      label = "Select date range",
      start = "2020-01-01",
      end = "2020-12-31"
    )
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
        title="T2",
        "Tab 2"
      )
    )
  )
)

server <- function(input,output,session) {
  
  # generate data here
  
  clean_data_country <- reactive({
  clean_dat <- dat %>% 
    select(!subregion1_name) %>% 
    #filter(country_name=="Canada" & date >= "2020-01-01" & date <= "2020-12-31") %>% 
    filter(country_name %in% input$ctr & date >= input$dR[1] & date <= input$dR[2]) %>% 
    group_by(country_name, date) %>% 
    summarise_all(sum) %>% 
    #select( country_name, date, "matric") %>% 
    select( country_name, date, input$mtr) %>% 
    set_names(c("country_name","date","metric")) %>% 
    arrange(date)
  })
  
  # done data 
  
  output$plot_data_country <- renderPlot({
  ggplot (data=clean_data_country(), aes(y=metric,x=date, color=country_name))+
    geom_line(size=1.5) +
    labs(color="Country Name")
  })
}

shinyApp(ui,server)
