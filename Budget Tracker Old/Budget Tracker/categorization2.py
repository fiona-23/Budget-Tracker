#


mport pandas as pd
import os
from pypdf import PdfReader
import PyPDF2
# Define file paths
downloads_dir = r'/Users/fionae/Downloads'
#transactions_file = os.path.join(downloads_dir, 'expenses.csv')
transactions_file = os.path.join(downloads_dir, 'processed_transactions.csv')
categorization_file = os.path.join(downloads_dir, 'keywords.csv')

# Read transactions CSV
df_transactions = pd.read_csv(transactions_file)

# Read categorization CSV
df_keywords = pd.read_csv(categorization_file)

# Create a keyword dictionary for categorization
keywords_dict = {column: df_keywords[column].dropna().tolist() for column in df_keywords.columns}

def categorize_transaction(description):
    description = str(description).lower()  # Ensure description is a string and lowercase
    for category, keywords in keywords_dict.items():
        for keyword in keywords:
            if keyword.lower() in description:
                return category
    return 'Others'

#Process the pdf file
def process_pdf(file_path):
    with open(file_path, 'rb') as file:
        reader = PyPDF2.PdfReader(file)
        all_tokens = []
        noPage = 0
        for i in range(len(reader.pages)):
            page = reader.pages[i].extract_text()
            lines = page.split('\n')
            for j in range(len(lines)):
                tokens = lines[j].split()
                if "/" in tokens[0]:
                    noPage = i
        page = reader.pages[noPage].extract_text()
        lines = page.split('\n')
        for line in lines:
            description = ""
            tokens = line.split()  # Split each line into words (tokens)
            for i in range(len(tokens)):
                if "/" not in tokens[i]:
                    if len(tokens[i]) != 2:
                        description += tokens[i] + " "
                    else:
                        break
            if "/" in tokens[0] and tokens[len(tokens)-1] != 0.00:
                if description != "":
                    all_tokens.append(description)
                else:
                    all_tokens.append("Nothing")
                all_tokens.append(tokens[len(tokens)-1])
        return all_tokens

def save_to_csv(tokens, output_file):
    # Convert tokens into a structured list of dictionaries
    data = []
    for i in range(0, len(tokens)-1, 2):
        data.append({
            'Description': tokens[i],
            'Amount': tokens[i+1]
        })
    
    # Create a pandas DataFrame
    df = pd.DataFrame(data)
    
    # Save to CSV
    df.to_csv(output_file, index=False)

file_path = '/Users/fionae/Downloads/BankStatement.pdf'
output_csv = '/Users/fionae/Downloads/processed_transactions.csv'

third_tokens = process_pdf(file_path)

# Save the extracted tokens to a CSV file
save_to_csv(third_tokens, output_csv)


# Apply categorization to transactions
df_transactions['Category'] = df_transactions['Description'].apply(categorize_transaction)

# Calculate total amount spent per category
category_totals = df_transactions.groupby('Category')['Amount'].sum().sort_values(ascending=False)

# Convert category totals into a DataFrame
df_totals = category_totals.reset_index()  # Resets the index so Category and Amount are columns

# Save the total amount per category to a CSV file
output_file = os.path.join(downloads_dir, "category_totals.csv")
df_totals.to_csv(output_file, index=False)

# Print success message
print("Successfully saved category totals to file:", output_file)
