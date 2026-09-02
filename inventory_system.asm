.MODEL SMALL
 
.STACK 100H

; MACRO DEFINITIONS

; Macro to print a string terminated by '$'
PRINT_STR MACRO MSG
    PUSH AX
    PUSH DX
    LEA DX, MSG
    MOV AH, 09H
    INT 21H
    POP DX
    POP AX
ENDM
 
 
; Macro to print a single character
PRINT_CHAR MACRO CH
    PUSH AX
    PUSH DX
    MOV DL, CH
    MOV AH, 02H
    INT 21H
    POP DX
    POP AX
ENDM

.DATA

; declare variables here

    
    PROD_PRICE DW 50, 100, 30, 200, 150      ; Selling Price per unit
    PROD_COST  DW 30, 70, 20, 140, 100        ; Cost Price per unit
    PROD_STOCK DW 20, 15, 8, 12, 30          ; Current Stock Level
    PROD_SOLD  DW 0, 0, 0, 0, 0              ; Total Units Sold

    ; Global Variables
    VAR_TOTAL_REV  DW 0
    VAR_TOTAL_COST DW 0
    LOW_FOUND_FLAG DB 0

    ; Screen Headers & Menus
    HEADER_TXT    DB '====================================================', 0DH, 0AH
                  DB '     INVENTORY & PROFIT CALCULATION SYSTEM   ', 0DH, 0AH
                  DB '====================================================', 0DH, 0AH, '$'

    MENU_TXT      DB 0DH, 0AH, '-------------- MAIN MENU --------------', 0DH, 0AH
                  DB '1. Product & Price Management (View/Update)', 0DH, 0AH
                  DB '2. Sell Product (Record Sale)', 0DH, 0AH
                  DB '3. Refund & Return Processing (Process Return)', 0DH, 0AH
                  DB '4. Inventory Stock Management (Restock/Alerts)', 0DH, 0AH
                  DB '5. Sales Statistics & Profit Analysis', 0DH, 0AH
                  DB '6. Product Search & Information Lookup', 0DH, 0AH
                  DB '7. Exit System', 0DH, 0AH
                  DB 'Enter your choice (1-7): $'

    CATALOG_HDR   DB 0DH, 0AH, '--- PRODUCT CATALOG ---', 0DH, 0AH
                  DB 'ID | Price | Cost | Stock | Units Sold', 0DH, 0AH
                  DB '---------------------------------------------------', 0DH, 0AH, '$'

    ; Table Separator Strings
    SEP_ID        DB '  |  $', 0DH, 0AH
    SEP_PRICE     DB '  |  $', 0DH, 0AH
    SEP_COST      DB '  |  $', 0DH, 0AH
    SEP_STOCK     DB '  |  $', 0DH, 0AH

    ; User Prompts & Alerts
    SUBMENU_PRICE DB 0DH, 0AH, 'Do you want to update a product price? (1=Yes, 0=No): $'
    ID            DB 'Enter Product ID (1-5): $'
    PRICE         DB 'Enter New Selling Price: $'
    QTY           DB 'Enter Quantity: $'
    TXT_UNIT_PRICE DB 'Unit Price:        $'
    TXT_SALE_BILL  DB 'Total Sale Amount: $'
    RESTOCK        DB 0DH, 0AH, 'Do you want to restock a product? (1=Yes, 0=No): $'
    
    
    TXT_UNITS_RETURNED DB 'Units Returned:    $'
    TXT_REFUND_AMT      DB 'Total Refund Amount: $'

    MSG_SUCCESS   DB 0DH, 0AH, '[SUCCESS] Operation completed successfully!', 0DH, 0AH, '$'
    MSG_INVALID   DB 0DH, 0AH, '[ERROR] Invalid Product ID or Input!', 0DH, 0AH, '$'
    MSG_NO_STOCK  DB 0DH, 0AH, '[ERROR] Insufficient Stock available for this sale!', 0DH, 0AH, '$'
    MSG_LOW_ALERT DB 0DH, 0AH, '*** LOW STOCK ALERT (Stock < 10 units) ***', 0DH, 0AH, '$'
    MSG_NO_LOW    DB 'No products currently have low stock.', 0DH, 0AH, '$'

    TXT_PROD_PREFIX DB 'Product ID $'
    TXT_LOW_MSG     DB ' has LOW STOCK: $'
    TXT_UNITS_LEFT  DB ' units left!', 0DH, 0AH, '$'

    STAT_HDR      DB 0DH, 0AH, '--- SALES STATISTICS & PROFIT ANALYSIS ---', 0DH, 0AH, '$'
    TXT_REV       DB 'Total Revenue Generated:  $'
    TXT_COST      DB 'Total Cost of Sold Items: $'
    TXT_PROFIT    DB 'NET PROFIT:               $'
    TXT_LOSS      DB 'NET LOSS:                -$'

    SEARCH_HDR    DB 0DH, 0AH, '--- PRODUCT LOOKUP DETAILS ---', 0DH, 0AH, '$'
    TXT_ID        DB 'Product ID:       $'
    TXT_SELLP     DB 'Selling Price:    $'
    TXT_COSTP     DB 'Cost Price:       $'
    TXT_STK       DB 'Current Stock:    $'
    TXT_SLD       DB 'Units Sold:       $'
    TXT_ITEM_REV  DB 'Product Revenue:  $'

    EXIT_MSG      DB 0DH, 0AH, 'Exiting system... Thank you for using Inventory Manager!', 0DH, 0AH, '$'

.CODE
MAIN PROC

; initialize DS

MOV AX,@DATA
MOV DS,AX

; enter your code here

    ; Display System Banner
    PRINT_STR HEADER_TXT

MAIN_LOOP:
    CALL SHOW_MENU
    CALL READ_NUM       

    CMP AX, 1
    JE MENU_OPT_1
    CMP AX, 2
    JE MENU_OPT_2
    CMP AX, 3
    JE MENU_OPT_3
    CMP AX, 4
    JE MENU_OPT_4
    CMP AX, 5
    JE MENU_OPT_5
    CMP AX, 6
    JE MENU_OPT_6
    CMP AX, 7
    JE EXIT_PROGRAM

    ;invalid menu selection
    PRINT_STR MSG_INVALID
    JMP MAIN_LOOP

MENU_OPT_1:
    CALL FEATURE_PRODUCT_MGMT
    JMP MAIN_LOOP

MENU_OPT_2:
    CALL FEATURE_RECORD_SALE
    JMP MAIN_LOOP

MENU_OPT_3:
    CALL FEATURE_PROCESS_REFUND
    JMP MAIN_LOOP

MENU_OPT_4:
    CALL FEATURE_STOCK_MGMT
    JMP MAIN_LOOP

MENU_OPT_5:
    CALL FEATURE_PROFIT_ANALYSIS
    JMP MAIN_LOOP

MENU_OPT_6:
    CALL FEATURE_PRODUCT_SEARCH
    JMP MAIN_LOOP

EXIT_PROGRAM:
    PRINT_STR EXIT_MSG

;exit to DOS

MOV AX,4C00H
INT 21H

MAIN ENDP


; HELPER PROCEDURES


SHOW_MENU PROC
    PUSH AX
    PRINT_STR MENU_TXT
    POP AX
    RET
SHOW_MENU ENDP

PRINT_NEWLINE PROC
    PUSH AX
    PUSH DX
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H
    POP DX
    POP AX
    RET
PRINT_NEWLINE ENDP 


READ_NUM PROC
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 0          

READ_LOOP:
    MOV AH, 01H
    INT 21H

    CMP AL, 0DH        
    JE READ_DONE

    CMP AL, '0'
    JL READ_LOOP        
    CMP AL, '9'
    JG READ_LOOP       

    SUB AL, '0'
    MOV AH, 0
    MOV CX, AX         

    MOV AX, BX
    MOV DX, 10
    MUL DX             
    ADD AX, CX         
    MOV BX, AX
    JMP READ_LOOP

READ_DONE:
    CALL PRINT_NEWLINE
    MOV AX, BX        

    POP DX
    POP CX
    POP BX
    RET
READ_NUM ENDP 


PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    CMP AX, 0
    JNE CONVERT_START
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP PRINT_NUM_EXIT

CONVERT_START:
    MOV CX, 0          
    MOV BX, 10

DIV_LOOP:
    MOV DX, 0
    DIV BX             
    PUSH DX            
    INC CX
    CMP AX, 0
    JNE DIV_LOOP

PRINT_DIGITS:
    POP DX            
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP PRINT_DIGITS

PRINT_NUM_EXIT:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP


; FEATURE PROCEDURES


; FEATURE 1: PRODUCT & PRICE MANAGEMENT
FEATURE_PRODUCT_MGMT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    PRINT_STR CATALOG_HDR

    MOV CX, 5          
    MOV SI, 0          
    MOV BX, 1          

DISPLAY_CATALOG_LOOP:
    ; Print Product ID
    MOV AX, BX
    CALL PRINT_NUM
    PRINT_STR SEP_ID

    ; Print Price
    MOV AX, PROD_PRICE[SI]
    CALL PRINT_NUM
    PRINT_STR SEP_PRICE

    ; Print Cost
    MOV AX, PROD_COST[SI]
    CALL PRINT_NUM
    PRINT_STR SEP_COST

    ; Print Stock
    MOV AX, PROD_STOCK[SI]
    CALL PRINT_NUM
    PRINT_STR SEP_STOCK

    ; Print Units Sold
    MOV AX, PROD_SOLD[SI]
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    ADD SI, 2          
    INC BX
    LOOP DISPLAY_CATALOG_LOOP

    ; Check for Price Update Submenu
    PRINT_STR SUBMENU_PRICE

    CALL READ_NUM
    CMP AX, 1
    JNE PM_EXIT

    PRINT_STR ID

    CALL READ_NUM
    CMP AX, 1
    JL PM_INVALID
    CMP AX, 5
    JG PM_INVALID

    
    DEC AX
    ADD AX, AX
    MOV SI, AX

    PRINT_STR PRICE

    CALL READ_NUM
    MOV PROD_PRICE[SI], AX

    PRINT_STR MSG_SUCCESS
    JMP PM_EXIT

PM_INVALID:
    PRINT_STR MSG_INVALID

PM_EXIT:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FEATURE_PRODUCT_MGMT ENDP

; FEATURE 2: SALES RECORD MANAGEMENT
FEATURE_RECORD_SALE PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    PRINT_STR ID

    CALL READ_NUM
    CMP AX, 1
    JL SALE_INVALID
    CMP AX, 5
    JG SALE_INVALID

    
    DEC AX
    ADD AX, AX
    MOV SI, AX

    PRINT_STR QTY

    CALL READ_NUM
    MOV CX, AX         

    ; Verify Stock Level
    MOV AX, PROD_STOCK[SI]
    CMP AX, CX
    JL SALE_NO_STOCK

    ; Update Stock & Sales Data
    SUB PROD_STOCK[SI], CX
    ADD PROD_SOLD[SI], CX

    ; Output Receipt
    PRINT_STR TXT_UNIT_PRICE

    MOV AX, PROD_PRICE[SI]
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR TXT_SALE_BILL

    MOV AX, PROD_PRICE[SI]
    MUL CX             ; AX = Price * QTY
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR MSG_SUCCESS
    JMP SALE_EXIT

SALE_NO_STOCK:
    PRINT_STR MSG_NO_STOCK
    JMP SALE_EXIT

SALE_INVALID:
    PRINT_STR MSG_INVALID

SALE_EXIT:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FEATURE_RECORD_SALE ENDP 

; FEATURE 3: REFUND & RETURN PROCESSING 


FEATURE_PROCESS_REFUND PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    PRINT_STR ID

    CALL READ_NUM
    CMP AX, 1
    JL REF_INVALID
    CMP AX, 5
    JG REF_INVALID

    DEC AX
    ADD AX, AX
    MOV SI, AX

    PRINT_STR QTY

    CALL READ_NUM
    MOV CX, AX         

    ; Restock returned items
    ADD PROD_STOCK[SI], CX

    ; Adjust total units sold safely
    MOV AX, PROD_SOLD[SI]
    CMP AX, CX
    JGE REF_SUB_SOLD
    MOV PROD_SOLD[SI], 0
    JMP REF_DISPLAY_RECEIPT

REF_SUB_SOLD:
    SUB PROD_SOLD[SI], CX

REF_DISPLAY_RECEIPT:
    ; Print Units Returned 
    
    
    PRINT_STR TXT_UNITS_RETURNED
    MOV AX, CX
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    ; Print Total Refund Amount (Qty * Selling Price) 
    
    
    PRINT_STR TXT_REFUND_AMT
    MOV AX, PROD_PRICE[SI]
    MUL CX              
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR MSG_SUCCESS
    JMP REF_EXIT

REF_INVALID:
    PRINT_STR MSG_INVALID

REF_EXIT:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FEATURE_PROCESS_REFUND ENDP

; FEATURE 4: INVENTORY STOCK MANAGEMENT
FEATURE_STOCK_MGMT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    PRINT_STR MSG_LOW_ALERT

    MOV LOW_FOUND_FLAG, 0
    MOV CX, 5
    MOV SI, 0
    MOV BX, 1

CHECK_LOW_LOOP:
    MOV AX, PROD_STOCK[SI]
    CMP AX, 10
    JGE SKIP_ALERT

    ; Alert logic for items with stock < 10
    MOV LOW_FOUND_FLAG, 1
    PRINT_STR TXT_PROD_PREFIX

    MOV AX, BX
    CALL PRINT_NUM

    PRINT_STR TXT_LOW_MSG

    MOV AX, PROD_STOCK[SI]
    CALL PRINT_NUM

    PRINT_STR TXT_UNITS_LEFT

    CALL PRINT_NEWLINE

SKIP_ALERT:
    ADD SI, 2
    INC BX
    LOOP CHECK_LOW_LOOP

    CMP LOW_FOUND_FLAG, 0
    JNE DO_RESTOCK
    PRINT_STR MSG_NO_LOW

DO_RESTOCK:
    PRINT_STR RESTOCK

    CALL READ_NUM
    CMP AX, 1
    JNE STK_EXIT

    PRINT_STR ID

    CALL READ_NUM
    CMP AX, 1
    JL STK_INVALID
    CMP AX, 5
    JG STK_INVALID

    DEC AX
    ADD AX, AX
    MOV SI, AX

    PRINT_STR QTY

    CALL READ_NUM
    ADD PROD_STOCK[SI], AX

    PRINT_STR MSG_SUCCESS
    JMP STK_EXIT

STK_INVALID:
    PRINT_STR MSG_INVALID

STK_EXIT:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FEATURE_STOCK_MGMT ENDP

; FEATURE 5: SALES STATISTICS & PROFIT ANALYSIS
FEATURE_PROFIT_ANALYSIS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    PRINT_STR STAT_HDR

    MOV VAR_TOTAL_REV, 0
    MOV VAR_TOTAL_COST, 0

    MOV CX, 5
    MOV SI, 0

CALC_LOOP:
    ; Revenue = PROD_SOLD * PROD_PRICE
    MOV AX, PROD_SOLD[SI]
    MOV BX, PROD_PRICE[SI]
    MUL BX              
    ADD VAR_TOTAL_REV, AX

    ; Cost = PROD_SOLD * PROD_COST
    MOV AX, PROD_SOLD[SI]
    MOV BX, PROD_COST[SI]
    MUL BX              
    ADD VAR_TOTAL_COST, AX

    ADD SI, 2
    LOOP CALC_LOOP

    ; Print Revenue
    PRINT_STR TXT_REV
    MOV AX, VAR_TOTAL_REV
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    ; Print Cost
    PRINT_STR TXT_COST
    MOV AX, VAR_TOTAL_COST
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    ; Calculate Net Difference
    MOV AX, VAR_TOTAL_REV
    SUB AX, VAR_TOTAL_COST
    CMP AX, 0
    JL PRINT_NET_LOSS

    ; Net Profit
    PRINT_STR TXT_PROFIT
    CALL PRINT_NUM
    CALL PRINT_NEWLINE
    JMP PROFIT_EXIT

PRINT_NET_LOSS:
   
    NEG AX
    PRINT_STR TXT_LOSS
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

PROFIT_EXIT:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FEATURE_PROFIT_ANALYSIS ENDP

; FEATURE 6: PRODUCT SEARCH & INFORMATION LOOKUP
FEATURE_PRODUCT_SEARCH PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    PRINT_STR ID

    CALL READ_NUM
    CMP AX, 1
    JL SRCH_INVALID
    CMP AX, 5
    JG SRCH_INVALID

    MOV BX, AX         

    DEC AX
    ADD AX, AX
    MOV SI, AX

    PRINT_STR SEARCH_HDR

    ; Print Product Details
    PRINT_STR TXT_ID
    MOV AX, BX
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR TXT_SELLP
    MOV AX, PROD_PRICE[SI]
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR TXT_COSTP
    MOV AX, PROD_COST[SI]
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR TXT_STK
    MOV AX, PROD_STOCK[SI]
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR TXT_SLD
    MOV AX, PROD_SOLD[SI]
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    PRINT_STR TXT_ITEM_REV
    MOV AX, PROD_SOLD[SI]
    MOV CX, PROD_PRICE[SI]
    MUL CX
    CALL PRINT_NUM
    CALL PRINT_NEWLINE

    JMP SRCH_EXIT

SRCH_INVALID:
    PRINT_STR MSG_INVALID

SRCH_EXIT:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FEATURE_PRODUCT_SEARCH ENDP

    END MAIN


