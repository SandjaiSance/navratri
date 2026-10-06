#!/usr/bin/env python3
"""
Extract transactions from Knab PDF and create CSV with 4 columns:
1. Transactie datum (DD/MM/YYYY)
2. Bedrag bij (credit/incoming amount, or empty)
3. Bedrag af (debit/outgoing amount, or empty)
4. Omschrijving (description)
"""

import os
import re
import csv
from datetime import datetime

try:
    import PyPDF2
except ImportError:
    print("ERROR: PyPDF2 not installed")
    exit(1)

def extract_transactions_from_pdf(pdf_path):
    """Extract transactions from PDF"""
    transactions = []
    
    try:
        with open(pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            all_text = ""
            for page in pdf_reader.pages:
                all_text += page.extract_text() + "\n"
            
            lines = all_text.split('\n')
            i = 0
            while i < len(lines):
                line = lines[i].strip()
                date_match = re.match(r'^(\d{2}-\d{2}-\d{4})', line)
                if date_match:
                    try:
                        date_str = date_match.group(1)
                        date_obj = datetime.strptime(date_str, '%d-%m-%Y')
                        
                        # Collect next few lines for the full transaction
                        remaining_text = line[len(date_str):]
                        full_transaction = remaining_text
                        j = i + 1
                        while j < min(i + 10, len(lines)) and j - i < 8:
                            next_line = lines[j].strip()
                            if re.match(r'^\d{2}-\d{2}-\d{4}', next_line):
                                break
                            full_transaction += " " + next_line
                            j += 1
                        
                        # Extract amount
                        amount_matches = re.findall(r'(\d+),(\d{2})', full_transaction)
                        
                        if amount_matches:
                            last_amount = amount_matches[-1]
                            amount = float(f"{last_amount[0]}.{last_amount[1]}")
                            
                            # Determine if it's a debit or credit
                            is_debit = False
                            if full_transaction.find('Af') > 0 and full_transaction.find('Af') < full_transaction.rfind(','):
                                is_debit = True
                            
                            # Extract description
                            description = re.sub(r'\d{2}-\d{2}-\d{4}', '', full_transaction)
                            description = re.sub(r'\d+,\d{2}', '', description)
                            description = re.sub(r'NL\d+[A-Z]+\d+', '', description)
                            description = re.sub(r'\s+', ' ', description).strip()
                            
                            if description:
                                transactions.append({
                                    'date': date_obj,
                                    'date_text': date_obj.strftime('%d/%m/%Y'),
                                    'description': description[:120],
                                    'amount': amount,
                                    'is_debit': is_debit
                                })
                    except (ValueError, IndexError):
                        pass
                
                i += 1
        
        return transactions
    
    except Exception as e:
        print(f"ERROR reading PDF: {e}")
        return None

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    pdf_path = os.path.join(base_dir, 'Knab_Transacties_2025.pdf')
    csv_path = os.path.join(base_dir, 'transacties_2025.csv')
    
    print(f"PDF file:  {pdf_path}")
    print(f"CSV file:  {csv_path}\n")
    
    if not os.path.exists(pdf_path):
        print(f"ERROR: PDF file not found: {pdf_path}")
        return False
    
    # Extract transactions
    print("Extracting transactions from PDF...")
    transactions = extract_transactions_from_pdf(pdf_path)
    
    if not transactions:
        print("ERROR: Failed to extract transactions")
        return False
    
    # Sort by date
    transactions_sorted = sorted(transactions, key=lambda x: x['date'])
    
    # Write CSV
    print(f"Writing {len(transactions)} transactions to CSV...")
    try:
        with open(csv_path, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.writer(csvfile, delimiter=';')
            
            # Write header
            writer.writerow(['Transactie datum', 'Bedrag bij', 'Bedrag af', 'Omschrijving'])
            
            # Write data rows
            for trans in transactions_sorted:
                date_text = trans['date_text']
                bedrag_bij = '' if trans['is_debit'] else f"{trans['amount']:.2f}"
                bedrag_af = '' if not trans['is_debit'] else f"{trans['amount']:.2f}"
                description = trans['description']
                
                writer.writerow([date_text, bedrag_bij, bedrag_af, description])
        
        print(f"\nSUCCESS: Created {csv_path}")
        
        # Print summary
        credit_total = sum(t['amount'] for t in transactions_sorted if not t['is_debit'])
        debit_total = sum(t['amount'] for t in transactions_sorted if t['is_debit'])
        
        print(f"\nSummary:")
        print(f"  Total transactions: {len(transactions_sorted)}")
        print(f"  Total credits (bedrag bij): EUR {credit_total:,.2f}".replace(',', '_'))
        print(f"  Total debits (bedrag af):   EUR {debit_total:,.2f}".replace(',', '_'))
        print(f"  Net amount:                 EUR {(credit_total - debit_total):,.2f}".replace(',', '_'))
        
        return True
    
    except Exception as e:
        print(f"ERROR writing CSV: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    import sys
    success = main()
    sys.exit(0 if success else 1)
