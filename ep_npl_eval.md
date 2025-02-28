Evaluation ref extraction
================

``` r
library(tidyverse)
library(googlesheets4)
```

### Sheet

Load sheet with evaluation results for a random sample of 100 matched
references:

``` r
bg_eval <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1MF7MZBJcRe9ZEj6Id-ixYBK4t_FDXLXEa9ehVCtlrcM/edit#gid=1399287127")
```

### Indicators

Indicators:

  - the number of correct predictions (COR),
  - the number of actual predictions (ACT)
  - the number of possible predictions (POS)

**Precision** is defined as COR / ACT

**Recall** is defined COR / POS

See David Nadeau, Satoshi Sekine. A survey of named entity recognition
and classification. <https://nlp.cs.nyu.edu/sekine/papers/li07.pdf>

### Calculation

#### Precision

``` r
# precision COR / ACT
cor_sum <- bg_eval %>%
  pull(COR) %>%
  sum(na.rm = TRUE)
act_sum <-  bg_eval %>%
  pull(ACT) %>%
  sum(na.rm = TRUE)
cor_sum / act_sum
```

    ## [1] 0.9779614

#### Recall

``` r
# recall is defined  COR / POS
pos_sum <- bg_eval %>%
  pull(POS) %>%
  sum(na.rm = TRUE)
cor_sum / pos_sum
```

    ## [1] 0.7819383

### Issues

Publication types other than journal articles:

Book chapter

  - EP-2684744-B1
  - EP-3205514-A1

Database entries

  - EP-3162897-A1
  - EP-3461498-A1
  - EP-3392268-A1

Conference proceedings

  - EP-3540662-A1

Leaflets

  - EP-2959200-B1

Reports

  - EP-3419205-A1
  - EP-2151935-A4

Year and number not found, when reference follows the following
structure:

    GALLUZZO P; BOCCHETTA M: "Notch signaling in lung cancer", EXPERT REV ANTICANCER THER., vol. 11, 2011, pages 533 - 40

(EP-3095797-A1)
