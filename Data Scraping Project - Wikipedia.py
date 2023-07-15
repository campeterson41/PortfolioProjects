#!/usr/bin/env python
# coding: utf-8

# In[2]:


from bs4 import BeautifulSoup
import requests


# In[3]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'

page = requests.get(url)

soup = BeautifulSoup(page.text, 'html')


# In[16]:


table = soup.find_all('table')[1]


# In[17]:


world_titles = table.find_all('th')


# In[18]:


world_table_titles = [title.text.strip() for title in world_titles]
print(world_table_titles)


# In[19]:


import pandas as pd


# In[20]:


df = pd.DataFrame(columns = world_table_titles)


# In[23]:


column_data = table.find_all('tr')


# In[25]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]

    length = len(df)
    df.loc[length] = individual_row_data


# In[26]:


df


# In[27]:


df.to_csv(r'/Users/cameronpeterson/Documents/Sorting folder/Companies.csv', index = False)


# In[ ]:




