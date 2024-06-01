import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/user_model.dart';


// Define a provider for user data
final userProvider = StateNotifierProvider<UserNotifier, UserData?>((ref) {
  return UserNotifier();
});

// StateNotifier to manage the user state
class UserNotifier extends StateNotifier<UserData?> {
  UserNotifier() : super(null);

  void setUser(UserData user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}
