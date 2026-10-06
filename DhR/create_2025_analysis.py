#!/usr/bin/env python3
"""
Extract Knab transaction data from PDF and create belasting 2025 analyse.xlsx
"""

import os
import re
from datetime import datetime
from collections import defaultdict

try:
    import PyPDF2
    import openpyxl
    from openpyxl.styles import Font, PatternFill
except ImportError as e:
    print(f"Error: Missing required library: {e}")
    exit(1)

def extract_transactions_from_pdf(pdf_path):
    """
    Extract transactions from Knab PDF bank statement.
    The PDF has a table structure with Date, BookDate, Account, Name, Description, Debit, Credit
    """
    transactions = []
    
    try:
        with open(pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            print(f"PDF has {len(pdf_reader.pages)} pages")
            
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
                        
                        # The amount is likely on this line or the next few lines
                        # Search for amount pattern: digits,digits (amount in euros)
                        remaining_text = line[len(date_str):]  # Rest of the line after date
                        
                        # Collect next few lines to find the amount and description
                        full_transaction = remaining_text
                        j = i + 1
                        while j < min(i + 10, len(lines)) and j - i < 8:  # Look ahead up to 8 lines
                            next_line = lines[j].strip()
                            
                            # Stop if we hit another date (next transaction)
                            if re.match(r'^\d{2}-\d{2}-\d{4}', next_line):
                                break
                            
                            full_transaction += " " + next_line
                            j += 1
                        
                        # Extract amount - look for euros format (number,number)
                        amount_matches = re.findall(r'(\d+),(\d{2})', full_transaction)
                        
                        if amount_matches:
                            # The last amount is usually the transaction amount
                            last_amount = amount_matches[-1]
                            amount = float(f"{last_amount[0]}.{last_amount[1]}")
                            
                            # Determine if it's debit or credit
                            # If the word "Af" appears before amount, it's debit (expense)
                            if full_transaction.find('Af') > 0 and full_transaction.find('Af') < full_transaction.rfind(','):
                                amount = -abs(amount)
                            else:
                                amount = abs(amount)
                            
                            # Extract description - clean up
                            description = re.sub(r'\d{2}-\d{2}-\d{4}', '', full_transaction)  # Remove dates
                            description = re.sub(r'\d+,\d{2}', '', description)  # Remove amounts
                            description = re.sub(r'NL\d+[A-Z]+\d+', '', description)  # Remove IBAN
                            description = re.sub(r'\s+', ' ', description)  # Clean spaces
                            description = description.strip()
                            
                            if description:
                                transactions.append({
                                    'date': date_obj,
                                    'description': description[:120],
                                    'amount': amount
                                })
                                print(f"  {date_str}: {description[:50]:50} {amount:10.2f}")
                    
                    except (ValueError, IndexError) as e:
                        pass
                
                i += 1
        
        print(f"\nTotal extracted: {len(transactions)} transactions")
    
    except Exception as e:
        print(f"Error reading PDF: {e}")
        import traceback
        traceback.print_exc()
        return None
    
    return transactions

def create_excel_file(transactions, output_path):
    """
    Create Excel workbook in the format expected by build-rittenplanning.ps1
    """
    
    if not transactions:
        print("No transactions to process")
        # Create a template file anyway
        wb = openpyxl.Workbook()
        ws = wb.active
        ws.title = 'Transacties'
        
        headers = ['Datum', 'Omschrijving', '', '', '', '', '', 'Categorie', '', 'Bedrag']
        for col_idx, header in enumerate(headers, 1):
            cell = ws.cell(row=1, column=col_idx, value=header)
            if header:
                cell.font = Font(bold=True)
        
        wb.save(output_path)
        return True
    
    # Create workbook
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = 'Transacties'
    
    # Set up headers matching build-rittenplanning.ps1 expectations
    headers = [
        'Datum',                           # Column 1
        'Omschrijving',                    # Column 2
        '',                                # Column 3
        '',                                # Column 4
        '',                                # Column 5
        '',                                # Column 6
        '',                                # Column 7
        'Categorie',                       # Column 8
        '',                                # Column 9
        'Bedrag',                          # Column 10
    ]
    
    for col_idx, header in enumerate(headers, 1):
        cell = ws.cell(row=1, column=col_idx, value=header)
        if header:
            cell.font = Font(bold=True)
            cell.fill = PatternFill(start_color="D3D3D3", end_color="D3D3D3", fill_type="solid")
    
    # Sort transactions by date
    transactions_sorted = sorted(transactions, key=lambda x: x['date'])
    
    # Categorize transactions
    categorized = defaultdict(list)
    
    for trans in transactions_sorted:
        description = trans['description'].lower()
        amount = trans['amount']
        
        # Smart categorization based on keywords
        if any(kw in description for kw in ['rijles', 'les auto', 'driving lesson', 'mw ', 'hr d', 'dhr ', 'betaalverzoek']):
            # These are likely driving lesson payments (income)
            category = 'Inkomsten - Rijschool' if amount > 0 else 'Kosten - Rijschool'
        elif any(kw in description for kw in ['rijles', 'rijschool', 'autorijschool']):
            category = 'Kosten - Rijschool'
        elif any(kw in description for kw in ['internet', 'mobiel', 'telefoon', 'vodafone', 'telia', 'ziggo']):
            category = 'Kosten - Internet/Mobiel'
        elif any(kw in description for kw in ['shell', 'bp', 'tango', 'esso', 'aral', 'benzine', 'diesel', 'tankstation', 'lukoil', 'fuel']):
            category = 'Kosten - Rijschool'  # Fuel costs for driving school
        else:
            category = 'Inkomsten - Rijschool' if amount > 0 else 'Kosten - Rijschool'
        
        categorized[category].append(trans)
    
    # Write data rows
    row_idx = 2
    total_by_category = defaultdict(float)
    
    for category in sorted(categorized.keys()):
        transactions_for_category = categorized[category]
        
        for trans in transactions_for_category:
            # Write date as formatted text (dd/MM/yyyy)
            date_str = trans['date'].strftime('%d/%m/%Y')
            
            ws.cell(row=row_idx, column=1, value=date_str)
            
            ws.cell(row=row_idx, column=2, value=trans['description'])
            ws.cell(row=row_idx, column=8, value=category)
            ws.cell(row=row_idx, column=10, value=trans['amount'])
            ws.cell(row=row_idx, column=10).number_format = '0.00'
            
            total_by_category[category] += trans['amount']
            row_idx += 1
    
    # Add totals row
    row_idx += 1
    ws.cell(row=row_idx, column=1, value='TOTAAL')
    ws.cell(row=row_idx, column=1).font = Font(bold=True)
    
    for category, total in total_by_category.items():
        row_idx += 1
        ws.cell(row=row_idx, column=1, value=category)
        ws.cell(row=row_idx, column=10, value=total)
        ws.cell(row=row_idx, column=10).number_format = '0.00'
        ws.cell(row=row_idx, column=1).font = Font(bold=True)
    
    # Auto-fit columns
    ws.column_dimensions['A'].width = 14
    ws.column_dimensions['B'].width = 50
    ws.column_dimensions['H'].width = 30
    ws.column_dimensions['J'].width = 12
    
    # Save workbook
    try:
        wb.save(output_path)
        print(f"\n[SUCCESS] Created: {output_path}")
        print(f"  Total transactions: {len(transactions)}")
        print("\n  Transactions by category:")
        for category, trans_list in sorted(categorized.items()):
            total = sum(t['amount'] for t in trans_list)
            print(f"    {category:30} {len(trans_list):3} trans. €{total:10.2f}")
        return True
    except Exception as e:
        print(f"[ERROR] Error saving Excel file: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Main function"""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    pdf_path = os.path.join(base_dir, 'Knab_Transacties_2025.pdf')
    output_path = os.path.join(base_dir, 'belasting 2025 analyse.xlsx')
    
    print(f"Working directory: {base_dir}")
    print(f"Input:  {pdf_path}")
    print(f"Output: {output_path}\n")
    
    # Check if PDF exists
    if not os.path.exists(pdf_path):
        print(f"[ERROR] PDF file not found: {pdf_path}")
        return False
    
    # Extract transactions
    print("="*80)
    print("EXTRACTING TRANSACTIONS FROM PDF")
    print("="*80)
    transactions = extract_transactions_from_pdf(pdf_path)
    
    if not transactions:
        print("[WARNING] No transactions extracted")
        transactions = []
    
    # Create Excel file
    print("\n" + "="*80)
    print("CREATING EXCEL FILE")
    print("="*80)
    success = create_excel_file(transactions, output_path)
    
    return success

if __name__ == '__main__':
    import sys
    success = main()
    sys.exit(0 if success else 1)
