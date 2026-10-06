import PyPDF2
import re
import csv
import os
from datetime import datetime

base_dir = os.path.dirname(os.path.abspath(__file__))
pdf_path = os.path.join(base_dir, 'Knab_Transacties_2025.pdf')
csv_path = os.path.join(base_dir, 'transacties_2025_new.csv')

print("Extracting from PDF...", flush=True)
transactions = []

with open(pdf_path, 'rb') as f:
    reader = PyPDF2.PdfReader(f)
    text = ""
    for page in reader.pages:
        text += page.extract_text() + "\n"

lines = text.split('\n')
i = 0
while i < len(lines):
    m = re.match(r'^(\d{2}-\d{2}-\d{4})', lines[i].strip())
    if m:
        date_str = m.group(1)
        date_obj = datetime.strptime(date_str, '%d-%m-%Y')
        
        trans_text = lines[i][len(date_str):]
        j = i + 1
        while j < min(i+8, len(lines)):
            if re.match(r'^\d{2}-\d{2}-\d{4}', lines[j].strip()):
                break
            trans_text += " " + lines[j].strip()
            j += 1
        
        amounts = re.findall(r'(\d+),(\d{2})', trans_text)
        if amounts:
            amt = float(f"{amounts[-1][0]}.{amounts[-1][1]}")
            
            # Cleanup description first
            desc = re.sub(r'\d{2}-\d{2}-\d{4}', '', trans_text)
            desc = re.sub(r'\d+,\d{2}', '', desc)
            desc = re.sub(r'NL\d+\w+\d+', '', desc)
            desc = re.sub(r'Af\s*', '', desc)
            desc = re.sub(r'[€$¥₹£]', '', desc)  # Remove currency symbols
            desc = ' '.join(desc.split())[:120].strip()
            
            # Determine if it's a debit (afboeking/uit) based on keywords in description
            desc_lower = desc.lower()
            is_debit = False
            
            # Expense keywords
            if any(kw in desc_lower for kw in ['shell', 'bp', 'fuel', 'esso', 'benzine', 'diesel', 'tango',
                                                  'bedrijfsrest', 'ccv', 'costs', 'transport', 'service',
                                                  'rente', 'provisie', 'commission', 'korting', 'discount',
                                                  'retour', 'terugboeking']):
                is_debit = True
            # Income keywords (override if found)
            elif any(kw in desc_lower for kw in ['salaris', 'betaalverzoek', 'rijles', 'les auto', 'income',
                                                    'bonus', 'driving lesson', 'betaling ontvangen', 'incoming']):
                is_debit = False
            # Check for "Af" explicitly (debit indicator)
            elif 'af' in trans_text:
                is_debit = True
            
            if desc:
                transactions.append((date_obj.strftime('%d-%m-%Y'), amt, is_debit, desc))
    i += 1

print(f"Found {len(transactions)} transactions", flush=True)

with open(csv_path, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, delimiter=';')
    w.writerow(['Transactie datum', 'Bedrag bij', 'Bedrag af', 'Omschrijving'])
    for date, amt, is_db, desc in sorted(transactions):
        bedrag_bij = '' if is_db else f'{amt:.2f}'
        bedrag_af = f'{amt:.2f}' if is_db else ''
        w.writerow([date, bedrag_bij, bedrag_af, desc])

print(f"Created {csv_path}", flush=True)
