#!/usr/bin/env python3
"""
Fast populate script using minimal openpyxl operations
"""

import os
import re
import sys
from datetime import datetime
from collections import defaultdict

try:
    import PyPDF2
    from openpyxl import load_workbook
    from openpyxl.utils import get_column_letter
except ImportError as e:
    print(f"ERROR: Missing required library: {e}")
    sys.exit(1)

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
                            
                            if full_transaction.find('Af') > 0 and full_transaction.find('Af') < full_transaction.rfind(','):
                                amount = -abs(amount)
                            else:
                                amount = abs(amount)
                            
                            # Extract description
                            description = re.sub(r'\d{2}-\d{2}-\d{4}', '', full_transaction)
                            description = re.sub(r'\d+,\d{2}', '', description)
                            description = re.sub(r'NL\d+[A-Z]+\d+', '', description)
                            description = re.sub(r'\s+', ' ', description).strip()
                            
                            if description:
                                transactions.append({
                                    'date': date_obj,
                                    'description': description[:120],
                                    'amount': amount
                                })
                    except (ValueError, IndexError):
                        pass
                
                i += 1
        
        print(f"Extracted {len(transactions)} transactions from PDF")
    except Exception as e:
        print(f"ERROR reading PDF: {e}")
        return None
    
    return transactions

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    pdf_path = os.path.join(base_dir, 'Knab_Transacties_2025.pdf')
    excel_path = os.path.join(base_dir, 'belasting 2025 analyse.xlsx')
    template_path = os.path.join(base_dir, 'belasting 2024 analyse.xlsx')
    
    print(f"Working directory: {base_dir}")
    print(f"PDF file:   {pdf_path}")
    print(f"Excel file: {excel_path}\n")
    
    if not os.path.exists(pdf_path):
        print(f"ERROR: PDF file not found: {pdf_path}")
        return False
    
    if not os.path.exists(template_path):
        print(f"ERROR: Template file not found: {template_path}")
        return False
    
    # Extract transactions from PDF
    print("EXTRACTING TRANSACTIONS FROM PDF")
    print("="*80)
    transactions = extract_transactions_from_pdf(pdf_path)
    
    if not transactions:
        print("ERROR: Failed to extract transactions")
        return False
    
    print(f"\nPOPULATING EXCEL FILE")
    print("="*80)
    
    # Sort transactions by date
    transactions_sorted = sorted(transactions, key=lambda x: x['date'])
    
    # Categorize transactions
    categorized = defaultdict(list)
    for trans in transactions_sorted:
        description = trans['description'].lower()
        amount = trans['amount']
        
        if any(kw in description for kw in ['rijles', 'les auto', 'driving lesson', 'mw ', 'hr d', 'dhr ', 'betaalverzoek']):
            category = 'Inkomsten - Rijschool' if amount > 0 else 'Kosten - Rijschool'
        elif any(kw in description for kw in ['rijles', 'rijschool', 'autorijschool']):
            category = 'Kosten - Rijschool'
        elif any(kw in description for kw in ['internet', 'mobiel', 'telefoon', 'vodafone', 'telia', 'ziggo']):
            category = 'Kosten - Internet/Mobiel'
        elif any(kw in description for kw in ['shell', 'bp', 'tango', 'esso', 'aral', 'benzine', 'diesel', 'tankstation', 'lukoil', 'fuel']):
            category = 'Kosten - Rijschool'
        else:
            category = 'Inkomsten - Rijschool' if amount > 0 else 'Kosten - Rijschool'
        
        categorized[category].append(trans)
    
    # Open and populate Excel file
    try:
        # Load workbook
        wb = load_workbook(template_path)
        ws = wb['Transacties']
        
        # Clear existing data rows (keep header in row 1)
        ws.delete_rows(2, ws.max_row)
        
        # Write transactions
        row_idx = 2
        total_by_category = defaultdict(float)
        
        for category in sorted(categorized.keys()):
            for trans in categorized[category]:
                # Write values directly as text/numbers
                ws.cell(row=row_idx, column=1).value = trans['date'].strftime('%d/%m/%Y')
                ws.cell(row=row_idx, column=2).value = trans['description']
                ws.cell(row=row_idx, column=8).value = category
                ws.cell(row=row_idx, column=10).value = trans['amount']
                
                total_by_category[category] += trans['amount']
                row_idx += 1
        
        # Save workbook (minimal settings for speed)
        wb.save(excel_path)
        wb.close()
        
        print(f"SUCCESS: Populated {excel_path}")
        print(f"Total transactions: {len(transactions)}\n")
        print("Transactions by category:")
        for category in sorted(categorized.keys()):
            trans_list = categorized[category]
            total = sum(t['amount'] for t in trans_list)
            print(f"  {category:30} {len(trans_list):3} trans. (EUR {total:10.2f})")
        
        return True
    
    except Exception as e:
        print(f"ERROR populating Excel: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)
