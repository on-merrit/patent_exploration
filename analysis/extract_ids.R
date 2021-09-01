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
