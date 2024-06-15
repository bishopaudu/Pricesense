import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final TextEditingController previousPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  FocusNode previousFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void crossCheck() {
    if (previousPasswordController.text == newPasswordController.text) {
      showSnackBar("New Password Is Same As Previous Password");
    }
    showSnackBar("Password Reset Request Sent..");
    newPasswordController.clear();
    previousPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Reset Password"
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
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextInput(
                enabled: true,
                focusNode: previousFocusNode,
                text: "Previous Password",
                obsecureText: false,
                controller: previousPasswordController,
                textInputType: TextInputType.text,
                widget: const Icon(
                  Icons.password,
                  color:mainColor,
                  size: Sizes.iconSize,
                ),
                onChanged: (value) {},
                labelText: "Previous Password",
              ),
              const SizedBox(
                height: 10,
              ),
              TextInput(
                enabled: true,
                focusNode: newPasswordFocusNode,
                text: "New Password",
                obsecureText: false,
                controller: newPasswordController,
                textInputType: TextInputType.text,
                widget: const Icon(
                  Icons.password,
                  color: Color.fromRGBO(76, 194, 201, 1),
                  size: Sizes.iconSize,
                ),
                onChanged: (value) {},
                labelText: "New Password",
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor:mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  crossCheck();
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
