SELECT
  COUNT(DISTINCT e.family_id) as patent_families,
  a.country_code
FROM
  `patents-public-data.patents.publications` AS e,
  UNNEST(assignee_harmonized) as a
WHERE
  e.publication_date BETWEEN 20100101 AND 20203121
  AND e.application_kind = "A"
GROUP BY
  a.country_code
ORDER BY patent_families DESC