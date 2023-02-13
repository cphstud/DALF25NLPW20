library(Sentida)
library("rvest")
library("logr")
library("RSelenium")
library("ggplot2")
library("dplyr")
library("magrittr")
library("tidyverse")
library("purrr")
library(DBI)
library(RMariaDB)

con <- dbConnect(MariaDB(),
                 host="localhost",
                 user="root",
                 password="root123",
                 db="reviews"
)

homer = dbReadTable(con,"homedk")
eurd = dbReadTable(con,"reviews")

hist(homer$rating)
hist(eurd$rating)

homer %>% mutate(sentscore=sentida(content))
homer$nrate = lapply(homer$content,function(x) sentida(x))
# selenium running in Docker
#remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",port=4445)
#remDr$open()

# logr
log_open("logtp.txt")

#Laver funktioner der der fungerer som 'cleaning' funktioner
##Trimmer en string for at fjerne "white space"
trim <- function(str) {
  gsub("^\\s+|\\s+$", "", str)
}


##Laver alle factor kolonnerne til character
factorToCharacter <- function(df) {
  for (i in 1:ncol(df)) {
    if (is.factor(df[, i])) {
      df[, i] <- as.character(df[, i])
    }
  }
  return(df)
}


doEstimate <- function(domain) {
  ##Laver TrustPilot funktionen
  # https://dk.trustpilot.com/review/www.eurodan-huse.dk?page=2
  url <- paste0("https://dk.trustpilot.com/review/", domain)
  
  #Vi definerer url'en som skal analyseres.
  #For at se hvor mange sider af reviews der skal gennemgås, må vi først finde antallet at reviews
  
  
  
  totalReviews <- read_html(url) %>%
    html_node(".styles_header__yrrqf .typography_body-l__KUYFJ") %>%
    html_text()
  xtotalReviews <- as.numeric(gsub("[^0-9]", "", totalReviews))
  
  #Vi laver en tom variabel som senere vil være brugt til opfyldning af 'actual' review data
  
  #Her bliver printet ud hvor mange sider der er
  cat("\014")
  #cat(paste0("The script will run on ", ceiling(totalReviews / 20), " pages!\n"))
  limit= ceiling(xtotalReviews / 20)
  return(limit)
}
  
doScrape <- function(domain) {
  # dataframen til mine reviews
  reviews = data.frame()
  limit = doEstimate(domain)
  
  #remDr$open()
  
  #Der laves et loop som går gennem alle siderne
  for (i in (1:limit)) {
    
    #påbegynder scraping
    tmpurl=paste0(url,"?page=",i)
    log_print(tmpurl)
    #
    #remDr$navigate(tmpurl)
    #tmpsource <- remDr$getPageSource()
    page <- read_html(tmpurl) 
    Sys.sleep(4)
    
    review_card <- page %>%
      html_nodes(".styles_reviewCard__hcAvl")
    
    name <- review_card %>%
      html_nodes(".styles_consumerDetails__ZFieb .typography_appearance-default__AAY17") %>%
      html_text()
    
    
    #Indsamler hvor mange reviews den enkelte bruger har lavet på Trustpilot (er brugeren trustworthy?)
    reviewCount <- review_card %>%
      html_nodes(
        ".styles_consumerExtraDetails__fxS4S span.typography_appearance-subtle__8_H2l"
      ) %>%
      html_text() %>%
      trim()
    
    reviewCount <-
      as.numeric(gsub("[^0-9]", "", reviewCount))
    
    #Værdier for stjernerne - læses ind som tal (digits)
    rating <- review_card %>%
      html_nodes(".styles_reviewHeader__iU9Px img") %>%
      html_attr("alt")
    
    rating <- as.integer(gsub("[^0-9]", "", rating))
    
    #datoerne for når reviewet er skrevet
    published <-
      review_card %>% html_nodes(".styles_datesWrapper__RCEKH time") %>% html_attr("datetime")  %>%
      substr(1, 10) %>%
      as.Date()
    
    #Respond datoer, hvis der ikke er lavet et respond så kommer den som NA
    respondDate <- review_card %>%
      html_nodes(".styles_replyDate__Iem0_") %>%
      html_attr("datetime") %>%
      substr(1, 10) %>%
      as.Date()
    
    #Titlen på reviewet
    title <- review_card %>%
      html_nodes(".link_notUnderlined__szqki .typography_appearance-default__AAY17") %>%
      html_text() %>%
      trim()
    
    #Her kan vi så se 'the actual review'
    content <- review_card %>%
      html_nodes(".typography_body-l__KUYFJ.typography_color-black__5LYEn") %>%
      html_text() %>%
      trim()
    
    #Her kan vi så se om der er nogle 'replies'
    haveReply <- html_children(review_card) %>%
      html_text()
    haveReply <-
      unlist(gregexpr("Besvarelse fra", haveReply, perl = TRUE)) > 0
    
    
    #Liste af alle 'replies'
    reply <- review_card %>%
      html_nodes(".styles_message__shHhX") %>%
      html_text() %>%
      trim()
    
    #Det her loop bruges til at finde udaf om et review har fået et reply - hvis NA udskrives, har det ikke fået et reply
    replies <- NULL
    k <- 1
    for (j in 1:(length(name))) {
      if (haveReply[j]) {
        replies <- c(replies, reply[k])
        k <- k + 1
      } else {
        replies <- c(replies, NA)
      }
    }
    
    #Her bygger vi dataframen der skal spytte al vores data ud
    
    tryCatch( {
      reviews = rbind( reviews, data.frame(
        name = name,
        reviewCount = reviewCount,
        rating = rating,
        published = published,
        #respondDate = respondDate,
        title = title,
        content = content,
        reply = replies,
        stringsAsFactors = FALSE
      )
      )},
      error = function(e) {print(e)})
    #Da man afslutter en funktion, laves alle faktor kolonner om til characters - også tilføjes der et kolonne med antal af characters i reviewet
    #print(paste0(url, "&page=", i, " has been scraped"))
  }
  
  xreviews <- factorToCharacter(reviews)
  tabname=gsub("\\.","",domain)
  dbWriteTable(con,tabname,xreviews)
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  