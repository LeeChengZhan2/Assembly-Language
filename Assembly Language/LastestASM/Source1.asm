INCLUDE Irvine32.inc
INCLUDE Macros.inc
MainMenu PROTO C
DisplayMenu PROTO C
WrongChoice PROTO C
DisplayDepositMenu PROTO C
DisplayWithdrawMenu PROTO C
DepositContinue PROTO C
DisplayCurrentBalance PROTO C, value :SDWORD
ChangeLimit PROTO C, value :SDWORD
DisplayBalance PROTO C , value :SDWORD
askForDouble PROTO C
DisplayBalance1 PROTO C, value:SDWORD
Transfer_GetACC PROTO C
Transfer1 PROTO C, value:SDWORD
Transfer2_GetNum PROTO C
Transfer2 PROTO C, value:SDWORD , value:SDWORD


.data
choice DWORD ?


welcomemes BYTE "Welcome to log in module"
idmsg BYTE "Enter your Account Number: ",0
pwmsg BYTE "Enter your Password: ",0

id BYTE	1,2,3,4,5
pw DWORD 000322,985236,215468,254888,365478
pwEncrypted DWORD  5 DUP(?)

key1 DWORD 123456
idInput DWORD ?
pwInput DWORD ?

;
account byte 1,2,3,4,5
balance DWORD 123410, 100050, 200050, 300060, 400070, 500080

indexsigned DWORD ?

depo DWORD ?
choiceA DWORD ?
limitw DWORD 50
var1 DWORD ?
var2 DWORD ?
var3 DWORD ?
char_n	byte	'n',0
char_y	byte	'y',0
char_any byte ?
UserInput BYTE 10 dup(?)
DAWinvalid byte "Error",0
DAWmsg byte "Please enter number 1-5 only",0dh,0ah,0

;Lih Jang's variables

	Display BYTE "TARC Bank Loan Main Page", 0
	Pattern BYTE "========================", 0
	NewLine BYTE 0Dh, 0Ah, 0
	DisplayMainLoan BYTE "1. Search for Your Eligible Loan Amount", 0
	DisplayExit BYTE "2. Exit ", 0
	PromptMain BYTE "Please Choose Your Choice: ", 0
	PromptSalary  BYTE "Please enter your salary (RM): ", 0
	DisplayLoan BYTE "Maximum loan (RM): ", 0
	PromptLoan BYTE "Enter amount you wish to loan (RM): ", 0
	InvalidAmount BYTE "Invalid amount. Please enter again.", 0
	InvalidInput BYTE "Invalid input. Please enter 1, 2 or 3 only.", 0
	DisplayAmount BYTE "Your loan amount (RM): ", 0
	DisplayDuration BYTE "Please Choose Duration: ", 0
	DisplayHalfYear BYTE "1. Half-year - (1)", 0
	DisplayOneYear BYTE "2. One year - (2)", 0
	DisplayTwoYear BYTE "3. Two years - (3)", 0
	PromptDuration BYTE "Enter your Choice (1 - 3): ", 0
	DisplaySummary BYTE "Your Loan Summary: ", 0
	DisplayInterest BYTE "Your Interest (RM): ", 0
	DisplayPay BYTE	"Pay per month (RM): ", 0
	DisplayLast BYTE "Pay for last month (RM): ", 0
	DisplayTotal BYTE "Total need to pay back( RM): ", 0
	LoanInvalid BYTE "Invalid input", 0
	LoanInvalidMsg BYTE "Please enter 1 or 2 only.", 0
	Duration DWORD ?
	Rate DWORD ?
	Interest DWORD	?
	PayMonth DWORD ?
	PayLast DWORD ?
	Salary DWORD ?
	max_loan DWORD ?
	loan_1 DWORD ?
	loan_2 DWORD ?
	decimal BYTE ".", 0
	loan_amt DWORD ?
	newloan_amt DWORD ?
	interest_1 DWORD ?
	interest_2 DWORD ?
	pay_month_1 DWORD ?
	pay_month_2 DWORD ?
	pay_last_1 DWORD ?
	pay_last_2 DWORD ?
	total_1 DWORD ?
	total_2 DWORD ?

;xy variables
;account signed in
index_signed	byte	?
acc_signed		byte	?
blnc			DWORD	?

;transfer variable for transfer single 
acc_trans_index	DWORD ?

;data for multiple transfer
number_of_acc byte	?
acc_to_transfer byte 10 dup(?)
index_of_accs byte 10 dup(?)

;Message to prompt in transfer menu
welcome_msg byte "Welcome to Transfer Module", 0dh, 0ah, 0dh, 0ah, 0
choice_msg byte "Select an option:", 0dh, 0ah,
			    "1. Transfer to single account", 0dh, 0ah,
			    "2. Transfer to multiple account(e-Angpau)", 0dh, 0ah,
				"3. Return to main menu", 0dh, 0ah,
			    "Enter your choice: ", 0

;Message to show when got invalid input
invalid	byte "Invalid",0	    	
error_msg byte "Invalid input.", 0dh, 0ah, 0dh, 0ah, 0

;Message to show when user acc to transfer
transfer1_msg  byte "Enter the account number you want to transfer: ", 0
transfer2_msg  byte "How many account you want to transfer? ", 0
invalidAcc_msg byte "Invalid account number. Type 1 to retry: "

.code
;lOG IN
Login PROC C
mwrite "=================="
call crlf
mwrite "    TARC BANK     "
call crlf
mwrite "=================="
call crlf
call crlf
mov eax, 0
mov esi, 0
mov ecx, lengthof pw
L1:
	mov eax, pw[esi]
	xor eax, key1
	mov pwEncrypted[esi], eax
	add esi, TYPE pw
	LOOP L1	

mov EBX,0

Get_Input:
    add EBX,1                                                 
    .if EBX == 4
	  mwrite "Please wait 5 minutes to continue login"                                     
	  mov EAX,5000;300000                                                                         
	  call delay
	  call CRLF
	  call CRLF
	  mov EBX,0
	  JMP Get_Input
	.else
	  mov EDX, offset idmsg
	  CALL WRITESTRING
	  CALL READDEC
	  mov idINPUT, eax
	.endif

	mov EDX, offset pwmsg
	call WriteString
	CALL READDEC
	mov pwINPUT, eax

mov esi, 0
mov eax, 0
mov ecx, lengthof id
checkID:
		mov al, id[esi]
		cmp eax, idInput
		JE checkPW
		add esi, type id
		LOOP checkID


mwrite "INVALID ACCOUNT NUMBER ! ! !" 
CALL CRLF
CALL CRLF
JMP Get_Input

checkPW:
	mov eax, esi
	mov index_signed, al
	mov esi, type pw
	mul esi
	mov esi, eax
	mov eax, pwInput
	xor eax, key1
	cmp eax, pwEncrypted[esi]
	JE same


mwrite "ACCOUNT NUMBER AND PASSWORD NOT MATCH ! ! !" 
CALL CRLF
CALL CRLF
JMP Get_Input

same:
	mov eax,0
	sub idInput ,1
	mov eax,idInput
	mov ebx,4
	mul ebx
	mov indexsigned, eax
	mov al, index_signed
	inc eax
	mov acc_signed, al
	dec eax
	mov ebx, 4
	mul ebx
	mov ebx, balance[eax]
	mov blnc, ebx

	mwrite "logged in"
	CALL CRLF
	CALL CRLF
	JMP MainMenu1

Login ENDP

MainMenu1 PROC
Invoke MainMenu
mov choice,eax
Astart:
.if choice == 1
jmp DAW
.elseif choice == 2
jmp TM
.elseif choice == 3
jmp L
.elseif choice ==4
mwrite "You have logged out"
call crlf
call crlf
jmp Login
.else
jmp WInput
.endif

WInput:
mwrite "Enter number (1 - 4) only :"
call ReadDec
mov choice,eax
jmp Astart

MainMenu1 ENDP


DAW PROC
Start:
Invoke DisplayMenu
mov choiceA ,eax
WrongInput:
.if choiceA == 1
jmp choice1
.elseif choiceA == 2
mov var3,0
jmp choice2
.elseif choiceA == 3
jmp choice3
.elseif choiceA == 4
jmp choice4
.elseif choiceA == 5
JMP MainMenu1

.else
	mov ebx, OFFSET DAWinvalid
	mov edx, OFFSET DAWmsg
	CALL msgBox	;Prompt user to input 1 - 5 only

.endif

Error:
Invoke WrongChoice
mov choiceA,eax
jmp WrongInput		;back to check choiceA


choice1:
call Savings
call Savingscontinue

JMP ExitP

;Choice 1
Savings:
Invoke DisplayDepositMenu
mov esi,indexsigned
add balance[esi],eax
ret

Savingscontinue:
		mwrite "Continue to Deposit ? (y/n) : "
		mov ecx,2			;Space Needed To Store Input (Default is n - 1. 2 - 1 = 1 character needed) 
		mov edx,offset UserInput
		Call ReadString		;Get Input Yes Or Not 


Invoke str_compare,
		ADDR UserInput,
		ADDR char_y
		JE choice1 ;If Equal y, Go Back to deposit

Invoke str_compare,
		ADDR UserInput,
		ADDR char_n
		JE Start			;If Equal n, go back to main menu
		JNE WrongInput1		;Other Letter Is Error 

 

WrongInput1:  
mwrite "Please enter y or n only "		;Output Error Message
Call crlf
jmp Savingscontinue			;Get Input Again

;Choice 2
choice2:
call Withdraw
call WithdrawContinue

JMP ExitP

Withdraw:
Invoke DisplayWithdrawMenu
mov var1,eax
mov esi,indexsigned
.If eax <= balance[esi]	;check if the amount of w less than or equal currentbalance
JMP check				;If yes jump to check if the amount of w less than or equal limit 
mov eax,var1
.elseif eax > balance[esi]	;If amount of w more than currentbalance
mwrite "You don't have sufficient amount, you only have RM "
Invoke DisplayCurrentBalance, balance[esi]
.endif
ret

check:
mov eax,limitw
mov ebx,100
mul ebx
mov var2,eax
mov eax,var1
mov esi,indexsigned
.If eax <= var2		;If amount of w less than or equal limit
mov eax,var1
sub  balance[esi],eax	;sub from current balance
add var3,eax
ret
mov eax,var1
.elseif eax > var2	;If amount of w more than limit
mwrite "The amount that you want to withdraw exceed the limit of withdrawal : RM "
Invoke DisplayCurrentBalance, var2
ret
.endif
ret

Withdrawcontinue:
		mwrite "Continue to withdrawal ?(y/n) : "
		mov ecx,2			;Space Needed To Store Input (Default is n - 1. 2 - 1 = 1 character needed) 
		mov edx,offset UserInput
		Call ReadString		;Get Input Yes Or Not 


Invoke str_compare,
		ADDR UserInput,
		ADDR char_y
		JE choice2	;If Equal y, Go Back to deposit

Invoke str_compare,
		ADDR UserInput,
		ADDR char_n
		JE Success2			;If Equal n, go back to main menu
		JNE WrongInput2		;Other Letter Is Error 

WrongInput2: 
mwrite "Please enter y or n only "		;Output Error Message
Call crlf
jmp Withdrawcontinue		;Get Input Again

Success2:
mwrite "You have successfully withdraw a total of RM "
Invoke DisplayCurrentBalance, var3
call crlf
jmp Start		;go back to main menu

;Choice 3
choice3:
call limit
call limitcontinue

JMP ExitP

limit:
mov ebx,limitw
Invoke ChangeLimit,limitw
mov esi,eax
ret

limitcontinue:
		mwrite "Are you sure you want to change the limit of withdrawal to RM "
		call WriteDec
		mwrite "? (y/n): "
		mov ecx,2			;Space Needed To Store Input (Default is n - 1. 2 - 1 = 1 character needed) 
		mov edx,offset UserInput
		Call ReadString		;Get Input Yes Or Not 

Invoke str_compare,
		ADDR UserInput,
		ADDR char_y
		mov limitw,esi
		JE Success3	;If Equal y, Go to print success

Invoke str_compare,
		ADDR UserInput,
		ADDR char_n
		mov limitw,ebx
		JE choice3			;If Equal n, go back to set limit
		JNE WrongInput3		;Other Letter Is Error 

Success3:
mwrite "You have successfully changed the limit of withdrawal to RM "
mov eax,limitw
mov ebx,100
mul ebx
Invoke DisplayCurrentBalance, eax
call crlf
jmp Start		;go back to main menu

WrongInput3:  
mwrite "Please enter y or n only "		;Output Error Message
Call crlf
jmp limitcontinue		;Get Input Again


;Choice 4
choice4:
call DisBal
Call DisBalContinue

jmp ExitP

DisBal:
mov esi,indexsigned
Invoke DisplayBalance, balance[esi]
ret

DisBalContinue:
		mwrite "Type anything to return to Main Menu."
		mov ecx,2			;Space Needed To Store Input (Default is n - 1. 2 - 1 = 1 character needed) 
		mov edx,offset UserInput
		Call ReadString		;Get Input Yes Or Not 

Invoke str_compare,
		ADDR UserInput,
		ADDR char_any
		JNE Start		;type to return to main menu


ExitP:
ret

DAW ENDP


;-----------------------------------------------
;Xi Yong
TM PROC C
call crlf
mwrite "====================="
call crlf
mwrite "    Transfer Money	 "
call crlf
mwrite "====================="
call crlf
mov eax, 0
;mov edx, OFFSET welcome_msg
;CALL WriteString

get_choice:
	mov edx, OFFSET choice_msg
	CALL WriteString
	CALL ReadDec
	cmp al, 1
	JE Transfer_Single 
	cmp al, 2
	JE Transfer_Multiple
	cmp al, 3
	JE Exit_P
	mov ebx, OFFSET invalid
	mov edx, OFFSET error_msg
	CALL msgBox
	CALL CRLF
	CALL CRLF
	JMP get_choice

Exit_P:
	INVOKE MainMenu1	

TM ENDP

Transfer_Single PROC
CALL CRLF
get_acc:	
	INVOKE Transfer_GetACC

;Check if acc number entered same with acc signed in
cmp al, acc_signed
JE same_acc

;Check for account validity
mov esi, 0
mov ecx, LengthOF account
check_acc:
	cmp al, account[esi]
	JE Transfer_Money
	add esi, TYPE account
	LOOP check_acc
JMP invalid_acc

; error message if account number entered same with account signed in
same_acc:
	mwrite "Account number entered same with account signed in." 
	CALL CRLF
	mwrite"Type 1 to enter again or other any input to return to main menu." 
	CALL CRLF
	mwrite "Enter: "
	CALL ReadDec
	CALL CRLF
	JMP	retry

; error message for invalid account entered
invalid_acc:
	mwrite "Invalid account." 
	CALL CRLF
	mwrite "Type 1 to enter again or other any input to return to main menu."
	CALL CRLF
	mwrite "Enter: "
	CALL ReadDec

; ask user to retry if error occur
retry:
	CALL CRLF
	.IF al == 1
		JMP get_acc
	.ELSE 
		JMP TM	
	.ENDIF

; if account number entered is valid, then let user to transfer money
Transfer_Money:	
	;show current balance to user
	CALL CRLF
	mov eax, 0
	mov al, index_signed
	INVOKE DisplayBalance, balance[eax]
	;INVOKE DisplayBalance1, blnc
	;get amount to transfer
	mov acc_trans_index, esi
	INVOKE Transfer1, blnc
	push eax
	mov eax,0
	mov al, index_signed
	mov ebx, Type balance
	mul bl
	mov esi, eax
	pop eax
	sub balance[esi], eax
	sub blnc, eax
	push eax
	INVOKE DisplayBalance, balance[esi]
	;INVOKE DisplayBalance1, blnc
	mov eax, 0
	mov eax, acc_trans_index
	mov ecx, type balance 
	mul cl
	mov esi, eax
	pop eax
	add balance[esi], eax
	;mwrite "balance for acc 2"
	;CALL CRLF
	;INVOKE DisplayBalance, balance[esi]
	
CALL CRLF
JMP TM	
Transfer_Single ENDP


;---------------------------------------------------------
; Transfer to many account at one time
Transfer_Multiple PROC
;get number of account to transfer
get_number:
	INVOKE Transfer2_GetNum
	mov ebx, lengthof account
	sub ebx, 1
	cmp al, bl
	JG tooMany

mov number_of_acc, al
mov esi, 0
mov ecx, eax
JMP get_acc

;check if  number of account to transfer excess existing number of accounts
tooMany:
	mwrite "Number of account to transfer excess number of existing number of accounts."
	CALL CRLF 
	mwrite "Type 1 to enter again or other any input to return to main menu."
	CALL CRLF
	mwrite "Enter: "
	CALL ReadDec
	JMP retry

;get acc number to transfer
get_acc:
	push ecx
	CALL CRLF
	mwrite "Account "
	mov eax, esi
	inc eax
	CALL writedec
	CALL CRLF
	;mWrite "Enter the account number you want to transfer: "
	;CALL ReadDec
	;CALL CRLF
	INVOKE Transfer_GetACC
	mov acc_to_transfer[esi], al
	inc esi
	pop ecx
	LOOP get_acc
CALL CRLF

;Check if acc number entered same with acc signed in
mov eax, 0
mov al, number_of_acc
mov ecx, eax
mov esi,0
check_signed_acc:
	mov al, acc_to_transfer[esi]
	cmp al, acc_signed
	JE same_acc
	inc esi
	LOOP check_signed_acc
	
JMP check_valid

;error message if account number entered same with account signed in
same_acc:
	mwrite "Account "
	mov eax, esi
	inc eax
	CALL writedec
	mwrite " is same with account signed in"
	CALL CRLF
	mwrite "Type 1 to enter again or other any input to return to main menu. "
	CALL CRLF
	mwrite "Enter: "
	CALL ReadDec
	CALL CRLF
	JMP retry

;check validity of acc entered
check_valid:
	mov edx, 0
	mov esi, 0
	mov ecx, 0
	mov cl, number_of_acc
	L1:
		push ecx
		mov	eax, 0	
		mov al, acc_to_transfer[esi]
		mov edi, 0
		mov ecx, LengthOf account
		L2:
			cmp al, account[edi]
			JE L3
			inc edi
			LOOP L2
		
		JMP invalid_acc

		L3:
			mov eax, edi
			mov index_of_accs[edx], al
			inc edx
			inc esi
			pop ecx
			LOOP L1

; check if account number entered is duplicated
check_duplicate:
	mov esi, 0
	mov ecx, 0
	mov cl, number_of_acc
	L4:
		push ecx
		mov edi, 0
		mov eax, 0
		mov al, acc_to_transfer[esi]
		mov cl, number_of_acc
		L5:
			.IF esi == edi
			;nothing here 
			.ELSE 
			cmp al, acc_to_transfer[edi]
			JE duplicate_acc
			.ENDIF
			inc edi
			LOOP L5
	
		inc esi
		pop ecx
		LOOP L4

JMP Transfer_Money

; error message for invalid acc
invalid_acc:
	mwrite "Account "
	mov eax, esi
	inc eax
	CALL writedec
	mwrite " is invalid"
	CALL CRLF
	mWrite "Type 1 to enter again or other any input to return to main menu. "
	CALL CRLF
	mwrite "Enter: "
	CALL ReadDec
	JMP retry

; error message for duplicate account
duplicate_acc:
	mwrite "Account "
	mov eax, esi
	inc eax
	CALL writedec
	mwrite " and Account "
	mov eax, edi
	inc eax
	call writedec
	mwrite " is same (duplicate account detected)."
	CALL CRLF
	mWrite "Type 1 to enter again or other any input to return to main menu. "
	CALL CRLF
	mwrite "Enter: "
	CALL ReadDec

; ask user to retry if error occur
retry:
	.IF al == 1
		JMP get_number
	.ELSE 
		JMP TM		
	.ENDIF

; if account number entered is valid and not duplicated, let user to transfer money
Transfer_Money:
	mov al, index_signed
	mov ebx, Type balance
	mul bl
	mov esi, eax
	INVOKE DisplayBalance1, balance[esi]
	;INVOKE DisplayBalance1, blnc
	INVOKE Transfer2, balance[esi], number_of_acc
	push eax
	mov ecx, 0
	mov cl, number_of_acc
	mul ecx
	mov ebx, eax
	mov eax, 0
	mov al, index_signed
	mov ecx, type balance
	mul ecx
	sub balance[eax], ebx
	sub blnc, ebx
	;INVOKE DisplayBalance1, blnc
	INVOKE DisplayBalance1, balance[eax]
	CALL CRLF
	pop eax
	mov ebx, 0 
	mov esi, 0
	mov ecx, 0
	mov ebx, eax
	mov cl, number_of_acc
	add_to_acc:
		push ecx
		mov eax, 0
		mov al, index_of_accs[esi]
		mov ecx, TYPE balance
		mul cl
		add balance[eax], ebx
		;INVOKE DisplayBalance1, balance[eax]
		inc esi
		pop ecx
		LOOP add_to_acc

CALL CRLF
JMP TM
Transfer_Multiple ENDP


;jang's code
L PROC

;Display Loan Main Page
start:
mov eax, 0
call crlf
mov edx, offset[Pattern]
CALL WriteString
call crlf
mov edx, offset[Display]
CALL WriteString
CALL CrLf
mov edx, offset[Pattern]
CALL WriteString
mov edx, offset[NewLine]
CALL WriteString
mov edx, offset[DisplayMainLoan]
CALL WriteString
CALL CrLf
mov edx, offset[DisplayExit]
CALL WriteString
CALL CrLf
mov edx, offset[PromptMain]
CALL WriteString
CALL ReadDec           ;get user input
 

 
.IF eax == 1

	jmp	promptSalaryInput ;get user salary

.ELSEIF	eax == 2

	jmp ExitProgram ;exit program

.ELSE
	
	mov ebx, offset[LoanInvalid]
	mov edx, offset[LoanInvalidMsg]
	CALL msgBox ;if input not 1 or 2
	jmp	start

.ENDIF	

promptSalaryInput:
	mov edx, offset[PromptSalary]
	CALL WriteString
	CALL askForDouble
	mov Salary, eax ;get user salary

	cmp	eax, 250000
	jbe no_loan

	cmp eax, 500000
	jbe loan_25
	ja  loan_50

no_loan:    mov max_loan, 0		;if salary <= 2500
		    mov eax, max_loan
			mov edx, offset[NewLine]
			CALL WriteString
		    mov edx, offset[DisplayLoan]
			CALL WriteString
			CALL WriteDec
			CALL CrLf
			jmp NotEligible


loan_25:   	mov edx, 0			;if salary <= 5000, max loan = 0.25 * salary
			mov ebx, 25
			mul ebx
			mov max_loan, eax
			mov ebx, 10000
			div ebx
			mov loan_1, eax
			mov loan_2, edx
			mov edx, offset[NewLine]
			CALL WriteString
			mov edx, offset[DisplayLoan]
			CALL WriteString
			mov eax, loan_1
			CALL WriteDec
			mov edx, offset[decimal]
			CALL WriteString
			mov eax, loan_2
			CALL WriteDec
			CALL CrLf
			jmp exit_loanloop

loan_50:    mov ebx, 50			;if salary > 5000, max loan = 0.50 * salary
			mul ebx
			mov max_loan, eax
			mov ebx, 10000
			div ebx
			mov loan_1, eax
			mov loan_2, edx
			mov edx, offset[NewLine]
			CALL WriteString
			mov edx, offset[DisplayLoan] ;Display max loan
			CALL WriteString
			mov eax, loan_1
			CALL WriteDec
			mov edx, offset[decimal]
			CALL WriteString
			mov eax, loan_2
			CALL WriteDec
			CALL CrLf 

exit_loanloop: 

prompt_loan: 	
		mov edx, offset[NewLine]
		CALL WriteString
		mov edx, offset[PromptLoan] ;Get user loan amount
		CALL WriteString
		INVOKE askForDouble
		mov ebx, 100
		mul	ebx	


.IF eax  > max_loan
	mov edx,offset[InvalidAmount] ;If amount > loan
	CALL WriteString
	CALL CrLf
	mov edx, offset[NewLine]
	CALL WriteString
	JMP	prompt_loan

.ELSE	
	
	mov edx, offset[NewLine]
	CALL WriteString
	mov	loan_amt, eax ;RM XXXX0000
	mov edx, offset[DisplayAmount] ;Display how many amount users wish to loan
	CALL WriteString
	mov edx, 0
	mov ebx, 10000
	div ebx
	mov loan_1, eax
	mov loan_2, edx
	mov eax, loan_1
	CALL WriteDec
	mov edx, offset[decimal]
	CALL WriteString
	mov eax, loan_2
	CALL WriteDec
	CALL CrLf

.ENDIF	

ForDuration:

	mov edx, offset[NewLine]
	CALL WriteString
    mov edx, offset[DisplayDuration] ;get duration
	CALL WriteString
	CALL CrLf
	mov edx, offset[Pattern]
	CALL WriteString
	mov edx, offset[NewLine]
	CALL WriteString
	mov edx, offset[DisplayHalfYear]
	CALL WriteString
	mov edx, offset[NewLine]
	CALL WriteString
	mov edx, offset[DisplayOneYear]
	call WriteString
	mov edx, offset[NewLine]
	CALL WriteString
	mov edx, offset[DisplayTwoYear]
	CALL WriteString
	mov edx, offset[NewLine]
	CALL WriteString
	mov edx, offset[PromptDuration]
	CALL WriteString
	CALL ReadDec

.IF	eax == 1

	mov Duration, 5
	mov Rate, 10

.ENDIF

.IF eax == 2

	mov Duration, 10
	mov Rate, 15

.ENDIF	

.IF eax == 3

	mov Duration, 20
	mov Rate, 20

.ENDIF	

.IF eax != 1 && eax != 2 && eax != 3 ;Display error if input not 1,2, or 3

	mov edx, offset[InvalidInput]
	CALL WriteString
	CALL CrLf
	JMP	ForDuration

.ENDIF	

;Displat Summary Details
mov edx, offset[NewLine]
CALL WriteString
mov edx, offset[DisplaySummary] 
CALL WriteString
mov edx, offset[NewLine]
CALL WriteString
mov edx, offset[Pattern]
CALL WriteString
mov edx, offset[NewLine]
CALL WriteString
mov eax, loan_amt
mov ebx, 100
mov edx, 0
div ebx
mov newloan_amt, eax ;RM XXXX00
mov ebx, rate
mul ebx
mov Interest, eax; RMXXX0000
mov edx, 0
mov ebx, 10000
div ebx
mov interest_1, eax
mov interest_2, edx
mov edx, offset[DisplayInterest]
CALL WriteString
mov eax, interest_1
CALL WriteDec
mov edx, offset[decimal]
CALL WriteString
mov	eax, interest_2
CALL WriteDec
CALL CrLf


mov eax, Duration ; year * 10
mov ebx, 12
mul ebx	
mov Duration, eax ; duration * 10
mov eax, newloan_amt; RMXXX00
mov ebx, Duration
mov edx, 0
div ebx
mov PayMonth, eax ;pay * 10
mov edx, 0
mov ebx, 10
div ebx
mov pay_month_1, eax
mov pay_month_2, edx
mov edx, offset[DisplayPay]
CALL WriteString
mov eax, pay_month_1
CALL WriteDec
mov edx, offset[decimal]
CALL WriteString
mov eax, pay_month_2
CALL WriteDec
CALL CrLf

mov eax, Interest
mov ebx, 1000
mov edx, 0
div ebx
add eax, PayMonth
mov PayLast, eax
mov edx, 0
mov ebx, 10
div ebx
mov pay_last_1, eax
mov pay_last_2, edx
mov edx, offset[DisplayLast]
CALL WriteString
mov eax, pay_last_1
CALL WriteDec
mov edx, offset[decimal]
CALL WriteString
mov eax, pay_last_2
CALL WriteDec
CALL CrLf

mov eax, loan_amt
add eax, Interest
mov edx, 0
mov ebx, 10000
div ebx
mov total_1, eax
mov total_2, edx
mov edx, offset[DisplayTotal]
CALL WriteString
mov eax, total_1
CALL WriteDec
mov edx, offset[decimal]
CALL WriteString
mov eax, total_2
CALL WriteDec
CALL CrLf
jmp ExitProgram

;For non-eligible user
NotEligible:
		
		mov edx, offset[NewLine]
		CALL WriteString
		mWriteLn "You are not eligible of the loan."
		mov edx, offset[Pattern]
		CALL WriteString

;Comfirmation to exit loan module
ExitProgram:
		mov edx, offset[NewLine]
		CALL WriteString
		mWriteLn "Do you want to exit loan program? (1 for Yes, 2 for No)"
		CALL ReadDec
		mov edx, offset[NewLine]
		CALL WriteString

;Exit loan module
.IF eax == 1

	mWriteLn "Thank you for using this loan system."
	mWriteLn "Goodbye."
	mov edx, offset[Pattern]
	CALL WriteString
	mov edx, offset[NewLine]
	CALL WriteString

;re-run loan module
.ELSEIF	eax == 2

	jmp start

.ELSE

	;error msg
	mov ebx, offset[LoanInvalid]
	mov edx, offset[LoanInvalidMsg]
	CALL msgBox
	jmp ExitProgram

.ENDIF	

INVOKE MainMenu1	
L ENDP

END 