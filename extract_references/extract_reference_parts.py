import pandas as pd

# import data
patents = pd.read_csv("../data/rand_npl.csv",
                      encoding='utf-8')

# remove superfluous columns
patents_clean = patents.drop(columns = ['rand'])
patents_clean = patents_clean.drop(columns = ['country_code'])



# define function for extracting parts of references
def extract_part(search_str, df = patents_clean, var = 'npl_text'):
    return df[var].str.extract(fr'{search_str}')


patents_clean['authors'] = extract_part('^(\w.*?):')
patents_clean['title'] = extract_part('\"+(.*?)\"')


# Extract DOI
# regex pattern with slight modification from
# https://stackoverflow.com/a/10324802/3149349
# this is the simplified version in the middle of him developing the regex.
# If it works sufficiently well, let's keep it at that
patents_clean['doi'] = extract_part('(10[.][0-9]{4,}(?:[.][0-9]+)*/\S+)')


# adapted from https://www.regextester.com/94221
patents_clean['issn'] = extract_part('(?:ISSN|eISSN):?\s?([\S]{4}\-[\S]{4})')


# adapted from https://stackoverflow.com/a/4374209/3149349
patents_clean['year'] = extract_part('\(([12][0-9]{3})\-')

patents_clean['url'] = extract_part('<URL:(.*?)>')

patents_clean['journal_title'] = extract_part(',\s([A-Z\W]+?),')


patents_clean.to_csv("processed_data/extracted_references.csv",
                     encoding='utf-8', index=False)

# still todo:
# the following pattern seems to be quite common, but the current regexes
# fail to extract authors, journal, and year:
# "SHIELDS ET AL., J BIOL. CHEM., vol. 9, no. 2, 2001, pages 6591 - 6604"