## Notebooks T4.3 - investigating patents 

### Aim

Create a dataset to investigate the prevalence of  Open Science practices in European patent literature by 

- extracting scholarly publications cited in patents (NPL) issued by European Patent Offices
- identifing the OA status of NPLs using CORE and MAG
- linking to other sources with rich scholarly data 

This repository keep tracks of the work, using dynamic notebooks (R Markdown, Jupyter Notebook). 

### Data

Our main data source is Google Patents. Google makes snapshots available on BigQuery. 

- [Overview](https://github.com/on-merrit/patent_exploration/blob/master/notes.md)


### Current status

- [Created a random sample of 10,000 NPLs](https://github.com/on-merrit/patent_exploration/blob/master/ep_npl_sample.md)
- [Extraction NPL](https://github.com/on-merrit/patent_exploration/blob/master/extract_references/extract_references.ipynb)
- Pre-Evaluation
	- [Quantified sucess](https://github.com/on-merrit/patent_exploration/blob/master/extract_references/quantify_success.md)
	- [Qualitative Assessment](https://github.com/on-merrit/patent_exploration/blob/master/ep_npl_eval.md)

### Next steps

- Pre-test: Matching with CORE and MAG
- Discuss whether a) we want to continue with this approach, or b) rather re-use already available discovery solutions (Lens) for our analysis 
- Likewise, need decide whether we aim for a large-scale analysis or restrict ourselves to some subject fields relevant for On-Merrit using patent classification
