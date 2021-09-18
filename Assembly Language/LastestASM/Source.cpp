#include<iostream>
#include<iomanip>
#include<string>
#include<cstring>
#include<cctype>
using namespace std;

extern "C"
{
	int main();

	int MainMenu();
	void Login();
	int DisplayMenu();
	int WrongChoice();
	int DisplayDepositMenu();
	int DisplayWithdrawMenu();
	int	ChangeLimit(int x);
	char DepositContinue();
	void DisplayCurrentBalance(int x);
	void DisplayBalance(int x);
	//jang's code
	void L();
	int askForDouble();
	//xy's
	//C++ function
	void DisplayBalance1(int a);
	int Transfer_GetACC();
	int Transfer1(int a);
	int Transfer2_GetNum();
	int Transfer2(int a, int number);

	//asm function
	void TM();
	//void Transfer_Single();
	//void Transfer_Multiple();
}

int main()
{
	Login();
	return 0;
}

int MainMenu()
{
	int choice;
	cout << endl;
	cout << "==================" << endl;
	cout << "    Main Menu	   " << endl;
	cout << "==================" << endl;
	cout << "1. Deposit And Withdraw" << endl;
	cout << "2. Transfer Money" << endl;
	cout << "3. Loan" << endl;
	cout << "4. Logout" << endl;
	cout << "Enter your choice: ";
	while (!(cin >> choice))
	{
		cout << "Please enter a number : " << endl;
		cin.clear();
		cin.ignore(123, '\n');
	}
	return choice;

}

int DisplayMenu()
{
	int choice;
	cout << endl;
	cout << "==========================" << endl;
	cout << "   Deposit and Withdraw   " << endl;
	cout << "==========================" << endl;
	cout << "1. Deposit" << endl;
	cout << "2. Withdraw" << endl;
	cout << "3. Set limit of withdraw" << endl;
	cout << "4. Display balance" << endl;
	cout << "5. Main Menu" << endl;
	cout << "Enter your choice : ";
	while (!(cin >> choice))
	{
		cout << "Please enter a number : ";
		//Clear the previous input
		cin.clear();
		//Discard previous input
		cin.ignore(123, '\n');
	}
	return choice;
}

int WrongChoice()
{
	int choiceF;
	cout << endl;
	cout << "Wrong Input. Please enter 1-5 only. " << endl;
	cout << "Enter your choice here : ";
	cin >> choiceF;
	return choiceF;
}

int DisplayDepositMenu()
{
	int deposit;
	double depo;
	cout << endl;
	cout << "Enter amount to deposit : RM ";
	cin >> depo;
	cout << "You have successfully deposit RM " << fixed << setprecision(2) << depo << endl;
	deposit = depo * 100;
	return deposit;
}

int DisplayWithdrawMenu()
{
	int withdraw;
	double with;
	cout << endl;
	cout << "Enter amount to withdraw : RM ";
	cin >> with;
	withdraw = with * 100;
	return withdraw;
}

char DepositContinue()
{
	char choice;
	cout << endl;
	cout << "Do you want to continue ?(y/n) ";
	cin >> choice;
	return choice;
}

int	ChangeLimit(int x)
{
	int limit;
	cout << endl;
	cout << "Your current limit of withdrawal is RM " << x << endl;
	cout << "Please enter the limit of withdrawal that you want to set : RM ";
	cin >> limit;
	return limit;
}


void DisplayCurrentBalance(int x)
{
	double balance;
	balance = x / 100.0;
	cout << fixed << setprecision(2) << balance << endl;
}

void DisplayBalance(int x)
{
	double balance;
	balance = x / 100.0;
	cout << endl;
	cout << "Current Balance : RM " << fixed << setprecision(2) << balance << endl;
}

int askForDouble() {

	bool loop = false;
	double loan_amt;

	while (!(cin >> loan_amt) || loan_amt < 0) {

		cout << "Please enter an proper numeric value.\n";

		// Clear input stream
		cin.clear();

		// Discard previous input
		cin.ignore(123, '\n');
	}

	int newloan_amt = (int)(loan_amt * 100);
	loop = true;
	return newloan_amt;


}

void DisplayBalance1(int a) {
	cout << "Current Balance: RM " << fixed << setprecision(2) << (a / 100.0) << endl;
}

int Transfer_GetACC() {
	char n[100];
	bool valid;

	do {
		valid = true;
		cout << "Enter the account number you want to transfer: ";
		cin >> n;

		for (int i = 0; i < 100; i++) {
			if (n[i] == NULL) {
				break;
			}
			if (isalpha(n[i]) != 0) {
				cout << "Please enter number only.\n";
				valid = false;
				cin.get();
				break;
			}
		}

	} while (valid == false);

	return stoi(n);
}

int Transfer1(int a) {
	double amt;
	double balance = a / 100.00;
	int retry;

	do {
		retry = 0;
		cout << "Enter amount to transfer: RM ";

		if (cin >> amt) {
			if (amt > balance) {
				cout << "Amount to transfer exceed current balance!\n";
				cout << "Type 1 to enter again or other any input to return to main menu. ";
				cin >> retry;
				cout << endl;

				if (retry != 1) {
					TM();
				}
			}
		}
		else {
			cout << "Please enter numerical value only.\n";
			retry = 1;
			cin.clear();
			while (cin.get() != '\n');
		}
	} while (retry == 1);

	cout << "Transaction done.\n";
	return amt * 100;
}


int Transfer2_GetNum() {
	char n[100];
	bool valid;

	do {
		valid = true;
		cout << "\nHow many account to transfer? ";
		cin >> n;

		for (int i = 0; i < 100; i++) {
			if (n[i] == NULL) {
				break;
			}
			if (isalpha(n[i]) != 0) {
				cout << "Please enter number only.\n";
				valid = false;
				cin.get();
				break;
			}
		}

	} while (valid == false);

	return stoi(n);

	//int n;
	//bool valid;
	//do {
	//	valid = true;
	//	cout << "\nHow many account to transfer? ";
	//	//cin >> n;
	//	if (cin >> n) {
	//		break;
	//	}
	//	else {
	//		cout << "Please enter number only.\n";
	//		cin.clear();
	//		while (cin.get() != '\n');
	//		valid = false;
	//	}
	//} while (!valid);
	//return n;
}

int Transfer2(int a, int number) {
	double amt;
	double balance = a / 100.00;
	int retry;

	do {
		retry = 0;
		cout << "Enter amount to transfer to each account: RM ";

		if (cin >> amt) {
			cout << "Transfer RM" << amt << " to " << number << " accounts.\n"
				<< "Total Transfer: RM " << amt * number << endl;
			if (amt*number > balance) {
				cout << "Amount to transfer exceed current balance!\n";
				cout << "Type 1 to enter again or other any input to return to main menu. ";
				cin >> retry;
				cout << endl;

				if (retry != 1) {
					TM();
				}
			}
		}
		else {
			cout << "Please enter numerical value only.\n";
			retry = 1;
			cin.clear();
			while (cin.get() != '\n');
		}
	} while (retry == 1);

	cout << "Transaction done.\n";
	return amt * 100;
}