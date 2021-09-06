
### Overview sources

#### Unpaywall

``` r
npl_df <- readr::read_csv("data/bq_doi_20210824.csv") %>%
   filter(publication_date < 20210101)
dois <- readr::read_csv("data/dois_to_be_checked.csv") %>%
  filter(publication_number %in% npl_df$publication_number)
dois_df <- npl_df %>%
  select(publication_number, family_id) %>%
  left_join(dois, by = "publication_number") %>%
  distinct()
```

Big query

``` r
length(unique(npl_df$family_id))
#> [1] 240010
length(unique(npl_df$npl_text))
#> [1] 594094
```

``` r
# distinct dois
dois %>% distinct(doi_cleaned)
#> # A tibble: 415,148 × 1
#>    doi_cleaned                   
#>    <chr>                         
#>  1 10.1021/cm062619r             
#>  2 10.1109/CCGRID.2012.143       
#>  3 10.1109/CISIS                 
#>  4 10.1371/journal.pone.0019991  
#>  5 10.1016/j.jalz.2011.03.005    
#>  6 10.1186/alzrt62               
#>  7 10.1016/j.ultramic.2003.11.001
#>  8 10.1109/TMC.2011.216          
#>  9 10.1145/1023783.1023786       
#> 10 10.1371/journal.pone.0116871  
#> # … with 415,138 more rows
# family with sql doi match
dois_df %>% 
  summarise(n_distinct(family_id))
#> # A tibble: 1 × 1
#>   `n_distinct(family_id)`
#>                     <int>
#> 1                  240010
# family with syntactially valid doi
dois_df %>%
  filter(!is.na(doi_cleaned)) %>%
    summarise(n_distinct(family_id))
#> # A tibble: 1 × 1
#>   `n_distinct(family_id)`
#>                     <int>
#> 1                  230108
# family with unpaywall match
oa <- jsonlite::stream_in(file("data/oa_patents.json"), verbose = FALSE) %>%
  filter(tolower(doi) %in%  tolower(dois$doi_cleaned))
dois_df %>%
  filter(!is.na(doi_cleaned)) %>%
  mutate(doi_cleaned = tolower(doi_cleaned)) %>%
  inner_join(oa, by = c("doi_cleaned" = "doi")) %>%
    summarise(n_distinct(family_id))
#> # A tibble: 1 × 1
#>   `n_distinct(family_id)`
#>                     <int>
#> 1                  137498
# distinct dois
length(unique(oa$doi))
#> [1] 204847
```

#### Europe PMC

``` r
epmc_df <- readr::read_csv("data/epmc_pmid_pmc.csv")
npl_pattern <- readr::read_csv("data/npl_pattern.csv")
```

big query recall

``` r
# patent families
npl_pattern %>% 
    filter(repo_pattern %in% c("pmid", "pmcid")) %>%
    distinct(family_id)
#> # A tibble: 4,112 × 1
#>    family_id
#>        <dbl>
#>  1  59057557
#>  2  38859094
#>  3  52668146
#>  4  39275445
#>  5  33479817
#>  6  59274055
#>  7  65806999
#>  8  46672972
#>  9  49945429
#> 10  60937809
#> # … with 4,102 more rows
# npl
npl_pattern %>% 
    filter(repo_pattern %in% c("pmid", "pmcid")) %>%
    distinct(npl_text) %>%
    nrow()
#> [1] 11134
```

pid extraction

``` r
pmid_raw <- npl_pattern %>% 
    filter(repo_pattern == "pmid") %>%
    mutate(pmid_raw = str_extract(npl_text, "(PMID: (\\d{7,8}))|(PMID:(\\d{7,8}))|(PMID (\\d{7,8}))")) %>%
    mutate(pmid_cleaned = str_extract(pmid_raw, "\\d{7,8}"))
# distinct pmids
distinct_pmid <- pmid_raw %>%
    filter(!is.na(pmid_raw)) %>%
    distinct(pmid_raw) %>%
    nrow()
# distinct families
distinct_pmid_family <- pmid_raw %>%
    filter(!is.na(pmid_raw)) %>%
    distinct(family_id)
### pmc
pmcid_raw <- npl_pattern %>%
    filter(repo_pattern == "pmcid") %>%
    mutate(pmcid_raw = str_extract(npl_text, "(PMCID: (\\d{5,7}))|(PMCID:(\\d{5,7}))|(PMCID (\\d{5,7}))|(PMC(\\d{5,7}))")) %>%
    mutate(pmcid_cleaned = str_extract(pmcid_raw, "\\d{5,7}"))
# distinct pmcids
distinct_pmcid <- pmcid_raw %>%
    filter(!is.na(pmcid_raw)) %>%
    distinct(pmcid_raw) %>%
    nrow()
# distinct families
distinct_pmcid_family <- pmcid_raw %>%
    filter(!is.na(pmcid_raw)) %>%
    distinct(family_id)
# all distinct pids
distinct_pmid + distinct_pmcid
#> [1] 7284
# all distinct families
bind_rows(distinct_pmid_family, distinct_pmcid_family) %>%
  distinct() %>%
  nrow()
#> [1] 3974
```

``` r
epmc_df <- readr::read_csv("data/epmc_pmid_pmc.csv")

epmc_08_20 <- epmc_df %>%
  select(id, publication_number, pubYear, isOpenAccess, pubType) %>%
  filter(pubYear > 2007, pubYear < 2021) %>%
  inner_join(npl_pattern, by = "publication_number")
# distinct pids
length(unique(epmc_08_20$id))
#> [1] 2801
# distinct families
length(unique(epmc_08_20$family_id))
#> [1] 1862
```

#### arxiv

``` r
# patent families
npl_pattern %>% 
    filter(repo_pattern %in% c("rxiv")) %>%
    distinct(family_id) %>%
    nrow
#> [1] 14938
# npl
npl_pattern %>% 
    filter(repo_pattern %in% c("rxiv")) %>%
    distinct(npl_text) %>%
    nrow()
#> [1] 25571
```

pid extraction

``` r
arxiv_df <- readr::read_csv("data/arxid_ids.csv")
arxiv_short <- arxiv_df %>%
  select(id, submitted) %>%
  filter(!is.na(id)) %>%
  separate(id, into = c("id_", "version"), sep = "v") 

arxix_npl <- npl_pattern %>% 
    filter(repo_pattern == "rxiv") %>%
    mutate(arxiv_id = str_extract(npl_text, "(\\d{4}\\.\\d{4,5})")) %>%
    select(publication_number, family_id, arxiv_id) %>%
    filter(!is.na(arxiv_id))
arxiv_patent <- inner_join(arxix_npl, arxiv_short, by = c("arxiv_id" = "id_")) %>%
  distinct()

# distinct families
length(unique(arxiv_patent$family_id))
#> [1] 9656
# distinct pids
length(unique(arxiv_patent$arxiv_id))
#> [1] 8469
arxiv_patent_08_20 <- arxiv_patent %>% 
  filter(submitted >= "2008-01-01", submitted < "2021-01-01")

# distinct families
length(unique(arxiv_patent_08_20$family_id))
#> [1] 9523
# distinct pids
length(unique(arxiv_patent_08_20$arxiv_id))
#> [1] 8317
```

### total 2008 - 2020

``` r
upw <- dois_df %>%
  filter(!is.na(doi_cleaned)) %>%
  mutate(doi_cleaned = tolower(doi_cleaned)) %>%
  inner_join(oa, by = c("doi_cleaned" = "doi")) 
upw_df <- upw %>%
  select(pid = doi_cleaned, family_id, publication_number, is_oa, year, pub_type = genre) %>%
  distinct() %>%
  mutate(src = "Unpaywall")
epmc_08_20_df <- epmc_08_20 %>%
  select(pid = id, family_id, publication_number, year = pubYear, isOpenAccess, pubType) %>%
  distinct() %>%
  mutate(is_oa = ifelse(isOpenAccess == "Y", TRUE, FALSE)) %>%
  mutate(pub_type = ifelse(grepl("article", pubType, ignore.case = TRUE, fixed = FALSE), "journal-article", "other")) %>%
  select(-isOpenAccess, -pubType) %>%
  mutate(src = "Europe PMC")
arxiv_patent_08_20_df <- arxiv_patent_08_20 %>%
  mutate(year = lubridate::year(submitted)) %>%
  select(pid = arxiv_id, family_id, publication_number, year) %>%
  mutate(is_oa = TRUE) %>%
  mutate(src = "arXiv", pub_type = "posted-content")
total_df <- bind_rows(upw_df, epmc_08_20_df, arxiv_patent_08_20_df)

write_csv(total_df, "data/npl_oa_2008_2020.csv")
length(unique(total_df$pid))
#> [1] 215965
length(unique(total_df$family_id))
#> [1] 146382
```

enrich with patent metadata

``` r
library(bigrquery)
library(DBI)
con <- DBI::dbConnect(
  bigrquery::bigquery(),
  project = "api-project-764811344545"
)

bg_patent_oa <- bq_table("api-project-764811344545", "tmp", "patent_oa")
if(bq_table_exists(bg_patent_oa))
  bq_table_delete(bg_patent_oa)
bigrquery::bq_table_upload(
  bg_patent_oa,
  total_df)
```

``` r
oa_enriched <- readr::read_file("sql/enrich_oa_with_patent_md.sql")
oa_enriched_df <- DBI::dbGetQuery(con, oa_enriched)

oa_enriched_df
#> # A tibble: 740,545 × 12
#>    publication_number family_id pub_year cpc   country_code src   pub_type is_oa
#>    <chr>              <chr>        <int> <chr> <chr>        <chr> <chr>    <lgl>
#>  1 US-10865240-B2     55274842      2020 A     "SG"         Unpa… journal… TRUE 
#>  2 US-10826079-B2     64272109      2020 H     "JP"         Unpa… journal… TRUE 
#>  3 EP-3541943-A4      64362888      2020 A     "KR"         Unpa… journal… TRUE 
#>  4 US-10578566-B2     68055990      2020 G     "US"         Unpa… journal… FALSE
#>  5 EP-3703004-A3      69742796      2020 G     "JP"         Unpa… journal… TRUE 
#>  6 EP-3751788-A1      70857052      2020 G     "DE"         Unpa… proceed… FALSE
#>  7 CN-111860683-A     72946768      2020 G     ""           arXiv posted-… TRUE 
#>  8 EP-3589736-A4      63370521      2020 A     "US"         Unpa… journal… TRUE 
#>  9 EP-3725773-A1      70108097      2020 C     "JP"         Unpa… journal… FALSE
#> 10 EP-3663979-A1      68835020      2020 G     "DE"         Unpa… journal… TRUE 
#> # … with 740,535 more rows, and 4 more variables: publication_number_1 <chr>,
#> #   family_id_1 <int>, year <int>, pid <chr>

write_csv(oa_enriched_df, "data/oa_patent_matched_md.csv")
```
