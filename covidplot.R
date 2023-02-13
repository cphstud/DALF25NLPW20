library(dplyr)
library(ggplot2)

dat <- readRDS("data/subregion_agg.rds")

# dat %>% 
#   filter() %>% 
#   select() %>% 
#   filter() %>% 
#   arrange()

clean_dat <- dat %>% 
  select(!subregion1_name) %>% 
  filter(country_name=="Canada" & date >= "2020-01-01" & date <= "2020-12-31") %>% 
  group_by(country_name, date) %>% 
  summarise_all(sum) %>% 
  select( country_name, date, "new_confirmed")
  filter(date == "2020-07-05") %>% 
  arrange(date)

ggplot (data=clean_dat, aes(y=new_confirmed,x=date, color=country_name))+
  geom_line(size=1.5) +
  labs(color="Country N")
  
#ggplot (data=clean_dat, aes(y=new_confirmed,x=date, color=country_name))+
#  geom_line(size=1.5)
#ggplot (data=clean_dat, aes(y=new_confirmed,x=date))+
#  geom_line(size=1.5)
