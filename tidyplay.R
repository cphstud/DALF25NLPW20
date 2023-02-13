library(dplyr)
library(tidyr)

df=ggplot2::mpg

# manipulate


# extract man,model, year
df.carinfo = select(df,manufacturer,model,year)

# filter on colnames
df.carinfom = select(df,starts_with("m"))
df.carinfor = select(df,contains("r"))
df.carxx = select (df, c(2,5,7))

# rename
df1 <- rename(df, mfc=manufacturer)
df1 <-  mutate(df, avgmpg=((cty+hwy)/2))
df1 <-  mutate(df, car=paste(manufacturer,model))

# filter
df %>% filter(manufacturer=="audi")
df %>% filter(manufacturer=="audi" & year == "1999")
df %>% slice((nrow(df)-9):nrow(df))
tail(df)
