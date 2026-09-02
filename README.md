# Inventory & Profit Calculation System (x86 Assembly - 8086)

A feature-complete, interactive **Inventory & Profit Calculation System** written in **x86 Assembly Language (8086 architecture)** for **CSE341: Microprocessors and Assembly Language**.

---

## 📌 Project Overview
This project provides a robust command-line interface (CLI) inventory management and financial analysis solution designed for 16-bit DOS environments (compatible with TASM, MASM, Emu8086, and DOSBox). It enables business managers to monitor stock levels in real time, manage prices, process dynamic sales and returns, analyze profit/loss margins, and inspect individual item details.

---

## 🚀 Key Features

### 1. Product & Price Management
- **Catalog Visualization**: Displays all registered products with ID, Selling Price, Cost Price, Stock Quantity, and Units Sold in a structured table.
- **Price Modification**: Allows real-time updates to product selling prices, updating data segment memory arrays (`PROD_PRICE`).

### 2. Sales Record Management
- **Transaction Processing**: Records product sales seamlessly via Product ID and desired purchase quantity.
- **Stock Validation**: Verifies available inventory (`PROD_STOCK`) before completing sales to prevent overselling.
- **Automated Billing**: Automatically decrements stock, updates sold units count (`PROD_SOLD`), and generates an instant sales receipt showing unit price and total bill amount.

### 3. Refund & Return Processing
- **Return Handling**: Restocks returned items back into active inventory.
- **Financial Adjustment**: Safely updates unit sales counts and outputs a clear refund receipt displaying total refund amount (`Quantity × Selling Price`).

### 4. Inventory Stock Management
- **Low Stock Alerts**: Automatically scans inventory levels upon menu access and flags items with critical stock levels (< 10 units).
- **Restocking System**: Allows inventory replenishment for any item by Product ID.

### 5. Sales Statistics & Profit Analysis
- **Revenue Aggregation**: Computes total business revenue across all sold products (`∑(Units Sold × Selling Price)`).
- **Cost of Goods Sold (COGS)**: Aggregates total cost of sold inventory (`∑(Units Sold × Cost Price)`).
- **Net Financial Calculation**: Calculates `Net = Revenue - Cost`. Automatically renders **NET PROFIT** or **NET LOSS** (formatted with negative sign `-$X`).

### 6. Product Search & Information Lookup
- **Item Lookup**: Quick lookup of individual product details by Product ID.
- **Item Revenue Breakdown**: Displays selling price, cost price, stock level, total units sold, and item-specific revenue generation.

---

## 🛠 Technical Architecture

### Memory Model & Interrupts
- **Memory Model**: `.MODEL SMALL` with `.STACK 100H`
- **Interrupts**: Uses DOS Interrupt `INT 21H` services:
  - `AH = 01H`: Single Character Input
  - `AH = 02H`: Single Character Output
  - `AH = 09H`: String Display (terminated by `$`)
  - `AH = 4CH`: Program Termination

### Data Structures & Memory Layout
The system manages 5 products using 16-bit Word (`DW`) arrays:
- `PROD_PRICE DW 50, 100, 30, 200, 150` — Unit selling prices
- `PROD_COST  DW 30, 70, 20, 140, 100` — Unit cost prices
- `PROD_STOCK DW 20, 15, 8, 12, 30`    — Current stock levels
- `PROD_SOLD  DW 0, 0, 0, 0, 0`        — Total units sold per product

---

## 💻 How to Run (DOSBox + TASM)

### Prerequisites
1. Installed **[DOSBox](https://www.dosbox.com/)**.
2. **TASM** assembler binaries (`TASM.EXE` and `TLINK.EXE`).

### Execution Commands
```bash
# 1. Mount project directory in DOSBox
mount c C:\path\to\project

# 2. Switch to drive C
c:

# 3. Assemble source file
tasm inventory_system.asm

# 4. Link object file
tlink inventory_system.obj

# 5. Run executable
inventory_system.exe
```

---

## 🎓 Academic Metadata
- **Course**: CSE341 - Microprocessors and Assembly Language
- **Institution**: BRAC University
- **Repository**: [Inventory---Profit-Calculation-System](https://github.com/abrarjahinzihan/Inventory---Profit-Calculation-System.git)
- **Author**: Abrar Jahin Zihan
