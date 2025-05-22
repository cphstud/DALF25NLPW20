library(rvest)
library(RSelenium)



rD <- rsDriver(port= 4592L,browser = c('firefox'))

url="https://www.dansketaler.dk/praedikener/soeg?q=2000"

rc=rD$client
rc$open()
rc$navigate(url)
rc$executeScript("window.scrollTo(0, document.body.scrollHeight);")

webElem <- rc$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))

pagesource <- rc$getPageSource()
html <- read_html(pagesource[[1]])


# the tag
stag=".speech-article-content"

links=html %>% html_elements("a") %>% html_attr("href")
links2=lapply(links, function(x) paste0("https://www.dansketaler.dk",x))
links3 <- links2[str_detect(links, "tale/")]


results <- map_dfr(links3, extract_text_from_tag, tag = stag)


extract_text_from_tag <- function(url, tag = ".speech-article-content") {
  Sys.sleep(as.integer(runif(1,2,5)))
  tryCatch({
    page <- read_html(url)
    text <- page %>%
      html_elements(tag) %>%
      html_text(trim = TRUE)
    data.frame(url = url, tag_text = paste(text, collapse = " | "))
  }, error = function(e) {
    data.frame(url = url, tag_text = NA)
  })
}


