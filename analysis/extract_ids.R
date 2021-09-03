library(tidyverse)
library(progress)
npl_pattern <- readr::read_csv("data/npl_pattern.csv")
# arxiv
tt <- npl_pattern %>% 
    filter(repo_pattern == "rxiv") %>%
    mutate(arxiv_id = str_extract(npl_text, "(\\d{4}\\.\\d{4,5})"))
#
library(aRxiv)
arxiv_ids <- tt %>%
    filter(!is.na(arxiv_id)) %>%
    pull(arxiv_id)
arxiv_ids_chuncks <- split(arxiv_ids, ceiling(seq_along(arxiv_ids)/100))

out <- purrr::map(arxiv_ids_chuncks, purrr::safely(function(x) {
    aRxiv::arxiv_search(id_list = x, limit = 100) %>%
    as_tibble()
}))
arxiv_df <- purrr::map_df(out, "result")
readr::write_csv(arxiv_df, "data/arxid_ids.csv" )
# pubmed/pmc
pmid_raw <- npl_pattern %>% 
    filter(repo_pattern == "pmid") %>%
    mutate(pmid_raw = str_extract(npl_text, "(PMID: (\\d{7,8}))|(PMID:(\\d{7,8}))|(PMID (\\d{7,8}))")) %>%
    mutate(pmid_cleaned = str_extract(pmid_raw, "\\d{7,8}"))
pmids <- pmid_raw %>%
    filter(!is.na(pmid_raw)) %>%
    pull(pmid_cleaned)

pb <- progress_bar$new(total = length(pmids),
  format = "  downloading [:bar] :percent eta: :eta",
)

out <- purrr::map(pmids, purrr::safely(function(x) {
      pb$tick()
      req <- suppressMessages(europepmc::epmc_search(paste0("EXT_ID:", x))) %>%
      mutate(pmids = x)
   req
}))
epmc_df <- purrr::map_df(out, "result")
readr::write_csv(epmc_df, "data/pmid_epmc_df.csv")
# pmcid
pmcid_raw <- npl_pattern %>%
    filter(repo_pattern == "pmcid") %>%
    mutate(pmcid_raw = str_extract(npl_text, "(PMCID: (\\d{5,7}))|(PMCID:(\\d{5,7}))|(PMCID (\\d{5,7}))|(PMC(\\d{5,7}))")) %>%
    mutate(pmcid_cleaned = str_extract(pmcid_raw, "\\d{5,7}"))
pmcids <- pmcid_raw %>%
    filter(!is.na(pmcid_cleaned)) %>%
    pull(pmcid_cleaned)

pb <- progress_bar$new(total = length(pmcids),
  format = "  downloading [:bar] :percent eta: :eta",
)

out <- purrr::map(pmcids, purrr::safely(function(x) {
      pb$tick()
      req <- suppressMessages(europepmc::epmc_search(paste0("PMCID:PMC", x))) %>%
      mutate(pmcids = x)
   req
}))
epmc__pmicid_df <- purrr::map_df(out, "result")

epmc_pmicid <- pmcid_raw %>%
    select(publication_number, pmcid_cleaned) %>%
    inner_join(epmc__pmicid_df, by = c("pmcid_cleaned" = "pmcids")) %>%
    mutate(source = "PMCID") %>%
    distinct()
# with pmid data
pmid_df <- readr::read_csv("data/pmid_epmc_df.csv", col_types = cols(.default = "c")) %>%
    mutate(citedByCount = as.integer(citedByCount))
epmc_pmid_df <- pmid_raw %>%
    select(publication_number, pmid_cleaned) %>%
    select(publication_number, pmid_cleaned) %>%
    inner_join(pmid_df, by = c("pmid_cleaned" = "pmids")) %>%
    mutate(source = "PMID") %>%
    distinct()
epmc_df <- bind_rows(epmc_pmid_df, epmc_pmicid)
write_csv(epmc_df, "data/epmc_pmid_pmc.csv")
