import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/feedbackscreen.dart';
import 'package:pricesense/screens/login.dart';
import 'package:pricesense/utils/auth_service.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:pricesense/screens/profilescreen.dart';

class AgentDetails extends ConsumerStatefulWidget {
  const AgentDetails({super.key, this.onLogout});
  final void Function(BuildContext)? onLogout;

  @override
  ConsumerState<AgentDetails> createState() => _AgentDetailsState();
}

class _AgentDetailsState extends ConsumerState<AgentDetails> {
  @override
  Widget build(BuildContext context) {
    final agentName = ref.watch(userProvider);
    final internetStatus = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Agent Details"
              : "No Internet Access",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: internetStatus == ConnectivityResult.mobile ||
                internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/assets/user_avatar.png'),
              ),
              const SizedBox(height: 16),
              Text(
                "${agentName?.firstName} ${agentName?.lastName}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(agentName!.email,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400)),
                  const VerticalDivider(
                    color: Colors.black,
                    width: 30,
                    thickness: 0.2,
                  ),
                  Text(
                    agentName.phone,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                        Icons.person_2, "Profile", const ProfileScreen()),
                    const Divider(height: 15),
                    _buildInfoRow(Icons.contact_support, "Send Feedback",
                        FeedbackScreen()),
                    const Divider(height: 15),
                    _buildLogoutRow(Icons.logout, "Logout"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, size: Sizes.iconSize, color: mainColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutRow(IconData icon, String label) {
    final auth = AuthService();
    return InkWell(
      onTap: () {
        auth.clearUserData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, size: Sizes.iconSize, color: mainColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
