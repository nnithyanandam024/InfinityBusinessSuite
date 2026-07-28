class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? gstin;
  final double balance; // Positive balance = Receivable, Negative balance = Payable

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.gstin,
    this.balance = 0.0,
  });
}
