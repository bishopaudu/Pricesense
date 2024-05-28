class UserData {
  final String id;
  final String token;
  final String firstName;
  final String lastName;
  final String coordinator;

  UserData({
    required this.id,
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.coordinator,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      token: json['token'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      coordinator: json['coordinator'],
    );
  }
}

/*import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  final String token;
  final String firstName;
  final String lastName;
  final String coordinator;

  UserData({
    required this.id,
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.coordinator,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

class UserDataNotifier extends StateNotifier<UserData?> {
  UserDataNotifier() : super(null);

  void setUserData(UserData userData) {
    state = userData;
  }

  void clearUserData() {
    state = null;
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData?>((ref) {
  return UserDataNotifier();
});*/

