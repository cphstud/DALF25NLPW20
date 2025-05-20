library(wordcloud2)
library(rvest)
library(tidytext)
library(Sentida)
library(stopwords)


# FORMÅL
# Hvilken præst er
# 1) mindst konservativ
# 2) mest positiv
# 3) bruger flest kristne termer

url="https://www.dansketaler.dk/praedikener/tale/kathrine-lilleoers-praediken-juledag-2018"
url="https://www.dansketaler.dk/praedikener/tale/kirsten-jorgensens-praediken-juledag"
url="https://www.dansketaler.dk/praedikener/tale/nikolaj-hartung-kjaerbys-praediken-juledag"
url="https://www.dansketaler.dk/praedikener/tale/alex-vestergaard-nielsens-praediken-2-juledag"
url="https://www.dansketaler.dk/praedikener/tale/henrik-hojlunds-praediken-juledag"
url="https://www.dansketaler.dk/praedikener/tale/peter-sanders-praediken-2-juledag"
url="https://www.dansketaler.dk/praedikener/tale/jesper-stanges-praediken-2-juledag"
url="https://www.dansketaler.dk/praedikener/tale/lisbet-kjaer-mullers-praediken-2-juledag"

# FOR HVER TALE....
# hent talen vha rvest
mtest=read_html(url)
tagfortale=""
tale=mtest %>% html_node(tagfortale) %>% html_text() 

# tokenize på ord og sætninger
tale_tk_w=
tale_tk_s=

# count og wordcloud
# fjerne danske stopord
dkstop=stopwords(language = "da")
tale_tk_w_sub=
# lav en optælling af ord
tale_tk_w_sub_ct=
  
  
# Forbered data til wordcloud2
colnames(tale_tk_w_sub_ct)=

# Lav wordcloud med en given frekvens som nedre grænse  
  wordcloud2()

# Fjer mindst ét ord fra stopordene som du gerne vil ha' med i wordclouden
# Tilføj stopord ud fra wordclouden

# pulje sætninger sammen så det giver mening at køre en Sentida-score på tekstn
tale_tk_s$sentiment=
  
# tæl hvor mange kristne begreber der indgår

# SAML resultaterne i én dataframe så præsterne kan sammenlignes
  
