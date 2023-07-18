# Cleaning data for call center company - 
# they want data cleaned and unnecessary rows/columns removed

import pandas as pd

df = pd.read_excel('/Users/cameronpeterson/Downloads/Customer Call List.xlsx')
df

# After assessing the data, we need to:
    # drop dupliactes 
    # drop unnecessary columns
    # clean data of unwanted characters
    # standardize phone number
    # fix addresses
    # standardize 'Yes' and 'No'
    # standardize null values
    # remove rows that call center is unable to call
    # reset indexes

# drop duplicates
df = df.drop_duplicates()


# drop unnecessary columns
df = df.drop(columns = 'Not_Useful_Column')


# clean extra characters (Last_Name)
df['Last_Name'] = df['Last_Name'].str.strip("/._")


# standardize phone number - format: ###-###-####
df['Phone_Number'] = df['Phone_Number'].str.replace('[^a-zA-Z0-9]', "")
df['Phone_Number'] = df['Phone_Number'].apply(lambda x: str(x))
df['Phone_Number'] = df['Phone_Number'].apply(lambda x: x[0:3] + "-" + x[3:6] + "-" + x[6:10])
df['Phone_Number'] = df['Phone_Number'].str.replace('nan--','')
df['Phone_Number'] = df['Phone_Number'].str.replace('Na--','')


# fix addressess - split into address, state, zip
df[['Street_Address', 'State', 'Zipcode']] = df['Address'].str.split(',', 2, expand = True)


# standardize "Yes", "Y", "No", "N" 

df['Paying Customer'] = df['Paying Customer'].str.replace('Yes', 'Y')
df['Paying Customer'] = df['Paying Customer'].str.replace('No', 'N')
df['Do_Not_Contact'] = df['Do_Not_Contact'].str.replace('Yes', 'Y')
df['Do_Not_Contact'] = df['Do_Not_Contact'].str.replace('No', 'N')


# standardize null values
df = df.replace('N/a','')
df = df.fillna('')


# remove rows that company is unable to call
for x in df.index:
    if df.loc[x, "Do_Not_Contact"] == 'Y':
        df.drop(x, inplace=True)

df.dropna(subset = "Phone_Number", inplace = True)


# reset indexes to match new data rows
df = df.reset_index(drop = True)
