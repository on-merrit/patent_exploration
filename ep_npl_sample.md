BQ Patent Exploration
================

### Connect to BQ

``` r
library(tidyverse)
library(DBI)
library(bigrquery)
con <- dbConnect(
  bigrquery::bigquery(),
  project = "cogent-tangent-279810"
)
```

### Query

Get a sample of 10,000 non-paten literature citation from patents
provided by the European Patent Office since 2015.

``` sql
SELECT
        meta.publication_number,
        meta.country_code,
        cite.type,
        cite.npl_text,
        rand() as rand
    FROM
        `patents-public-data.patents.publications_201912` AS meta,
        UNNEST(citation) AS cite 
    WHERE
        meta.country_code in (
            "EP"
        )  
        AND meta.publication_date > 20150101  
        AND cite.npl_text != '' 
        AND NOT REGEXP_CONTAINS(cite.npl_text, "^See|None") 
        AND NOT cite.npl_text = "No further relevant documents disclosed" LIMIT 10000
```

### Backup

``` r
rand_npl
#> # A tibble: 10,000 x 5
#>    publication_numb… country_code type  npl_text                         rand
#>    <chr>             <chr>        <chr> <chr>                           <dbl>
#>  1 EP-1482288-B1     EP           ""    "HILARY E SNELL ET AL: \"Fouri… 0.964
#>  2 EP-3134253-A4     EP           "XPI" "ROBERT MACCURDY ET AL: \"Hybr… 0.102
#>  3 EP-1811026-B1     EP           ""    "Technical Bulletin; pCI and p… 0.977
#>  4 EP-1901235-B1     EP           ""    "VERGEEST J ET AL: \"Free-form… 0.203
#>  5 EP-2097241-B1     EP           ""    "BAETEN F ET AL: \"Barium tita… 0.497
#>  6 EP-2280048-B1     EP           ""    "ULRICH JAHN: \"Decandisäure\"… 0.267
#>  7 EP-2304028-B1     EP           ""    "BREVNOV MAXIM G ET AL: \"Deve… 0.223
#>  8 EP-2310520-B1     EP           ""    "BING FENG ET AL: \"Purificati… 0.237
#>  9 EP-2334021-B1     EP           ""    "CARLOS MOSQUERA ET AL: \"Non-… 0.658
#> 10 EP-2737071-B1     EP           ""    "GALIBERT L ET AL: \"Baculovir… 0.961
#> # … with 9,990 more rows
write_csv(rand_npl, "data/rand_npl.csv")
```
