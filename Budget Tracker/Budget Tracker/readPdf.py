//
//  readPdf.swift
//  Budget Tracker
//
//  Created by Fiona Evans on 10/13/24.
//

import pandas as pd
import os
from pypdf import PdfReader
import PyPDF2

# Files
file_path = '/Users/fionae/Downloads/BankStatement.pdf'
output_csv = '/Users/fionae/Downloads/processed_transactions.csv'


#Process the pdf file
def process_pdf(file_path):
    with open(file_path, 'rb') as file:
        reader = PyPDF2.PdfReader(file)

        #print(reader.pages[0].extract_text())

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
        for i in range(len(lines)):
            line = lines[i]
            tokens = line.split()
            if "/" in tokens[0] and len(tokens)>6:
                if "INTEREST" not in " ".join(tokens[2:-3]):
                    all_tokens.append(tokens[0]) #Date
                    all_tokens.append(tokens[len(tokens)-1]) #Amount
                    all_tokens.append(" ".join(tokens[2:-3])) #Description
                    all_tokens.append(tokens[len(tokens)-3]) #Ids
        return all_tokens


# Save the results to CSV
def save_to_csv(tokens, output_file):
    # Convert tokens into a structured list of dictionaries
    data = []
    for i in range(0, len(tokens)-3, 4):
        data.append({
            'Date': tokens[i],
            'Amount': tokens[i+1],
            'Description': tokens[i+2],
            'Id': tokens[i+3]
        })
    
    # Create a pandas DataFrame
    df = pd.DataFrame(data)
    
    # Save to CSV
    df.to_csv(output_file, index=False)



# Process PDF
third_tokens = process_pdf(file_path)

# Save the extracted tokens to a CSV file
save_to_csv(third_tokens, output_csv)


# Print or use the third tokens
for i in range(0, len(third_tokens)-3, 4):
    print(third_tokens[i], end = " ")
    print(third_tokens[i+1], end = " ")
    print(third_tokens[i+2], end = " ")
    print(third_tokens[i+3])
