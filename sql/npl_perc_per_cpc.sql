SELECT
  cpc,
  percentiles[
OFFSET
  (10)] AS p10,
  percentiles[
OFFSET
  (50)] AS p50,
  percentiles[
OFFSET
  (90)] AS p90
FROM (
  SELECT
    cpc,
    APPROX_QUANTILES(npl, 100) AS percentiles
  FROM (
    SELECT
      COUNT(DISTINCT d.npl_text) AS npl,
      SUBSTR(cpc.code, 1, 1) AS cpc,
      e.family_id
    FROM
      `patents-public-data.patents.publications` AS e,
      UNNEST(citation) AS d,
      UNNEST(cpc) AS cpc
    WHERE
      e.publication_date BETWEEN 20100101
      AND 20203121
      AND NOT (d.npl_text = ""
        OR d.npl_text = "None")
      AND e.application_kind = "A"
    GROUP BY
    cpc,
    e.family_id
    ORDER BY
      npl DESC )
  GROUP BY
    cpc )