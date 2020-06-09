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
  project = "cogent-tangent-279810"
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

<div class="knitsql-table">

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

</div>

### Sample Patents

``` sql
SELECT e.country_code, e.publication_number, d.npl_text
FROM `patents-public-data.patents.publications_201912` as e, UNNEST(citation) as d
WHERE d.npl_text like '%doi%' and country_code = 'EP'
LIMIT 10
```

<div class="knitsql-table">

| country\_code | publication\_number | npl\_text                                                                                                                                                                                                                                                                                                                                                                                             |
| :------------ | :------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EP            | EP-2451466-B1       | HOSPATTANKAR ET AL: “Amino acid sequence of human plasma apolipoprotein C-III from normalipidemic subjects”, FEBS LETTERS, vol. 197, no. 1-2, 3 March 1986 (1986-03-03), pages 67 - 73, XP025605875, DOI: <doi:10.1016/0014-5793(86)80300-3>                                                                                                                                                          |
| EP            | EP-1991931-A4       | CHENEY J: “An Empirical Evaluation of Simple DTD-Conscious Compression Techniques”, PROCEEDINGS OF THE EIGHTH INTERNATIONAL WORKSHOP ON THE WEB AND DATABASES, 16 June 2005 (2005-06-16) - 17 June 2005 (2005-06-17), Baltimore, USA, XP002612062, Retrieved from the Internet \<URL:<http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.62.9799&rep=rep1&type=pdf>\> \[retrieved on 20101130\] |
| EP            | EP-2754067-A4       | J. PLATE ET AL: “Occlusion Culling for Sub- Surface Models in Geo-Scientific Applications”, 1 January 2004 (2004-01-01), pages 1 - 6, XP055064053, Retrieved from the Internet \<URL:<http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.84.8042&rep=rep1&type=pdf>\> \[retrieved on 20130524\]                                                                                                 |
| EP            | EP-3494875-A1       | JEON ET AL.: “Bioinspired, Highly Stretchable, and Conductive Dry Adhesives Based on 1D/2D Hybrid Carbon Nanocomposites for All-in-One ECG Electrodes”, ACS NANO, vol. 10, 2016, pages 4770 - 4778, XP055356523, DOI: <doi:10.1021/acsnano.6b01355>                                                                                                                                                   |
| EP            | EP-2215824-A4       | FRANCISCO H. IMAI, ROY S. BERNS: “High-Resolution Multi-Spectral Image Archives: A Hybrid Approach”, November 1998 (1998-11-01), XP002599917, Retrieved from the Internet \<URL:<http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.75.211&rep=rep1&type=pdf>\> \[retrieved on 20100909\]                                                                                                       |
| EP            | EP-2215824-A4       | YONGHUI ZHAO, ROY S. BERNS: “Image-Based Spectral Reflectance Reconstruction Using the Matrix R Method”, vol. 32, no. 5, 20 August 2007 (2007-08-20), pages 343 - 351, XP002599916, Retrieved from the Internet \<URL:<http://onlinelibrary.wiley.com/doi/10.1002/col.20341/pdf>\> \[retrieved on 20100909\], DOI: 10.1002/col.20341                                                                  |
| EP            | EP-2275974-A2       | ZHENG ET AL.: “Machine Printed Text And Handwriting Identification In Noisy Document Images”, IEEE TRANS. PATTERN ANAL. MACH. INTELL., vol. 26, no. 3, 2004, pages 337 - 353, XP011106116, DOI: <doi:10.1109/TPAMI.2004.1262324>                                                                                                                                                                      |
| EP            | EP-2624462-A1       | MOSELY ET AL.: “A two-stage approach to harmonic rejection mixing using blind interference cancellation”, IEEE TRANSACTIONS ON CIRCUITS AND SYSTEMS II: EXPRESS BRIEFS, vol. 55, no. 10, October 2008 (2008-10-01), pages 966 - 970, XP011236580, DOI: <doi:10.1109/TCSII.2008.926796>                                                                                                                |
| EP            | EP-2100253-A4       | J. KITTLER ET AL.: “BIOSECURE BIOMETRICS FOR SECURE AUTHENTICATION”, 14 June 2005 (2005-06-14), pages 1 - 22, XP002612104, Retrieved from the Internet \<URL:<http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.109.6725&rep=rep1&type=pdf>\> \[retrieved on 20101129\]                                                                                                                        |
| EP            | EP-2817135-A4       | “Supporting Information: Nanostructure-Dependent Water-Droplet Adhesiveness Change in Superhydrophobic Anodic Aluminum Oxide Surfaces: From Highly Adhesive to Self-Cleanable”, 29 December 2009 (2009-12-29), XP055211428, Retrieved from the Internet \<URL:<http://pubs.acs.org/doi/suppl/10.1021/la904095x/suppl_file/la904095x_si_001.pdf>\> \[retrieved on 20150904\]                           |

Displaying records 1 - 10

</div>

``` sql
SELECT e.country_code, e.publication_number, d.npl_text
FROM `patents-public-data.patents.publications_201912` as e, UNNEST(citation) as d
WHERE e.application_number= 'US7527788'
LIMIT 10
```

<div class="knitsql-table">

| country\_code | publication\_number | npl\_text |
| :------------ | :------------------ | :-------- |

0 records

</div>
