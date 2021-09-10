SELECT is_oa, year, COUNT(DISTINCT doi) as n
FROM `api-project-764811344545.oadoi_full.upw_Jul21_08_21` 
WHERE year < 2021 and genre = "journal-article"
GROUP BY is_oa, year