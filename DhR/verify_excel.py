#!/usr/bin/env python3
"""
Alternative ritten planning generator in Python to avoid Excel COM issues.
This script reads belasting YYYY analyse.xlsx and generates the trip planning.
"""

import os
from datetime import datetime, timedelta
from openpyxl import load_workbook, Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    # For now, just verify the Excel file was created successfully
    excel_path = os.path.join(base_dir, 'belasting 2025 analyse.xlsx')
    
    print(f"Checking Excel file: {excel_path}")
    
    if not os.path.exists(excel_path):
        print(f"ERROR: Excel file not found")
        return False
    
    try:
        wb = load_workbook(excel_path)
        ws = wb['Transacties']
        
        print(f"SUCCESS: Found worksheet 'Transacties'")
        print(f"Total rows: {ws.max_row}")
        
        # Count rows by category
        income_count = 0
        expense_count = 0
        income_total = 0.0
        expense_total = 0.0
        
        for row in range(2, ws.max_row + 1):
            category = ws.cell(row, 8).value
            amount = ws.cell(row, 10).value
            
            if category and amount:
                if category == 'Inkomsten - Rijschool':
                    income_count += 1
                    income_total += float(amount)
                elif category == 'Kosten - Rijschool':
                    expense_count += 1
                    expense_total += float(amount)
        
        print(f"\nTransaction Summary:")
        print(f"  Income transactions: {income_count} (EUR {income_total:.2f})")
        print(f"  Expense transactions: {expense_count} (EUR {expense_total:.2f})")
        print(f"  Net: EUR {(income_total - expense_total):.2f}")
        
        print(f"\nNote: Full trip planning generation requires the PowerShell script")
        print(f"Please run: .\build-rittenplanning.ps1")
        
        return True
    
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    import sys
    success = main()
    sys.exit(0 if success else 1)
