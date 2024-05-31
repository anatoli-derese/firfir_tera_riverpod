

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? image;

  User(
      {
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.role, 
      this.image
    }
    );

  factory User.fromJson(Map<String, dynamic> json) {
    print(json);
    print("ene ga");
    return User(
        id: json['_id'] ,
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        role: json['role'][0],
        image: json['image']
        );
  }
}
