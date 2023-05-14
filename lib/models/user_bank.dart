class UserBank {
  const UserBank({required this.name, required this.accountBalance});
  final String name;
  final String accountBalance;

  static UserBank fromMap(Map map) {
    return UserBank(
      name: map['bank']['name'],
      accountBalance: map['account_number'],
    );
  }
}
