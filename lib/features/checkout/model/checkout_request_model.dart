class CheckoutRequestModel {
  const CheckoutRequestModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.apartment,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
    this.paymentMethod = 'cod',
  });
  final String email;
  final String firstName;
  final String lastName;
  final String address;
  final String apartment;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phone;
  final String paymentMethod;

  Map<String, dynamic> toJson() => {
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'address': address,
    'apartment': apartment,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
    'phone': phone,
    'paymentMethod': paymentMethod,
  };
}
