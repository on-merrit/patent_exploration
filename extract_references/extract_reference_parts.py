import pandas as pd
import re

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

# the following pattern seems to be quite common, but the current regexes
# fail to extract authors, journal, and year:
# "SHIELDS ET AL., J BIOL. CHEM., vol. 9, no. 2, 2001, pages 6591 - 6604"

# approach: find those cases, and apply a different extraction algorithm to them
# for this case
# new_case = r'^[A-Z\.,\s;\'-]+vol.+,\s?pages'
# this approach is to specific. It seems that having no colon is a better
# approximation
new_case = r'^[^:\"]+vol.+,\s?pages'
patents_clean['short_cases'] = patents_clean['npl_text'].str.match(new_case)
# find authors etc.

# using apply: https://stackoverflow.com/a/18194448/3149349
def extract_new_case(row, search_str, column):
    if row['short_cases']:
        extractions = re.search(search_str, row['npl_text'])
        if extractions is not None:
            return extractions.group(1)
        else:
            return None
    elif column is None:
        return None
    else:
        return row[column]

patents_clean['authors'] = patents_clean. \
    apply(extract_new_case, axis = 1, search_str = r'^(.+?),',
          column = 'authors')


patents_clean['journal_title'] = patents_clean. \
    apply(extract_new_case, axis = 1, search_str = r'^.+?,(.+?),\svol',
          column = 'journal_title')
# this does not work for cases where there are no authors
# for those we could simply swap 'authors' with 'journal_title' if there is an
# author but no journal
def get_journal(row, column):
    if row['short_cases']:
        if row[column] is None:
            return row['authors']
        else:
            return row[column]
    else:
        return row[column]

patents_clean['journal_title'] = patents_clean. \
    apply(get_journal, axis = 1, column = 'journal_title')

# delete authors for swapped journal titles
def delete_author(row, column):
    if row['short_cases']:
        if row[column] == row['journal_title']:
            return None
        else:
            return row[column]
    else:
        return row[column]

patents_clean['authors'] = patents_clean. \
        apply(delete_author, axis=1, column='authors')

# get volume
patents_clean['volume'] = patents_clean. \
    apply(extract_new_case, axis = 1, search_str = r'vol\.\s(\d+)',
          column = None)

# get issue number
patents_clean['number'] = patents_clean. \
    apply(extract_new_case, axis = 1, search_str = r'no\.\s(\d+)',
          column = None)

# get year
patents_clean['year'] = patents_clean. \
    apply(extract_new_case, axis = 1, search_str = r'(\d{4}).*?,\spages',
          column = 'year')

patents_clean.to_csv("processed_data/extracted_references.csv",
                     encoding='utf-8', index=False)

