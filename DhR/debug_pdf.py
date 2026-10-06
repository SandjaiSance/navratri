#!/usr/bin/env python3
"""Debug PDF structure"""

import PyPDF2

pdf_path = r'C:\GithubCopilotWS\DhR\Knab_Transacties_2025.pdf'

with open(pdf_path, 'rb') as pdf_file:
    pdf_reader = PyPDF2.PdfReader(pdf_file)
    
    for page_num in range(min(3, len(pdf_reader.pages))):
        page = pdf_reader.pages[page_num]
        text = page.extract_text()
        
        print(f"\n{'='*80}")
        print(f"PAGE {page_num + 1}")
        print('='*80)
        print(text[:1500])  # First 1500 chars
        print("\n...")
