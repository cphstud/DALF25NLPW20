library(tidyverse)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(shinycssloaders)
library(shinydashboard)

dat <- readRDS("data/subregion_agg.rds")
clean_dat <- dat %>% 
  select(!subregion1_name) %>% 
  filter(country_name=="Canada" & date >= "2020-01-01" & date <= "2020-12-31") %>% 
  group_by(country_name, date) %>% 
  summarise_all(sum) %>% 
  select( country_name, date, "new_confirmed") %>% 
  arrange(date)


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
  
  ggplot (data=clean_dat, aes(y=new_confirmed,x=date, color=country_name))+
    geom_line(size=1.5) +
    labs(color="Country Name")
  
}

shinyApp(ui,server)
