SELECT
  COUNT(DISTINCT e.family_id),
  EXTRACT(YEAR
  FROM
    PARSE_DATE("%Y%m%d",
      CAST(e.publication_date AS STRING))) AS pub_year,
  SUBSTR(cpc.code, 1, 1) AS cpc
FROM
  `patents-public-data.patents.publications` AS e,
  UNNEST(citation) AS d,
  UNNEST(cpc) AS cpc
WHERE
  e.publication_date >= 20100101
  AND NOT (d.npl_text = ""
    OR d.npl_text = "None")
  AND e.application_kind = "A"
GROUP BY
  pub_year,
  cpc