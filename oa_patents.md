
### Call Big Query

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.1     ✓ dplyr   1.0.5
    ## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
    ## ✓ readr   1.4.0     ✓ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(DBI)
library(bigrquery)

con <- DBI::dbConnect(
  bigrquery::bigquery(),
  project = "api-project-764811344545"
)
```

### Unapywall match

Hosted on UGOE Big Query. See here for more details:
<https://doi.org/10.18452/22728>

Create table on Google Big Query

``` sql
CREATE TABLE tmp.patent_unpaywall_matched AS
SELECT *
FROM `api-project-764811344545.oadoi_full.upw_Feb21_08_21`  AS `TBL_LEFT`
WHERE EXISTS (
  SELECT 1 FROM `api-project-764811344545.tmp.patent_dois` AS `TBL_RIGHT`
  WHERE (LOWER(`TBL_LEFT`.`doi`) = LOWER(`TBL_RIGHT`.`doi`))
)
```

Fetch data

``` sql
SELECT * 
FROM `api-project-764811344545.tmp.patent_unpaywall_matched`
```

``` r
oa_patents
```

    ## # A tibble: 62,298 x 16
    ##    doi   genre has_repository_… is_paratext is_oa journal_is_in_d… journal_is_oa
    ##    <chr> <chr> <lgl>            <lgl>       <lgl> <lgl>            <lgl>        
    ##  1 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  2 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  3 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  4 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  5 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  6 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  7 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  8 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ##  9 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ## 10 10.1… proc… FALSE            FALSE       FALSE FALSE            FALSE        
    ## # … with 62,288 more rows, and 9 more variables: journal_issn_l <chr>,
    ## #   journal_issns <chr>, journal_name <chr>, oa_locations <list>,
    ## #   oa_status <chr>, publisher <chr>, published_date <chr>, doi_updated <dttm>,
    ## #   year <int>

Local backup

``` r
library(jsonlite)
```

    ## 
    ## Attaching package: 'jsonlite'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     flatten

``` r
jsonlite::stream_out(oa_patents, file("data/oa_patents.json"), verbose = FALSE)
```
