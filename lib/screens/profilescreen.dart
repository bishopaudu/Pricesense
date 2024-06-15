import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/reset_password.dart';
import 'package:pricesense/utils/colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final internetStatus = ref.watch(connectivityProvider);

    if (user == null) {
      return Scaffold(
        body: const Center(
          child: Text('No user data available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
          title: Text(
            internetStatus == ConnectivityResult.mobile ||
                    internetStatus == ConnectivityResult.wifi
                ? "Profile"
                : "No Internet Access",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? mainColor
              : Colors.red.shade400,
          centerTitle: true,
          
        ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/user_avatar.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildProfileItem('Coordinator', user.coordinator),
                      _buildProfileItem('User ID', user.username),
                      _buildProfileItem('User Email', user.email),
                      _buildProfileItem('City', user.city),
                      _buildProfileItem('Phone', user.phone),
                      _buildProfileItem('Gender', user.gender),
                      _buildProfileItem('Role', user.role),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor:mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => ResetPassword())),
                );
              },
              child: const Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            //overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:mainColor,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
