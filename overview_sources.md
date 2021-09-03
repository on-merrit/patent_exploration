
### Overview sources

#### Unpaywall

``` r
npl_df <- readr::read_csv("data/bq_doi_20210824.csv")
dois <- readr::read_csv("data/dois_to_be_checked.csv")
dois_df <- npl_df %>%
  select(publication_number, family_id) %>%
  left_join(dois, by = "publication_number") %>%
  distinct()
```

Big query

``` r
length(unique(npl_df$family_id))
#> [1] 250109
length(unique(npl_df$npl_text))
#> [1] 622716
```

``` r
# distinct dois
dois %>% distinct(doi_cleaned)
#> # A tibble: 434,604 × 1
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
#> # … with 434,594 more rows
# family with sql doi match
dois_df %>% 
  summarise(n_distinct(family_id))
#> # A tibble: 1 × 1
#>   `n_distinct(family_id)`
#>                     <int>
#> 1                  250109
# family with syntactially valid doi
dois_df %>%
  filter(!is.na(doi_cleaned)) %>%
    summarise(n_distinct(family_id))
#> # A tibble: 1 × 1
#>   `n_distinct(family_id)`
#>                     <int>
#> 1                  239960
# family with unpaywall match
oa <- jsonlite::stream_in(file("data/oa_patents.json"))
#>  Found 500 records... Found 1000 records... Found 1500 records... Found 2000 records... Found 2500 records... Found 3000 records... Found 3500 records... Found 4000 records... Found 4500 records... Found 5000 records... Found 5500 records... Found 6000 records... Found 6500 records... Found 7000 records... Found 7500 records... Found 8000 records... Found 8500 records... Found 9000 records... Found 9500 records... Found 10000 records... Found 10500 records... Found 11000 records... Found 11500 records... Found 12000 records... Found 12500 records... Found 13000 records... Found 13500 records... Found 14000 records... Found 14500 records... Found 15000 records... Found 15500 records... Found 16000 records... Found 16500 records... Found 17000 records... Found 17500 records... Found 18000 records... Found 18500 records... Found 19000 records... Found 19500 records... Found 20000 records... Found 20500 records... Found 21000 records... Found 21500 records... Found 22000 records... Found 22500 records... Found 23000 records... Found 23500 records... Found 24000 records... Found 24500 records... Found 25000 records... Found 25500 records... Found 26000 records... Found 26500 records... Found 27000 records... Found 27500 records... Found 28000 records... Found 28500 records... Found 29000 records... Found 29500 records... Found 30000 records... Found 30500 records... Found 31000 records... Found 31500 records... Found 32000 records... Found 32500 records... Found 33000 records... Found 33500 records... Found 34000 records... Found 34500 records... Found 35000 records... Found 35500 records... Found 36000 records... Found 36500 records... Found 37000 records... Found 37500 records... Found 38000 records... Found 38500 records... Found 39000 records... Found 39500 records... Found 40000 records... Found 40500 records... Found 41000 records... Found 41500 records... Found 42000 records... Found 42500 records... Found 43000 records... Found 43500 records... Found 44000 records... Found 44500 records... Found 45000 records... Found 45500 records... Found 46000 records... Found 46500 records... Found 47000 records... Found 47500 records... Found 48000 records... Found 48500 records... Found 49000 records... Found 49500 records... Found 50000 records... Found 50500 records... Found 51000 records... Found 51500 records... Found 52000 records... Found 52500 records... Found 53000 records... Found 53500 records... Found 54000 records... Found 54500 records... Found 55000 records... Found 55500 records... Found 56000 records... Found 56500 records... Found 57000 records... Found 57500 records... Found 58000 records... Found 58500 records... Found 59000 records... Found 59500 records... Found 60000 records... Found 60500 records... Found 61000 records... Found 61500 records... Found 62000 records... Found 62500 records... Found 63000 records... Found 63500 records... Found 64000 records... Found 64500 records... Found 65000 records... Found 65500 records... Found 66000 records... Found 66500 records... Found 67000 records... Found 67500 records... Found 68000 records... Found 68500 records... Found 69000 records... Found 69500 records... Found 70000 records... Found 70500 records... Found 71000 records... Found 71500 records... Found 72000 records... Found 72500 records... Found 73000 records... Found 73500 records... Found 74000 records... Found 74500 records... Found 75000 records... Found 75500 records... Found 76000 records... Found 76500 records... Found 77000 records... Found 77500 records... Found 78000 records... Found 78500 records... Found 79000 records... Found 79500 records... Found 80000 records... Found 80500 records... Found 81000 records... Found 81500 records... Found 82000 records... Found 82500 records... Found 83000 records... Found 83500 records... Found 84000 records... Found 84500 records... Found 85000 records... Found 85500 records... Found 86000 records... Found 86500 records... Found 87000 records... Found 87500 records... Found 88000 records... Found 88500 records... Found 89000 records... Found 89500 records... Found 90000 records... Found 90500 records... Found 91000 records... Found 91500 records... Found 92000 records... Found 92500 records... Found 93000 records... Found 93500 records... Found 94000 records... Found 94500 records... Found 95000 records... Found 95500 records... Found 96000 records... Found 96500 records... Found 97000 records... Found 97500 records... Found 98000 records... Found 98500 records... Found 99000 records... Found 99500 records... Found 100000 records... Found 100500 records... Found 101000 records... Found 101500 records... Found 102000 records... Found 102500 records... Found 103000 records... Found 103500 records... Found 104000 records... Found 104500 records... Found 105000 records... Found 105500 records... Found 106000 records... Found 106500 records... Found 107000 records... Found 107500 records... Found 108000 records... Found 108500 records... Found 109000 records... Found 109500 records... Found 110000 records... Found 110500 records... Found 111000 records... Found 111500 records... Found 112000 records... Found 112500 records... Found 113000 records... Found 113500 records... Found 114000 records... Found 114500 records... Found 115000 records... Found 115500 records... Found 116000 records... Found 116500 records... Found 117000 records... Found 117500 records... Found 118000 records... Found 118500 records... Found 119000 records... Found 119500 records... Found 120000 records... Found 120500 records... Found 121000 records... Found 121500 records... Found 122000 records... Found 122500 records... Found 123000 records... Found 123500 records... Found 124000 records... Found 124500 records... Found 125000 records... Found 125500 records... Found 126000 records... Found 126500 records... Found 127000 records... Found 127500 records... Found 128000 records... Found 128500 records... Found 129000 records... Found 129500 records... Found 130000 records... Found 130500 records... Found 131000 records... Found 131500 records... Found 132000 records... Found 132500 records... Found 133000 records... Found 133500 records... Found 134000 records... Found 134500 records... Found 135000 records... Found 135500 records... Found 136000 records... Found 136500 records... Found 137000 records... Found 137500 records... Found 138000 records... Found 138500 records... Found 139000 records... Found 139500 records... Found 140000 records... Found 140500 records... Found 141000 records... Found 141500 records... Found 142000 records... Found 142500 records... Found 143000 records... Found 143500 records... Found 144000 records... Found 144500 records... Found 145000 records... Found 145500 records... Found 146000 records... Found 146500 records... Found 147000 records... Found 147500 records... Found 148000 records... Found 148500 records... Found 149000 records... Found 149500 records... Found 150000 records... Found 150500 records... Found 151000 records... Found 151500 records... Found 152000 records... Found 152500 records... Found 153000 records... Found 153500 records... Found 154000 records... Found 154500 records... Found 155000 records... Found 155500 records... Found 156000 records... Found 156500 records... Found 157000 records... Found 157500 records... Found 158000 records... Found 158500 records... Found 159000 records... Found 159500 records... Found 160000 records... Found 160500 records... Found 161000 records... Found 161500 records... Found 162000 records... Found 162500 records... Found 163000 records... Found 163500 records... Found 164000 records... Found 164500 records... Found 165000 records... Found 165500 records... Found 166000 records... Found 166500 records... Found 167000 records... Found 167500 records... Found 168000 records... Found 168500 records... Found 169000 records... Found 169500 records... Found 170000 records... Found 170500 records... Found 171000 records... Found 171500 records... Found 172000 records... Found 172500 records... Found 173000 records... Found 173500 records... Found 174000 records... Found 174500 records... Found 175000 records... Found 175500 records... Found 176000 records... Found 176500 records... Found 177000 records... Found 177500 records... Found 178000 records... Found 178500 records... Found 179000 records... Found 179500 records... Found 180000 records... Found 180500 records... Found 181000 records... Found 181500 records... Found 182000 records... Found 182500 records... Found 183000 records... Found 183500 records... Found 184000 records... Found 184500 records... Found 185000 records... Found 185500 records... Found 186000 records... Found 186500 records... Found 187000 records... Found 187500 records... Found 188000 records... Found 188500 records... Found 189000 records... Found 189500 records... Found 190000 records... Found 190500 records... Found 191000 records... Found 191500 records... Found 192000 records... Found 192500 records... Found 193000 records... Found 193500 records... Found 194000 records... Found 194500 records... Found 195000 records... Found 195500 records... Found 196000 records... Found 196500 records... Found 197000 records... Found 197500 records... Found 198000 records... Found 198500 records... Found 199000 records... Found 199500 records... Found 200000 records... Found 200500 records... Found 201000 records... Found 201500 records... Found 202000 records... Found 202500 records... Found 203000 records... Found 203500 records... Found 204000 records... Found 204500 records... Found 205000 records... Found 205500 records... Found 206000 records... Found 206500 records... Found 207000 records... Found 207500 records... Found 208000 records... Found 208500 records... Found 209000 records... Found 209500 records... Found 210000 records... Found 210500 records... Found 211000 records... Found 211500 records... Found 212000 records... Found 212500 records... Found 213000 records... Found 213500 records... Found 214000 records... Found 214500 records... Found 215000 records... Found 215500 records... Found 216000 records... Found 216500 records... Found 217000 records... Found 217500 records... Found 218000 records... Found 218500 records... Found 218515 records... Imported 218515 records. Simplifying...
dois_df %>%
  filter(!is.na(doi_cleaned)) %>%
  mutate(doi_cleaned = tolower(doi_cleaned)) %>%
  inner_join(oa, by = c("doi_cleaned" = "doi")) %>%
    summarise(n_distinct(family_id))
#> # A tibble: 1 × 1
#>   `n_distinct(family_id)`
#>                     <int>
#> 1                  145595
# distinct dois
length(unique(oa$doi))
#> [1] 218515
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
#> # A tibble: 4,244 × 1
#>    family_id
#>        <dbl>
#>  1  52668146
#>  2  62838906
#>  3  59057557
#>  4  54261183
#>  5  38859094
#>  6  39275445
#>  7  33479817
#>  8  60116481
#>  9  72423946
#> 10  59274055
#> # … with 4,234 more rows
# npl
npl_pattern %>% 
    filter(repo_pattern %in% c("pmid", "pmcid")) %>%
    distinct(npl_text) %>%
    nrow()
#> [1] 11521
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
#> [1] 7627
# all distinct families
bind_rows(distinct_pmid_family, distinct_pmcid_family) %>%
  distinct() %>%
  nrow()
#> [1] 4105
```

``` r
epmc_df <- readr::read_csv("data/epmc_pmid_pmc.csv")

epmc_08_20 <- epmc_df %>%
  select(id, publication_number, pubYear, isOpenAccess) %>%
  filter(pubYear > 2007, pubYear < 2021) %>%
  inner_join(npl_pattern, by = "publication_number")
# distinct pids
length(unique(epmc_08_20$id))
#> [1] 2984
# distinct families
length(unique(epmc_08_20$family_id))
#> [1] 1964
```

#### arxiv

``` r
# patent families
npl_pattern %>% 
    filter(repo_pattern %in% c("rxiv")) %>%
    distinct(family_id) %>%
    nrow
#> [1] 16513
# npl
npl_pattern %>% 
    filter(repo_pattern %in% c("rxiv")) %>%
    distinct(npl_text) %>%
    nrow()
#> [1] 29574
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
#> [1] 10740
# distinct pids
length(unique(arxiv_patent$arxiv_id))
#> [1] 9501
arxiv_patent_08_20 <- arxiv_patent %>% 
  filter(submitted >= "2008-01-01", submitted < "2021-01-01")

# distinct families
length(unique(arxiv_patent_08_20$family_id))
#> [1] 10603
# distinct pids
length(unique(arxiv_patent_08_20$arxiv_id))
#> [1] 9346
```

### total 2008 - 2020

``` r
upw <- dois_df %>%
  filter(!is.na(doi_cleaned)) %>%
  mutate(doi_cleaned = tolower(doi_cleaned)) %>%
  inner_join(oa, by = c("doi_cleaned" = "doi")) 
upw_df <- upw %>%
  select(pid = doi_cleaned, family_id, publication_number, is_oa, year) %>%
  distinct()
epmc_08_20_df <- epmc_08_20 %>%
  select(pid = id, family_id, publication_number, year = pubYear, isOpenAccess) %>%
  distinct() %>%
  mutate(is_oa = ifelse(isOpenAccess == "Y", TRUE, FALSE)) %>%
  select(-isOpenAccess)
arxiv_patent_08_20_df <- arxiv_patent_08_20 %>%
  mutate(year = lubridate::year(submitted)) %>%
  select(pid = arxiv_id, family_id, publication_number, year) %>%
  mutate(is_oa = TRUE)
total_df <- bind_rows(upw_df, epmc_08_20_df, arxiv_patent_08_20_df)

write_csv(total_df, "data/npl_oa_2008_2020.csv")
length(unique(total_df$pid))
#> [1] 230845
length(unique(total_df$family_id))
#> [1] 155291
```
