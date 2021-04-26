DOI extraction and matching
================

``` r
library(tidyverse)
library(biblids) # https://github.com/subugoe/biblids
library(stringi)
```

``` r
npl_df <- readr::read_csv("data/npl_pattern.csv")
```

extract dois

``` r
npl_tt <- npl_df %>% 
  filter(repo_pattern == "doi") %>%
  mutate(doi = as_data_frame(biblids::str_extract_all_doi(npl_text)))

npl_dois <- npl_tt %>%
  pull(doi)
  

npl_tidy <- bind_cols(npl_tt, npl_dois) %>%
  select(-doi) %>%
  pivot_longer(cols = starts_with("V"), values_to = "doi_string") %>%
  filter(!is.na(doi_string)) %>%
  mutate(doi_cleaned = str_remove(doi_string, "\\.$")) %>%
  mutate(doi_cleaned = str_remove(doi_cleaned, "\\>$")) %>%
  mutate(doi_cleaned = str_remove(doi_cleaned, "\\,$")) %>%
  mutate(doi_cleaned = tolower(doi_cleaned))

npl_tidy %>%
  distinct(doi = doi_cleaned) %>%
  write_csv("data/dois_to_be_checked.csv")
```
