DOI extraction and matching
================

``` r
library(tidyverse)
library(stringi)
library(biblids) # https://github.com/subugoe/biblids
```

``` r
npl_df <- readr::read_csv("data/bq_doi_20210824.csv")
```

extract dois

``` r
npl_tt <- npl_df %>% 
  mutate(doi = biblids::str_extract_all_doi(npl_text)) %>%
  select(doi, publication_number)

npl_tidy <- tibble(
  as.data.frame(npl_tt$doi),
  publication_number = npl_tt$publication_number) %>%
  pivot_longer(!publication_number) %>%
  filter(!is.na(value)) %>%
  select(-name) %>%
  mutate(doi_cleaned = str_remove(value, "\\.$")) %>%
  mutate(doi_cleaned = str_remove(doi_cleaned, "\\>$")) %>%
  mutate(doi_cleaned = str_remove(doi_cleaned, "\\,$")) %>%
  mutate(doi_cleaned = str_remove(doi_cleaned, "\\;$")) %>%
  select(-value)

npl_tidy
#> # A tibble: 801,500 × 2
#>    publication_number doi_cleaned                   
#>    <chr>              <chr>                         
#>  1 US-9435915-B1      10.1021/cm062619r             
#>  2 US-9467500-B2      10.1109/CCGRID.2012.143       
#>  3 US-9467500-B2      10.1109/CISIS                 
#>  4 US-9493516-B2      10.1371/journal.pone.0019991  
#>  5 US-9493516-B2      10.1016/j.jalz.2011.03.005    
#>  6 US-9493516-B2      10.1186/alzrt62               
#>  7 US-9497379-B2      10.1016/j.ultramic.2003.11.001
#>  8 US-9560489-B2      10.1109/TMC.2011.216          
#>  9 US-9560489-B2      10.1145/1023783.1023786       
#> 10 US-9622484-B2      10.1371/journal.pone.0116871  
#> # … with 801,490 more rows

npl_tidy %>%
  write_csv("data/dois_to_be_checked.csv")
```

Upload to Google Big Query

``` r
library(bigrquery)

patent_dois <- 
  bq_table("api-project-764811344545", "tmp", "patent_dois")
if(bq_table_exists(patent_dois)) 
  bq_table_delete(patent_dois)
bigrquery::bq_table_upload(
  patent_dois,
  npl_tidy)
```
