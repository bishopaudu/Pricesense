// ignore_for_file: public_member_api_docs, sort_constructors_first
/*class UserData {
  final String id;
   final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
   final String gender;
  final String city;
final String coordinator;
 
   final String token;

    UserData(
      {required this.id,
      required this.token,
      required this.firstName,
      required this.lastName,
      required this.coordinator,
      required this.city,
      required this.email,
      required this.gender,
      required this.phone,
      required this.username});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      coordinator: json['coordinator'] ?? '' ,
      city: json['city'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      username:json['username'] ?? '',
      token: json['token'] ?? '',
       
    );
  }


}*/

class UserData {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String role;
  final String coordinator;
  final String city;
  final String token;

  UserData({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.role,
    required this.coordinator,
    required this.city,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
      coordinator: json['coordinator'] ?? '',
      city: json['city'] ?? '',
      token: json['token'] ?? '',
    );
  }
}


