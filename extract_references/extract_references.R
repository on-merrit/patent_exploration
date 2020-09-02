library(tidyverse)
library(stringr)

df <- read_csv("data/rand_npl.csv")

df %>%
  select(-rand, -country_code, -type) -> df_clean


df_clean %>%
  head(50) %>%
  mutate(authors = str_extract(npl_text, ".*(?=:)"),
         test = str_extract(npl_text, ".*:"))

# this is a quick helper to get the data into a format so it can be pasted
# to regex101 for regex development
df %>%
  select(npl_text) %>%
  slice_sample(n = 30) %>%
  write.table(file = "data/sample_text.txt", sep = ",",
              row.names = FALSE, quote = FALSE)
