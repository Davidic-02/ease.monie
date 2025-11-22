class UserModel {
  final String name;
  final String email;
  final String number;

  UserModel({required this.name, required this.email, required this.number});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    number: json['number'],
  );
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'number': number,
  };
}
