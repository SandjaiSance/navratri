#!/usr/bin/env python3
"""
Generate Ritten Planning (trip planning) Excel file from bank statement analysis.
Pure Python implementation without Excel COM objects.
"""

import csv
import os
import sys
from datetime import datetime, timedelta
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

def get_dutch_holidays(year):
    """Calculate Dutch holidays for a given year."""
    holidays = {}
    
    # Fixed holidays
    holidays[datetime(year, 1, 1)] = "Nieuwjaarsdag"
    holidays[datetime(year, 12, 25)] = "Eerste kerstdag"
    holidays[datetime(year, 12, 26)] = "Tweede kerstdag"
    holidays[datetime(year, 4, 27)] = "Koningsdag"
    
    # Easter calculation (Computus algorithm)
    a = year % 19
    b = year // 100
    c = year % 100
    d = b // 4
    e = b % 4
    f = (b + 8) // 25
    g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30
    i = c // 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) // 451
    month = (h + l - 7 * m + 114) // 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    
    easter = datetime(year, month, day)
    holidays[easter] = "Eerste Paaschdag"
    holidays[easter + timedelta(days=1)] = "Tweede Paaschdag"
    holidays[easter + timedelta(days=39)] = "Hemelvaartsdag"
    holidays[easter + timedelta(days=49)] = "Eerste Pinksterdag"
    holidays[easter + timedelta(days=50)] = "Tweede Pinksterdag"
    
    return holidays

def parse_date(date_str):
    """Parse date string in dd/mm/yyyy or dd-mm-yyyy format."""
    for fmt in ['%d/%m/%Y', '%d-%m-%Y']:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    return None

def main():
    base_dir = r'C:\GithubCopilotWS\DhR'
    analysis_file = os.path.join(base_dir, 'belasting 2025 analyse.xlsx')
    output_file = os.path.join(base_dir, 'Admin_Ritten_2025.xlsx')
    
    print(f"Loading analysis file: {analysis_file}")
    
    if not os.path.exists(analysis_file):
        print(f"ERROR: File not found: {analysis_file}")
        return False
    
    # Read the analysis Excel file
    from openpyxl import load_workbook
    
    try:
        wb_source = load_workbook(analysis_file)
        ws_source = wb_source['Transacties']
        
        print(f"Found {ws_source.max_row - 1} transactions")
        
        # Extract income transactions
        income_days = {}  # date -> total amount
        
        for row in range(2, ws_source.max_row + 1):
            date_cell = ws_source.cell(row, 1).value
            category = ws_source.cell(row, 8).value
            amount = ws_source.cell(row, 10).value
            
            if not category or category != 'Inkomsten - Rijschool':
                continue
            
            if not amount:
                continue
            
            # Parse date
            date_obj = parse_date(str(date_cell))
            if not date_obj:
                print(f"Warning: Could not parse date {date_cell} at row {row}")
                continue
            
            if date_obj not in income_days:
                income_days[date_obj] = 0
            income_days[date_obj] += float(amount)
        
        print(f"Found {len(income_days)} income days")
        print(f"Total income: EUR {sum(income_days.values()):.2f}")
        
        # Calculate hours (EUR 32.50 per hour)
        hourly_rate = 32.50
        total_hours = sum(income_days.values()) / hourly_rate
        print(f"Total hours: {total_hours:.2f}")
        
        # Generate output workbook
        wb_out = Workbook()
        ws_out = wb_out.active
        ws_out.title = "Rittenplanning"
        
        # Add headers
        headers = ["Datum", "Dag", "Uur", "Kilometers", "Opmerkingen", "Categorie", "Uur", "Uur", "Uur", "Bedrag"]
        for col, header in enumerate(headers, 1):
            cell = ws_out.cell(1, col)
            cell.value = header
            cell.font = Font(bold=True)
            cell.fill = PatternFill(start_color="CCCCCC", end_color="CCCCCC", fill_type="solid")
        
        # Get holidays
        holidays = get_dutch_holidays(2025)
        
        # Allocate hours to working days
        current_date = datetime(2025, 1, 1)
        end_date = datetime(2025, 12, 31)
        row = 2
        hours_remaining = total_hours
        
        # Sort income days for processing
        sorted_income_dates = sorted(income_days.keys())
        
        while current_date <= end_date and hours_remaining > 0.01:
            # Skip Sundays and holidays
            if current_date.weekday() == 6:  # Sunday
                current_date += timedelta(days=1)
                continue
            
            if current_date in holidays:
                current_date += timedelta(days=1)
                continue
            
            # Allocate up to 6 hours for this day
            hours_today = min(6.0, hours_remaining)
            
            ws_out.cell(row, 1).value = current_date.strftime('%d/%m/%Y')
            ws_out.cell(row, 2).value = current_date.strftime('%A')[:3]
            ws_out.cell(row, 3).value = hours_today
            ws_out.cell(row, 3).number_format = '0.00'
            
            # Find if there was an actual income on this date
            for income_date in sorted_income_dates:
                if income_date.date() == current_date.date():
                    ws_out.cell(row, 5).value = f"Income: EUR {income_days[income_date]:.2f}"
                    break
            
            hours_remaining -= hours_today
            current_date += timedelta(days=1)
            row += 1
        
        # Save workbook
        wb_out.save(output_file)
        print(f"\nSUCCESS: Generated {output_file}")
        print(f"Total rows: {row - 2}")
        print(f"Hours allocated: {total_hours - hours_remaining:.2f}")
        
        return True
    
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)
