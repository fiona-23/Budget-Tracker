//
//  CataOnly.py
//  Budget Tracker
//
//  Created by Fiona Evans on 10/13/24.
//

import pandas as pd
import os
from pypdf import PdfReader
import PyPDF2

# Define file paths
downloads_dir = r'/Users/fionae/Downloads'
#transactions_file = os.path.join(downloads_dir, 'expenses.csv')
transactions_file = os.path.join(downloads_dir, 'processed_transactions.csv')
categorization_file = os.path.join(downloads_dir, 'keywords.csv')
file_path = '/Users/fionae/Downloads/BankStatement.pdf'
output_csv = '/Users/fionae/Downloads/processed_transactions.csv'

# Read the keywords CSV
df_keywords = pd.read_csv(categorization_file)

# Create a keyword dictionary for categorization
keywords_dict = {column: df_keywords[column].dropna().tolist() for column in df_keywords.columns}

# Define category mappings for numerical codes
category_mapping = {
    "Entertainment": 3,
    "Transport": 1,
    "Food and Dining": 5,
    "Groceries": 501,
    "Restaurants": 502,
    "Rent": 601
}

# Function to categorize transactions based on description
def categorize_transaction(description):
    description = str(description).lower()  # Ensure description is a string and lowercase
    for category, keywords in keywords_dict.items():
        for keyword in keywords:
            if keyword.lower() in description:
                return category
    return 'Others'

# Function to add category columns to the DataFrame
def add_category_columns(df, category_mapping):
    # Initialize each category column with zeros
    for category, code in category_mapping.items():
        df[category] = 0

    # For each transaction, set the category column to its corresponding code
    for index, row in df.iterrows():
        category = row['Category']
        if category in category_mapping:
            df.at[index, category] = category_mapping[category]  # Set the category column value to the mapped code
    
    return df

# Function to save DataFrame to CSV
def save_to_csv(data, output_file):
    # Save the DataFrame to a CSV file
    data.to_csv(output_file, index=False)

# Read the transactions CSV
df_transactions = pd.read_csv(output_csv)

# Apply categorization to transactions
df_transactions['Category'] = df_transactions['Description'].apply(categorize_transaction)

# Add category columns with corresponding numerical codes
df_transactions = add_category_columns(df_transactions, category_mapping)

# Calculate total amount spent per category
category_totals = df_transactions.groupby('Category')['Amount'].sum().sort_values(ascending=False)

# Convert category totals into a DataFrame
df_totals = category_totals.reset_index()  # Resets the index so Category and Amount are columns

# Save the categorized transactions to CSV
output_file = os.path.join(downloads_dir, "categorized_transactions.csv")
save_to_csv(df_transactions, output_file)

# Save the total amount per category to a separate CSV file
category_totals_file = os.path.join(downloads_dir, "category_totals.csv")
df_totals.to_csv(category_totals_file, index=False)

# Print success message
print(f"Successfully saved categorized transactions to file: {output_file}")
print(f"Successfully saved category totals to file: {category_totals_file}")
