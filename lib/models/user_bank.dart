class UserBank {
  const UserBank({required this.name, required this.accountBalance, required this.id, required this.bankId});
  final String name;
  final String accountBalance;
  final String id; 
  final String bankId;

  static UserBank fromMap(Map map) {
    return UserBank(
      id: map['id'],
      name: map['bank']['name'],
      bankId: map['bank_id'],
      accountBalance: map['account_number'],
    );
  }
}
