#!/usr/bin/env python3
"""
Convert transacties_2025.csv to belasting 2025 analyse.xlsx in the format
expected by the PowerShell build-rittenplanning.ps1 script.

Required format:
- Column 1: Datum (text in dd/mm/yyyy format)
- Column 2: Omschrijving (description)
- Column 8: Categorie (category - "Inkomsten - Rijschool" or "Kosten - Rijschool")
- Column 10: Bedrag (amount as decimal)
"""

import os
import csv
from datetime import datetime

try:
    from openpyxl import Workbook
    from openpyxl.styles import Font, PatternFill, Alignment
except ImportError:
    print("ERROR: openpyxl not installed")
    exit(1)

def categorize_transaction(description, amount_str, is_bedrag_bij):
    """Categorize transaction based on description and amount type"""
    desc_lower = description.lower()
    
    # Determine if it's income or expense
    if is_bedrag_bij:
        # "Bedrag bij" = credit/income
        if any(kw in desc_lower for kw in ['rijles', 'les auto', 'driving lesson', 'betaalverzoek', 'salaris']):
            return 'Inkomsten - Rijschool'
        elif any(kw in desc_lower for kw in ['shell', 'bp', 'fuel', 'esso', 'benzine', 'diesel']):
            return 'Kosten - Rijschool'
        else:
            return 'Inkomsten - Rijschool'  # Default for incoming
    else:
        # "Bedrag af" = debit/expense
        if any(kw in desc_lower for kw in ['shell', 'bp', 'fuel', 'esso', 'benzine', 'diesel', 'tango', 'bedrijfsrest']):
            return 'Kosten - Rijschool'
        elif any(kw in desc_lower for kw in ['rijles', 'les auto', 'rijschool']):
            return 'Kosten - Rijschool'
        else:
            return 'Kosten - Rijschool'  # Default for outgoing

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    csv_path = os.path.join(base_dir, 'transacties_2025.csv')
    excel_path = os.path.join(base_dir, 'belasting 2025 analyse.xlsx')
    
    print(f"CSV file:   {csv_path}")
    print(f"Excel file: {excel_path}\n")
    
    if not os.path.exists(csv_path):
        print(f"ERROR: CSV file not found: {csv_path}")
        return False
    
    # Read CSV
    print("Reading CSV file...")
    transactions = []
    try:
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter=';')
            for row in reader:
                date_str = row['Transactie datum']  # dd-mm-yyyy format
                bedrag_bij = row['Bedrag bij'].strip()
                bedrag_af = row['Bedrag af'].strip()
                description = row['Omschrijving'].strip()
                
                # Determine amount and type
                if bedrag_bij:
                    amount = float(bedrag_bij.replace(',', '.'))
                    is_bij = True
                else:
                    amount = float(bedrag_af.replace(',', '.'))
                    is_bij = False
                
                # Convert date format: dd-mm-yyyy -> dd/mm/yyyy
                date_obj = datetime.strptime(date_str, '%d-%m-%Y')
                date_formatted = date_obj.strftime('%d/%m/%Y')
                
                category = categorize_transaction(description, bedrag_bij or bedrag_af, is_bij)
                
                transactions.append({
                    'date': date_formatted,
                    'description': description,
                    'category': category,
                    'amount': amount
                })
        
        print(f"Read {len(transactions)} transactions from CSV\n")
    except Exception as e:
        print(f"ERROR reading CSV: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    # Create Excel workbook
    print("Creating Excel workbook...")
    try:
        wb = Workbook()
        ws = wb.active
        ws.title = 'Transacties'
        
        # Create header row
        headers = ['Datum', '', '', '', '', '', '', 'Categorie', '', 'Bedrag']
        for col, header in enumerate(headers, 1):
            if header:
                cell = ws.cell(row=1, column=col, value=header)
                cell.font = Font(bold=True)
                cell.fill = PatternFill(start_color="CCCCCC", end_color="CCCCCC", fill_type="solid")
        
        # Write data rows
        for row_idx, trans in enumerate(transactions, 2):
            ws.cell(row=row_idx, column=1, value=trans['date'])
            ws.cell(row=row_idx, column=2, value=trans['description'])
            ws.cell(row=row_idx, column=8, value=trans['category'])
            
            # Format amount with 2 decimals
            amount_cell = ws.cell(row=row_idx, column=10, value=trans['amount'])
            amount_cell.number_format = '0.00'
        
        # Set column widths
        ws.column_dimensions['A'].width = 12
        ws.column_dimensions['B'].width = 40
        ws.column_dimensions['H'].width = 20
        ws.column_dimensions['J'].width = 12
        
        # Save workbook
        wb.save(excel_path)
        print(f"SUCCESS: Created {excel_path}")
        
        # Summary
        income = sum(t['amount'] for t in transactions if t['category'] == 'Inkomsten - Rijschool')
        expenses = sum(t['amount'] for t in transactions if t['category'] == 'Kosten - Rijschool')
        
        print(f"\nTransactions by category:")
        print(f"  Inkomsten - Rijschool: {len([t for t in transactions if t['category'] == 'Inkomsten - Rijschool']):3} trans. (EUR {income:10.2f})")
        print(f"  Kosten - Rijschool:    {len([t for t in transactions if t['category'] == 'Kosten - Rijschool']):3} trans. (EUR {expenses:10.2f})")
        print(f"  Net: EUR {(income - expenses):10.2f}")
        
        return True
    
    except Exception as e:
        print(f"ERROR creating Excel: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    import sys
    success = main()
    sys.exit(0 if success else 1)
