import 'package:flutter/material.dart';
import 'package:pricesense/screens/home_screen.dart';
import 'package:pricesense/utils/sizes.dart';

class AgentDetails extends StatefulWidget {
  const AgentDetails({super.key});

  @override
  State<AgentDetails> createState() => _AgentDetailsState();
}

class _AgentDetailsState extends State<AgentDetails> {
  bool value = true;

// Function to open the feedback dialog
  Future<void> openDialogBox(BuildContext context) async {
    final TextEditingController feedbackController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Feedback',style: TextStyle(color:Color.fromRGBO(76, 194, 201, 1)),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Please enter your feedback below:',style: TextStyle(color:Color.fromRGBO(76, 194, 201, 1)),),
                const SizedBox(height: 10),
                TextField(
                  controller: feedbackController,
                  maxLines: 3,
                    decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Enter your feedback',
                    hintStyle: TextStyle(color:Color.fromRGBO(76, 194, 201, 1))
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',style: TextStyle(color:Color.fromRGBO(76, 194, 201, 1)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit',style: TextStyle(color:Color.fromRGBO(76, 194, 201, 1)),),
              onPressed: () {
                print('Feedback: ${feedbackController.text}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
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
              const Text(
                "Julia Mark",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              const IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("julia2009@gmail.com",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                    VerticalDivider(
                      color: Colors.black,
                      width: 30,
                      thickness: 0.2,
                    ),
                    Text(
                      "0906772883",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                icon: Icons.person_2,
                title: "Profile",
                children: [
                  _buildInfoRow(Icons.language, "Language", "ENGLISH"),
                ],
              ),
              const SizedBox(height: 10),
              _buildInfoCard(
                icon: Icons.contact_support,
                title: "Feedback",
                children: [
                  GestureDetector(
                    onTap:(){openDialogBox(context);},
                      child: _buildInfoRow(Icons.live_help, "Send Feedback")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color.fromRGBO(76, 194, 201, 1),
                size: Sizes.iconSize,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, [String? trailingText]) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromRGBO(76, 194, 201, 1)),
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
