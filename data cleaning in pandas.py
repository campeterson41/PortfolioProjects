#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Cleaning data for call center company - 
# they want data cleaned and unnecessary rows/columns removed


# In[1]:


import pandas as pd


# In[3]:


df = pd.read_excel('/Users/cameronpeterson/Downloads/Customer Call List.xlsx')


# In[ ]:


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


# In[7]:


# drop duplicates
df = df.drop_duplicates()


# In[9]:


# drop unnecessary columns
df = df.drop(columns = 'Not_Useful_Column')


# In[17]:


# clean extra characters (Last_Name)
df['Last_Name'] = df['Last_Name'].str.strip("/._")


# In[21]:


# standardize phone number - format: ###-###-####
df['Phone_Number'] = df['Phone_Number'].str.replace('[^a-zA-Z0-9]', "")


# In[22]:


df['Phone_Number'] = df['Phone_Number'].apply(lambda x: str(x))


# In[25]:


df['Phone_Number'] = df['Phone_Number'].apply(lambda x: x[0:3] + "-" + x[3:6] + "-" + x[6:10])


# In[27]:


df['Phone_Number'] = df['Phone_Number'].str.replace('nan--','')


# In[28]:


df['Phone_Number'] = df['Phone_Number'].str.replace('Na--','')


# In[30]:


# fix addressess - split into address, state, zip


# In[33]:


df[['Street_Address', 'State', 'Zipcode']] = df['Address'].str.split(',', 2, expand = True)


# In[ ]:


# standardize "Yes", "Y", "No", "N" 


# In[35]:


df['Paying Customer'] = df['Paying Customer'].str.replace('Yes', 'Y')


# In[36]:


df['Paying Customer'] = df['Paying Customer'].str.replace('No', 'N')


# In[52]:


df['Do_Not_Contact'] = df['Do_Not_Contact'].str.replace('Yes', 'Y')


# In[53]:


df['Do_Not_Contact'] = df['Do_Not_Contact'].str.replace('No', 'N')


# In[38]:


# standardize null values


# In[41]:


df = df.replace('N/a','')


# In[44]:


df = df.fillna('')


# In[45]:


# remove rows that company is unable to call


# In[55]:


for x in df.index:
    if df.loc[x, "Do_Not_Contact"] == 'Y':
        df.drop(x, inplace=True)


# In[63]:


df.dropna(subset = "Phone_Number", inplace = True)


# In[58]:


# reset indexes to match new data rows


# In[60]:


df = df.reset_index(drop = True)

