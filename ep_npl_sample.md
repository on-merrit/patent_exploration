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
        AND NOT cite.npl_text = "No further relevant documents disclosed" 
        AND rand() < 0.01
    ORDER BY rand LIMIT 10000
```

### Backup

``` r
rand_npl
#> # A tibble: 9,485 x 5
#>    publication_numb~ country_code type  npl_text                                      rand
#>    <chr>             <chr>        <chr> <chr>                                        <dbl>
#>  1 EP-2940443-A1     EP           "A"   "YUN ZHAO ET AL: \"A simulation and exper~ 2.46e-5
#>  2 EP-2823812-A1     EP           ""    "SCHMIDT ET AL., DIABETOLOGIA, vol. 28, 1~ 1.06e-4
#>  3 EP-3064509-A2     EP           ""    "BOERNER ET AL., J. IMMUNOL., vol. 147, n~ 2.19e-4
#>  4 EP-3327027-A1     EP           ""    "KABAT E ET AL., J. IMMUNOLOGY, vol. 125,~ 2.78e-4
#>  5 EP-2885006-B1     EP           ""    "HO GUOJIE ET AL: \"Detection and quantif~ 4.31e-4
#>  6 EP-3207944-A1     EP           ""    "KIRPOTIN ET AL., FEBS LETTERS, vol. 388,~ 6.92e-4
#>  7 EP-3281947-A1     EP           ""    "VAUGHAN ET AL., NAT. BIOTECH., vol. 16, ~ 7.87e-4
#>  8 EP-3351992-A1     EP           "Y"   "H-J JORDAN ET AL: \"Highly accurate non-~ 8.35e-4
#>  9 EP-2866000-A1     EP           "X"   "GINO PUTRINO ET AL: \"Integrated Resonan~ 1.01e-3
#> 10 EP-2949337-A3     EP           "XY"  "ZVI ANAT ET AL: \"Whole genome identific~ 1.09e-3
#> # ... with 9,475 more rows
write_csv(rand_npl, "data/rand_npl.csv")
```
