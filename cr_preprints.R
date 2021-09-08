library(tidyverse)
library(rcrossref)
library(jsonlite)
# obtain potential preprints
oa <- jsonlite::stream_in(file("data/oa_patents.json"), verbose = FALSE)
oa_preprints <- as_tibble(oa) %>%
    filter(year < 2021, genre == "posted-content")


#
cold_df <- purrr::map(oa_preprints$doi, purrr::safely(function(x) {
    req <- rcrossref::cr_works_(x, parse = FALSE)
    out <- jsonlite::fromJSON(req)
    tibble::tibble(
        doi = x,
        type = out$message$subtype,
        preprint_server = out$message$institution$name,
        title = out$message$title,
        created = out$created$`date-time`)
}))
cold_df_ <- purrr::map_df(cold_df, "result")
# backup
write_csv(cold_df_, "data/preprint_cr.csv")
