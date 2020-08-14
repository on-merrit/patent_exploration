library(tidyverse)
library(stringr)

df <- read_csv("data/rand_npl.csv")

df %>%
  select(-rand, -country_code, -type) -> df_clean


df_clean %>%
  head(50) %>%
  mutate(authors = str_extract(npl_text, ".*(?=:)"),
         test = str_extract(npl_text, ".*:"))



