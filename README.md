## Notebooks T4.3 - investigating patents 

### Aim

Create a dataset to investigate the prevalence of  Open Science practices in European patent literature by 

- extracting scholarly publications cited in patents (NPL) issued by European Patent Offices
- identifing the OA status of NPLs
- linking to other sources with rich scholarly data 

This repository keep tracks of the work, using dynamic notebooks (R Markdown, Jupyter Notebook). 

#### Source code supplement: ON-MERRIT D4.3 Quantifying the influence of Open Access on innovation and patents

Source code supplement for

Jahn, Najko, Klebel, Thomas, Pride, David, & Ross-Hellauer, Tony. (2021). ON-MERRIT D4.3 Quantifying the influence of Open Access on innovation and patents (1.0). Zenodo. <https://doi.org/10.5281/zenodo.5550524>

##### Analysis

- [d4.3.Rmd](d4.3.Rmd) contains code used for presenting results in the deliverable. Resulting plots can be found in [figure/](figure/).

##### Data gathering

###### NPL coverage

- Done via Google BigQuery Patent datasets. See [sql/](sql/) for corresponding SQL code. SQL statements were run in [d4.3.Rmd](d4.3.Rmd).

###### OA categorization

- [Script](oa_cat.R); resulting datasets attached to GitHub release because of data file size. We used a local snapshot from Unpaywall. See [sql/enrich_oa_with_patent_md.sql](sql/enrich_oa_with_patent_md.sql) as well as corresponding code in  [d4.3.Rmd](d4.3.Rmd).
- [analysis/extract_ids.R] demonstrates how we extracted IDs from the repositories PMC and arxiv as further OA evidence source

###### Preprint analysis

- [analysis/extract_ids.R] demonstrates how we extracted IDs from the arxiv inclduing DOI to published version, if available
- [cr_prepints.R](cr_prepints.R) shows how preprint information were gathered from Crossref.


### Further explorative activties

- [Created a random sample of 10,000 NPLs](https://github.com/on-merrit/patent_exploration/blob/master/ep_npl_sample.md)
- [Extraction NPL](https://github.com/on-merrit/patent_exploration/blob/master/extract_references/extract_references.ipynb)
- Pre-Evaluation
	- [Quantified sucess](https://github.com/on-merrit/patent_exploration/blob/master/extract_references/quantify_success.md)
	- [Qualitative Assessment](https://github.com/on-merrit/patent_exploration/blob/master/ep_npl_eval.md)

## License

This work is licensed under [CCO](https://creativecommons.org/publicdomain/zero/1.0/). Using CC0, we waive all copyrights and related or neighboring rights that we may have in all jurisdictions worldwide.