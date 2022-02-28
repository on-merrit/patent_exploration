library(tidyverse)
library(jsonlite)
oa <- jsonlite::stream_in(file("data/oa_patents.json"), verbose = FALSE)

upw_provider <- oa %>%
select(doi, oa_locations, has_repository_copy) %>%
unnest(oa_locations) %>%
  filter(is_best == TRUE) %>%
  mutate(provider_cat = case_when(
    host_type == "publisher" & has_repository_copy == TRUE ~ "Journal & Repository",
    host_type == "repository" ~ "Repository only",
    host_type == "publisher" ~ "Journal only"
  )) %>%
  select(pid = doi, provider_cat)

epmc_provider <- readr::read_csv("data/epmc_pmid_pmc.csv") %>%
  select(pid = id, isOpenAccess) %>%
  mutate(provider_cat = case_when(
    isOpenAccess == "Y" ~ "Journal & Repository"
  )) %>%
  mutate(pid = as.character(pid)) %>%
  select(-isOpenAccess)

arxiv_provider <- readr::read_csv("data/arxid_ids.csv") %>%
  select(id, doi) %>%
  distinct() %>%
  filter(!is.na(id)) %>%
  separate(id, into = c("id_", "version"), sep = "v") %>%
  mutate(provider_cat = case_when(
    is.na(doi) ~ "Repository only",
    !is.na(doi) ~ "Journal & Repository"
  )) %>%
  select(pid = id_, provider_cat)

oa_providers <- bind_rows(upw_provider, epmc_provider, arxiv_provider) %>%
  filter(!is.na(provider_cat))
# add to oa_enriched
oa_enriched_df <- readr::read_csv("data/oa_patent_matched_md.csv")

oa_enriched_df_cat <- oa_enriched_df %>%
  left_join(oa_providers, by = "pid") %>%
  distinct()

write_csv(oa_enriched_df_cat, "data/oa_patent_matched_md_cat.csv")
