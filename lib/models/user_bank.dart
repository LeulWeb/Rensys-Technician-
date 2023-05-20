class UserBank {
  const UserBank({required this.name, required this.accountBalance, required this.id});
  final String name;
  final String accountBalance;
  final String id; 

  static UserBank fromMap(Map map) {
    return UserBank(
      id: map['bank_id'],
      name: map['bank']['name'],
      accountBalance: map['account_number'],
    );
  }
}
