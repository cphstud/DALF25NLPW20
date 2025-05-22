library(tidyverse)
library(tidytext)
library(wordcloud2)
library(gutenbergr)

#sherlock_raw <- gutenberg_download(1661)
sherlock_raw2 <- readLines("/Users/thor/Downloads/sherlock.txt")
sherlock_raw <- as.data.frame(sherlock_raw2)
colnames(sherlock_raw)="text"

metagut %>% filter(str_detect(title,"Sherlock"))

sherlock <- sherlock_raw %>%
  mutate(story = ifelse(str_detect(text, "^[IXVL\\. ]+ [A-Z ]+$"), text, NA)) %>% 
  fill(story)

# indexing lines
sherlock$line=1:nrow(sherlock)
  
# tokenize
tidy_sherlock <- sherlock %>%  unnest_tokens(word, text) 
tidy_sherlock$word=gsub("_","",tidy_sherlock$word)

#count
wc=tidy_sherlock %>% group_by(story) %>% count(word)
wc=tidy_sherlock %>% count(word)
#viz
wc %>% filter(n>50) %>% wordcloud2()


tidy_sherlock <- tidy_sherlock %>% 
  anti_join(stop_words)  %>% 
  filter(word != "sherlock")

tidy_sherlock <- tidy_sherlock %>% 
  filter(word != "holmes")

library(drlib)
tmptf=sherlock_tf_idf <- tidy_sherlock %>%
  count(story, word, sort = TRUE) 

tmpdfIDF <- tmptf %>% 
  bind_tf_idf(word, story, n) %>%
  group_by(story) %>%
  top_n(10) %>%
  ungroup() %>% 
  mutate(word=reorder(word,tf_idf))

ggplot(tmpdfIDF,aes(word,tf_idf,fill=story))+
  geom_col(show.legend = F)+
  facet_wrap(~story, scales = "free")+
  coord_flip()


#TOPIC MODELLING
library(quanteda)
library(stm)

tidy_sherlock$word2=gsub("[^a-zA-Z\\. ]+","",tidy_sherlock$word)

#convert away from tidy
sherlock_dfm <- tidy_sherlock %>%
  count(story, word, sort = TRUE) %>%
  cast_dfm(story, word, n)

sherlock_dtm <- tidy_sherlock %>%
  count(story, word, sort = TRUE) %>%
  cast_dtm(story, word, n)

inspect(sherlock_dtm)

sherlock_sparse <- tidy_sherlock %>%
  count(story, word, sort = TRUE) %>%
  cast_sparse(story, word, n)

topic_model <- stm(sherlock_dfm, K = 6, 
                   verbose = FALSE, init.type = "Spectral")

summary(topic_model)
plot.STM(topic_model)
labelTopics(topic_model)
cloud(topic_model,topic = 1)
topic_model$convergence

#convert back to tidy
td_beta <- tidy(topic_model, matrix = "beta")
td_gamma <- tidy(topic_model, matrix = "gamma", document_names = rownames(sherlock_dfm))
td_beta
td_gamma

ap_top_terms <- td_beta %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# plot beta
ggplot(ap_top_terms, aes(reorder(term,beta), beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()


td_gamma <- td_gamma %>% filter(str_detect(term,"^[a-zA-Z]+$"))
td_gamma <- td_gamma %>% arrange(desc(beta))
td_gamma

td_gamma <- tidy(topic_model, matrix = "gamma",                    
                 document_names = rownames(sherlock_dfm))

# plot gamma
ggplot(td_gamma, aes(x = gamma, fill = topic)) +
  geom_histogram(show.legend = F)+
  facet_wrap(~topic, scales = "free")
  



