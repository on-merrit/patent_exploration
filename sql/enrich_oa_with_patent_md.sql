SELECT
  DISTINCT *
FROM (
  SELECT
    publication_number,
    family_id,
    EXTRACT(YEAR
    FROM
      PARSE_DATE("%Y%m%d",
        CAST(publication_date AS STRING))) AS pub_year,
    SUBSTR(cpc.code, 1, 1) AS cpc,
    a.country_code
  FROM
    `patents-public-data.patents.publications`,
    UNNEST(assignee_harmonized) AS a,
    UNNEST(cpc) AS cpc
  WHERE
    publication_date BETWEEN 20100101
    AND 20203121) AS e
INNER JOIN
  `api-project-764811344545.tmp.patent_oa`
ON
  e.publication_number = `api-project-764811344545.tmp.patent_oa`.publication_number