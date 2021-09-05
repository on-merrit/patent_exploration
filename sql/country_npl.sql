SELECT
  COUNT(DISTINCT e.family_id) as patent_families_with_npl,
  a.country_code
FROM
  `patents-public-data.patents.publications` AS e,
  UNNEST(citation) AS d,
  UNNEST(assignee_harmonized) as a
WHERE
  e.publication_date BETWEEN 20100101 AND 20203121
  AND NOT (d.npl_text = ""
    OR d.npl_text = "None")
  AND e.application_kind = "A"
GROUP BY
  a.country_code
ORDER BY patent_families_with_npl DESC