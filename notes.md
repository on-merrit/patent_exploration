BQ Patent Exploration
================

## About

Google Patents Public Datasets is a collection BigQuery database tables
from government, research and private companies for conducting
statistical analysis of patent data.

<https://cloud.google.com/blog/products/gcp/google-patents-public-datasets-connecting-public-paid-and-private-patent-data>

This notebook provides an overview about the structure of the BigQuery
datatable. A particular focus is on accessing non-patent literature
(NPL).

## Connect to Google Patents Public Datasets

``` r
library(tidyverse)
library(DBI)
library(bigrquery)
con <- dbConnect(
  bigrquery::bigquery(),
  project = "api-project-764811344545"
)
```

Alternatively, you can also use the Google BigQuery web GUI to query the
data.
<https://console.cloud.google.com/bigquery?project=api-project-764811344545&p=patents-public-data&d=patents&t=publications_201912&page=table>

## Patents with citing non-patent literature

``` sql
SELECT e.country_code, COUNT(DISTINCT(e.publication_number)) as n_patents
FROM `patents-public-data.patents.publications_201912` as e, UNNEST(citation) as d
WHERE d.npl_text != ''
GROUP BY e.country_code
ORDER BY n_patents desc
```

| country\_code | n\_patents |
| :------------ | ---------: |
| US            |    3711779 |
| EP            |    3242387 |
| CN            |    1983119 |
| WO            |    1848530 |
| SU            |     505897 |
| DE            |     381950 |
| RU            |     331151 |
| JP            |     262512 |
| FR            |     172951 |
| KR            |     145535 |

Displaying records 1 - 10

### Sample Patents

``` sql
SELECT e.country_code, e.publication_number, d.npl_text
FROM `patents-public-data.patents.publications_201912` as e, UNNEST(citation) as d
WHERE d.npl_text like '%doi%' and country_code = 'EP'
LIMIT 10
```

| country\_code | publication\_number | npl\_text                                                                                                                                                                                                                                                                                                                    |
| :------------ | :------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EP            | EP-1385526-B1       | T. MARUYAMA ET AL.: “Design and synthesis of a selective EP4-receptor agonist. Part 1: Discovery of 3,7-dithiaPGE1 derivatives and identification of their omega chains.”, BIOORGANIC & MEDICINAL CHEMISTRY, vol. 10, no. 4, April 2002 (2002-04-01), pages 975 - 988, XP002323894, DOI: <doi:10.1016/S0968-0896(01)00351-0> |
| EP            | EP-1498484-B1       | TSUYA ET AL: “Cloning and functional expression of glucose dehydrogenase complex of Burkholderia cepacia in Escherichia coli”, J. BIOTECH., vol. 123, 2006, pages 127 - 136, XP024956798, DOI: <doi:10.1016/j.jbiotec.2005.10.017>                                                                                           |
| EP            | EP-0793504-B1       | RABINOVITCH A.: “Immunoregulatory and cytokine imbalances in the pathogenesis of IDDM; therapeutic intervention by immunostimulation ?”, DIABETES, vol. 43, May 1994 (1994-05-01), pages 613 - 621, XP001036572, DOI: <doi:10.2337/diabetes.43.5.613>                                                                        |
| EP            | EP-1287155-B2       | LUTJE SPELBERG J.H. ET AL: “Enzymatic dynamic kinetic resolution if epihalohydrins”, TETRAHEDRON: ASYMMETRY, vol. 15, 1 January 2004 (2004-01-01), pages 1095 - 1102, XP004499059, DOI: <doi:10.1016/j.tetasy.2004.02.009>                                                                                                   |
| EP            | EP-1287155-B2       | LUTJE SPELBERG J.H. ET AL: “Highly enantioselevtive and regioselective biocatalytic azidolysis of aromatic epoxides”, ORGANIC LETTERS, vol. 3, no. 1, 1 January 2001 (2001-01-01), pages 41 - 43, XP055063057, DOI: <doi:10.1021/ol0067540>                                                                                  |
| EP            | EP-1287155-B2       | VAN HYLCKAMA J.E.T. ET AL: “Halohydrin dehalogenases are structurally and mechanistically related to short-chain dehydrogenases/reductases”, JOURNAL OF BACTERIOLOGY, vol. 183, 1 September 2001 (2001-09-01), pages 5058 - 5066, XP002305277, DOI: <doi:10.1128/JB.183.17.5058-5066.2001>                                   |
| EP            | EP-1524711-B2       | SHUKLA A.K. ET AL: “An XPS study on binary and ternary alloys of transition metals with platinized carbon and its bearing upon oxygen electroreduction in direct methanol fuel cells”, JOURNAL OF ELECTROANALYTICAL CHEMISTRY, vol. 504, 2001, pages 111 - 119, XP002326973, DOI: <doi:10.1016/S0022-0728(01)00421-1>        |
| EP            | EP-1524711-B2       | UNGÁR T. ET AL: “Microstructure of carbon blacks determined by X-ray diffraction profile analysis”, CARBON, vol. 40, 2002, pages 929 - 937, XP004346748, DOI: <doi:10.1016/S0008-6223(01)00224-X>                                                                                                                            |
| EP            | EP-1524711-B2       | WATANABE M. ET AL: “Activity and stability of ordered and disordered Co-Pt alloys for phosphoric acid fuel cells”, JOURNAL ELECTROCHEMICAL SOCIETY, vol. 141, no. 10, October 1994 (1994-10-01), pages 2659 - 2668, XP055233516, DOI: <doi:10.1149/1.2059162>                                                                |
| EP            | EP-0849595-A1       | ARSHADY: “Suspension, emulsion and dispersion polymerization: A Methodological Survey”, COLLOID & POLYMER SCIENCE, vol. 270, 1992, pages 717 - 732, XP002682310, DOI: <doi:10.1007/BF00776142>                                                                                                                               |

Displaying records 1 - 10
