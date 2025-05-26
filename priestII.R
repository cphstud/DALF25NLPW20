library(rvest)
library(wordcloud2)
library(Sentida)
library(RSelenium)



rD <- rsDriver(port= 4594L,browser = c('firefox'))

url="https://www.dansketaler.dk/praedikener/soeg?q=2000"
url="https://www.dansketaler.dk/praedikener/taler/munch-stine"
url="https://www.dansketaler.dk/praedikener/soeg?tag=Anden+tekstrække"

rc=rD$client
rc$open()
rc$navigate(url)
rc$executeScript("window.scrollTo(0, document.body.scrollHeight);")

webElem <- rc$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))

pagesource <- rc$getPageSource()
stinehtml <- read_html(pagesource[[1]])


# the tag
stag=".speech-article-content"

slinks=stinehtml %>% html_elements("a") %>% html_attr("href")
slinks
slinks2=list()
slinks2=lapply(slinks, function(x) paste0("https://www.dansketaler.dk",x))
slinks2
slinks3 <- slinks2[str_detect(slinks, "tale/")]
slinks3


results <- map_dfr(slinks3, extract_text_from_tag, tag = stag)

saveRDS(results,"stinepraedikener2000.rds")
saveRDS(results,"tekstraekke_1_praedikener.rds")

#FE year
resultsdf <- results %>% mutate(year=str_extract(url,"[0-9]{4}"))

#FE taler
resultsdf$url[3]
resultsdf <- resultsdf %>% rowwise() %>% mutate(taler=str_match(url,"\\/([a-z]+-[a-z]+)-")[,2])
resultsdfSub <- resultsdf %>% filter(!is.na(taler))
resultsdfSub$score = unlist(lapply(resultsdfSub$tag_text,function(x) as.numeric(sentida(x,output = "mean"))))

sum(str_detect(resultsdfSub$url,"anders"))

#FE Sentida
resultsdfSub=resultsdfSub %>% mutate(talerF=gsub("s$","",taler))
resultsdfSub=resultsdfSub %>% mutate(talerF=gsub("soerine","sorine",talerF))
hist(resultsdfSub$score)
præster=as.data.frame(table(resultsdfSub$talerF))

# FE idx
resultsdfSub$doc_id=1:nrow(resultsdfSub)
# 
prfreq=as.data.frame(table(resultsdfSub$talerF))
subprDf = præster %>% filter(Freq > 6)
subpr=unlist(subprDf$Var1)

resultsdfSubSub=resultsdfSub %>% filter(talerF %in% subpr)

# TEXTANALYSE Iterativt mhp fjerne uvigtige ord vha wordcloud
# tokenize
tidy_priest <- resultsdfSubSub %>%  unnest_tokens(word, tag_text) 

# count
priest_cnt=tidy_priest %>% group_by(talerF) %>% count(word) %>% ungroup()
priest_cnt=tidy_priest %>% group_by(talerF,word) %>% mutate(cnt=n()) %>% ungroup()
#priest_cntdf=tidy_priest %>% group_by(talerF,word) %>% summarise(cnt3=n())

#First wc
#priest_cnt %>% group_by(talerF) %>% filter(top_n(15)) %>% 
vizdf=priest_cnt %>% filter(str_detect(talerF,"sorine")) %>% select(word,n)
vizdf %>% top_n(35) %>% 
  wordcloud2()
mystop=stopwords(language = "da")
mystop
#mystop=gsub("jeg|du")

write(mystop,"dkstop.txt")
mynewstop=readLines("dkstop.txt")

priest_cnt %>% filter(!word %in% mynewstop) %>% filter(str_detect(talerF,"sorin")) %>% select(word,n) %>% 
  top_n(20) %>% wordcloud2()
priest_cnt %>% filter(!word %in% mynewstop) %>% filter(str_detect(talerF,"anders")) %>% select(word,n) %>% 
  top_n(20) %>% wordcloud2()

#TOPIC MODELLING
library(quanteda)
library(stm)

# clean tidy_priest
mynewstop=readLines("dkstop.txt")
tidy_priestCl = tidy_priest %>% filter(!word %in% mynewstop)


#convert away from tidy
priest_dtm <-  tidy_priestCl %>% select(talerF,word) %>% 
  count(talerF, word, sort = TRUE) %>%
  cast_dtm(talerF, word, n)



priest_dfm <-  tidy_priestCl %>% select(talerF,word) %>% 
  count(talerF, word, sort = TRUE) %>%
  cast_dfm(talerF, word, n)


priest_dfm

topic_model <- stm(priest_dfm, K = 4, 
                   verbose = FALSE, init.type = "Spectral")

summary(topic_model)
plot.STM(topic_model,n = 10)
labelTopics(topic_model, topics = NULL, n = 7, frexweight = 0.5)
beta_matrix <- exp(topic_model$beta$logbeta[[1]])
labelTopics(topic_model,n = 10)
summary(topic_model)
cloud(topic_model,topic = 1)
cloud(topic_model,topic = 2)
cloud(topic_model,topic = 3)
cloud(topic_model,topic = 4)

# back to tidy
td_beta <- tidy(topic_model, matrix = "beta")
ap_top_terms <- td_beta %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)



# plot beta
ggplot(ap_top_terms, aes(reorder(term,beta), beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()


td_gamma <- tidy(topic_model, matrix = "gamma",                    
                 document_names = rownames(priest_dfm))


# plot gamma
ggplot(td_gamma, aes(x = gamma, fill = topic)) +
  geom_histogram(show.legend = F)+
  facet_wrap(~topic, scales = "free")

# plot præsternes tilhørsforhold
dominant <- td_gamma %>%
  group_by(document) %>%
  filter(gamma == max(gamma)) %>%
  ungroup()

ggplot(dominant, aes(x = factor(topic), y = document, color = factor(topic))) +
  geom_jitter(width = 0.1, height = 0.1, size = 3) +
  labs(title = "Documents Grouped by Dominant Topic",
       x = "Topic Cluster",
       y = "Document",
       color = "Topic") +
  theme_minimal()


write_csv(priest_cnt,"pp.txt")
myPosList=c("ånd","helligånd","hellig","frelse","synd")
tidy_priestCl = tidy_priest %>% filter(!word %in% mynewstop)


##### FUNCTIONS ##########

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


