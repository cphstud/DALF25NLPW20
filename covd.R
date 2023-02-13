library(tidyverse)
library(shiny)
library("shinyWidgets")
library("DT")
library("shinycssloaders")
library("shinydashboard")


  
covdata=read.csv("covid_data.csv")
str(covdata)
summary(covdata)
colnames(covdata)

# subset
covdatas1=covdata[,c(1,4,6,12:25)]

# remove na

covdata[i,j,k]
