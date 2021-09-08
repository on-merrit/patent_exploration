BQ Patent Open Data Detection
================

### Aim

The aim of this script is to retrieve all patents in Google Big Query
where open data is cited. For this purpose, we use keywords from the
[Open Data Detection in Publications
(ODDPub)](https://github.com/quest-bih/oddpub), an R package available
on GitHub

In particular, the oddpub following categories will be analyses:

-   REPOSITORIES: Set of names of general-purpose repositories  
-   GITHUB: Source code repository

We extend the list with patterns for pids

### Keywords per category

#### Generic repositories

``` r
library(oddpub)
generic_repo <- oddpub:::.create_keyword_list()[["repositories"]] %>%
  stringr::str_remove_all("\\\\b|\\\\b") %>% 
  strsplit("|", fixed = TRUE) %>% 
  unlist()
generic_repo
#>  [1] "figshare"               "dryad"                  "zenodo"                
#>  [4] "dataverse"              "dataversenl"            "osf"                   
#>  [7] "open science framework" "mendeley data"          "gigadb"                
#> [10] "gigascience database"   "openneuro"
```

#### Github

``` r
github_repo <- oddpub:::.create_keyword_list()[["github"]] %>%
  stringr::str_remove_all("\\\\b|\\\\b") %>% 
  strsplit("|", fixed = TRUE) %>% 
  unlist()
github_repo
#> [1] "github"
```

#### PIDs

``` r
pids <- c("pmid",
  "pmcid", 
  #"doi", too large
  "rxiv")
```

### Call Big Query

Helper function

``` r
library(DBI)
library(bigrquery)
library(glue)
con <- DBI::dbConnect(
  bigrquery::bigquery(),
  project = "api-project-764811344545"
)
# Search pattern in Big Query Patents NPL 
get_patents_with_repo <- function(repo_pattern) {
  
  my_pattern <- tolower(paste0('%', repo_pattern, '%'))
  
  req <- glue::glue_sql("
   SELECT
        e.publication_date,
        e.country_code,
        e.publication_number,
        e.family_id,
        d.npl_text,
        d.category
    FROM
        `patents-public-data.patents.publications` as e,
        UNNEST(citation) as d
    WHERE
        e.publication_date BETWEEN 20100101 AND 20203121
        AND e.application_kind = 'A'
        AND lower(d.npl_text) like {tolower(paste0('%', my_pattern, '%'))}
  ", .con = con)
  out <- DBI::dbGetQuery(con, req)
  if(!is.null(out))
    dplyr::mutate(out, repo_pattern = repo_pattern)
}
```

Call

``` r
my_patterns <- c(
  #generic_repo, 
  github_repo, 
  pids)
npl_df <- purrr::map_df(my_patterns, get_patents_with_repo)
```

Basic stats

``` r
npl_df %>%
  group_by(repo_pattern) %>%
  summarise(n = n_distinct(publication_number))
#> # A tibble: 4 × 2
#>   repo_pattern     n
#>   <chr>        <int>
#> 1 github        3598
#> 2 pmcid          390
#> 3 pmid          4562
#> 4 rxiv         19213
```

Export

``` r
readr::write_csv(npl_df, "../data/npl_pattern.csv")
```
