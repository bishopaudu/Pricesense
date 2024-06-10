import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/feedbackscreen.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:pricesense/screens/profilescreen.dart';

class AgentDetails extends ConsumerStatefulWidget {
  const AgentDetails({super.key});

  @override
  ConsumerState<AgentDetails> createState() => _AgentDetailsState();
}

class _AgentDetailsState extends ConsumerState<AgentDetails> {
 // bool value = true;

  @override
  Widget build(BuildContext context) {
    final agentName = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                "${agentName!.firstName} ${agentName.lastName}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(agentName.email,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                    const VerticalDivider(
                      color: Colors.black,
                      width: 30,
                      thickness: 0.2,
                    ),
                    Text(
                      agentName.phone as String,
                      style:
                          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
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
        ],),
                child: Column(
                  children:[
                      GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => const ProfileScreen())),
                  );
                },
                child: _buildInfoRow(
                  Icons.person_2,
                  "Profile",
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Implement logout functionality here
                },
                child: _buildInfoRow(
                  Icons.logout,
                  "Logout",
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => FeedbackScreen())),
                  );
                },
                child: _buildInfoRow(
                  Icons.contact_support,
                  "Send Feedback",
                ),
              ),
                  ]
                ),
              ),
             /* GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => ProfileScreen())),
                  );
                },
                child: _buildInfoRow(
                  Icons.person_2,
                  "Profile",
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Implement logout functionality here
                },
                child: _buildInfoRow(
                  Icons.logout,
                  "Logout",
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => FeedbackScreen())),
                  );
                },
                child: _buildInfoRow(
                  Icons.contact_support,
                  "Send Feedback",
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, [String? trailingText]) {
    return Row(
      children: [
        Icon(icon,
            size: Sizes.iconSize, color: const Color.fromRGBO(76, 194, 201, 1)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        if (trailingText != null) ...[
          const Spacer(),
          Text(
            trailingText,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(76, 194, 201, 1),
            ),
          ),
        ],
      ],
    );
  }
}
