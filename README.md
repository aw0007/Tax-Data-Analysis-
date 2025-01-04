# Tax Data Analysis: Regional Trends in Taxation

This repository contains scripts and replication files for the **Tax Data Analysis** project, which explores regional trends in taxation, focusing on direct taxes, indirect taxes, and international trade taxes. The project uses Stata for data processing, econometric analysis, and visualization of results.

---

## Project Overview

The project analyzes tax data to understand the contribution of various tax types (e.g., direct taxes, VAT, property taxes, and international trade taxes) across different regions over time. The analysis is supported by visualizations to provide insights into regional tax trends as a percentage of GDP.

---

## Repository Structure

- **Data Folder**:
  - Contains the raw and processed datasets required for analysis.
  - Key input files:
    - `taxdtaclean.xlsx`: Raw tax data.
    - `coutry_region_iso.dta`: Country-region mapping data.

- **Scripts Folder**:
  - Contains the Stata scripts for data processing, cleaning, and visualization.
  - Key script: `tax_analysis.do`.

- **Results Folder**:
  - Contains output files including:
    - Aggregated datasets.
    - Graphical visualizations of tax trends.

---

## Key Steps in the Analysis

1. **Data Preparation**:
   - Merge tax data (`taxdtaclean.xlsx`) with region-country mapping data (`coutry_region_iso.dta`).
   - Remove duplicate entries and prepare a panel dataset with `id` (country) and `Year`.

2. **Variable Creation**:
   - Generate percentage variables to normalize tax data as a share of GDP, including:
     - `DirectTaxesIncludingSCIncRe_pct`: Direct taxes.
     - `TaxesonIncomeProfitsCapita_pct`: Taxes on income, profits, and capital.
     - `PropertyTaxes_pct`: Property taxes.
     - `IndirectTaxesTotal_pct`: Total indirect taxes.
     - `TaxesonGoodsandServicesVAT_pct`: VAT on goods and services.
     - `TxIntertionalTradeTota_pct`: Total taxes on international trade.
     - `TaxesonIntationalTradeow_pct`: Taxes on international trade (imports).
     - `TxesonInteionalTrdeexpor_pct`: Taxes on international trade (exports).

3. **Visualization**:
   - A custom function `create_graph` generates line plots for each variable by region.
   - Graphs are saved as `.png` files for easy reference.

---

## Key Visualizations

### Generated Graphs:
1. **Direct Taxes by Region**
   - File: `DirectTaxesIncludingSCIncRe_pct.png`
   - Trends in direct taxes as a percentage of GDP.

2. **Taxes on Income, Profits, and Capital by Region**
   - File: `TaxesonIncomeProfitsCapita_pct.png`
   - Comparison of income-related taxes by region.

3. **Property Taxes by Region**
   - File: `PropertyTaxes_pct.png`
   - Trends in property tax contributions.

4. **Indirect Taxes by Region**
   - File: `IndirectTaxesTotal_pct.png`
   - Total indirect taxes across regions.

5. **Taxes on Goods and Services (VAT) by Region**
   - File: `TaxesonGoodsandServicesVAT_pct.png`
   - VAT contributions to GDP by region.

6. **Taxes on International Trade (Total) by Region**
   - File: `TxIntertionalTradeTota_pct.png`
   - Overview of international trade tax contributions.

7. **Taxes on International Trade (Imports) by Region**
   - File: `TaxesonIntationalTradeow_pct.png`
   - Trends in import taxes by region.

8. **Taxes on International Trade (Exports) by Region**
   - File: `TxesonInteionalTrdeexpor_pct.png`
   - Trends in export taxes across regions.

---

## How to Run the Scripts

1. Place the input files (`taxdtaclean.xlsx` and `coutry_region_iso.dta`) in the designated `Data` folder.
2. Open the Stata script `tax_analysis.do`.
3. Run the script to process the data, clean duplicates, generate panel variables, and create visualizations.
4. The graphs will be saved automatically in the `Results` folder.

---

## Requirements

- **Software**: Stata
- **Libraries/Modules Used**: None (Standard Stata commands are used)

---
