#!/usr/bin/env python3
"""
Populate 2025 analysis Excel file with transaction data using 2024 as template format.
"""

import os
import re
from datetime import datetime
from collections import defaultdict

try:
    import PyPDF2
    import openpyxl
except ImportError as e:
    print(f"[ERROR] Missing required library: {e}")
    exit(1)

def extract_transactions_from_pdf(pdf_path):
    """Extract transactions from PDF (using same logic as before)"""
    transactions = []
    
    try:
        with open(pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            
            # Concatenate all page text
            all_text = ""
            for page in pdf_reader.pages:
                all_text += page.extract_text() + "\n"
            
            lines = all_text.split('\n')
            
            # Find lines that start with a date in format DD-MM-YYYY
            i = 0
            while i < len(lines):
                line = lines[i].strip()
                
                # Check if line starts with a date
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
        
        print(f"[INFO] Extracted {len(transactions)} transactions from PDF")
    
    except Exception as e:
        print(f"[ERROR] Reading PDF: {e}")
        return None
    
    return transactions

def populate_excel_from_template(excel_path, transactions):
    """
    Populate Excel file using the format from the template (2024 file).
    """
    
    if not transactions:
        print("[ERROR] No transactions to populate")
        return False
    
    try:
        # Load the template workbook
        wb = openpyxl.load_workbook(excel_path)
        ws = wb['Transacties']
        
        # Clear existing data (keep header)
        for row in ws.iter_rows(min_row=2, max_row=ws.max_row):
            for cell in row:
                cell.value = None
        
        # Sort and categorize transactions
        transactions_sorted = sorted(transactions, key=lambda x: x['date'])
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
        
        # Write data rows
        row_idx = 2
        total_by_category = defaultdict(float)
        
        for category in sorted(categorized.keys()):
            transactions_for_category = categorized[category]
            
            for trans in transactions_for_category:
                # Write data in the same format as the template
                # Column 1: Date as text in dd/MM/yyyy format
                date_text = trans['date'].strftime('%d/%m/%Y')
                ws.cell(row=row_idx, column=1, value=date_text)
                ws.cell(row=row_idx, column=2, value=trans['description'])
                ws.cell(row=row_idx, column=8, value=category)
                ws.cell(row=row_idx, column=10, value=trans['amount'])
                
                total_by_category[category] += trans['amount']
                row_idx += 1
        
        # Save the workbook
        wb.save(excel_path)
        
        print(f"[SUCCESS] Populated: {excel_path}")
        print(f"  Total transactions: {len(transactions)}")
        print("\n  Transactions by category:")
        for category, trans_list in sorted(categorized.items()):
            total = sum(t['amount'] for t in trans_list)
            print(f"    {category:30} {len(trans_list):3} trans. (EUR {total:10.2f})")
        
        return True
    
    except Exception as e:
        print(f"[ERROR] Populating Excel: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Main function"""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    pdf_path = os.path.join(base_dir, 'Knab_Transacties_2025.pdf')
    excel_path = os.path.join(base_dir, 'belasting 2025 analyse.xlsx')
    
    print(f"Working directory: {base_dir}")
    print(f"PDF file:   {pdf_path}")
    print(f"Excel file: {excel_path}\n")
    
    if not os.path.exists(pdf_path):
        print(f"[ERROR] PDF file not found: {pdf_path}")
        return False
    
    if not os.path.exists(excel_path):
        print(f"[ERROR] Excel template not found: {excel_path}")
        return False
    
    # Extract transactions from PDF
    print("="*80)
    print("EXTRACTING TRANSACTIONS FROM PDF")
    print("="*80)
    transactions = extract_transactions_from_pdf(pdf_path)
    
    if not transactions:
        print("[ERROR] Failed to extract transactions")
        return False
    
    # Populate Excel file
    print("\n" + "="*80)
    print("POPULATING EXCEL FILE")
    print("="*80)
    success = populate_excel_from_template(excel_path, transactions)
    
    return success

if __name__ == '__main__':
    import sys
    success = main()
    sys.exit(0 if success else 1)
