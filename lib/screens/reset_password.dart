// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:http/http.dart' as http;

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
  bool isUploading = false;
  bool visible1 = false;
  bool visible2 = false;

  void switchVisible1() {
    setState(() {
      visible1 = !visible1;
    });
  }

  void switchVisible2() {
    setState(() {
      visible2 = !visible2;
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submit() async {
    setState(() {
      isUploading = true;
    });
    final user = ref.watch(userProvider);
    if (previousPasswordController.text == newPasswordController.text) {
      showSnackBar("New password is same as previous password");
      setState(() {
        isUploading = false;
      });
    } else {
      final data = {
        'old_password': previousPasswordController.text,
        'new_password': newPasswordController.text
      };
      final response = await http.post(
        Uri.parse('https://priceintel.vercel.app/user/password/reset'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user!.token}',
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        setState(() {
          isUploading = false;
        });
        print(response.body);
        showSnackBar("Password reset request sent..");
        newPasswordController.clear();
        previousPasswordController.clear();
      } else if (response.statusCode == 500){
        showSnackBar("Incorrect password");
        setState(() {
          isUploading = false;
        });
        print(response.statusCode);
        print(response.body);
      } else {
        showSnackBar("Something went wrong.Please try again");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Reset Password"
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  TextInput(
                    enabled: true,
                    suffixIcon: IconButton(
                        onPressed: switchVisible1,
                        icon: Icon(
                          visible1 ? Icons.visibility : Icons.visibility_off,
                          size: Sizes.iconSize,
                          color: mainColor,
                        )),
                    focusNode: previousFocusNode,
                    text: "Previous Password",
                    obsecureText: !visible1,
                    controller: previousPasswordController,
                    textInputType: TextInputType.text,
                    widget: const Icon(
                      Icons.password,
                      color: mainColor,
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
                    suffixIcon: IconButton(
                        onPressed: switchVisible2,
                        icon: Icon(
                          visible2 ? Icons.visibility : Icons.visibility_off,
                          size: Sizes.iconSize,
                          color: mainColor,
                        )),
                    focusNode: newPasswordFocusNode,
                    text: "New Password",
                    obsecureText:!visible2,
                    controller: newPasswordController,
                    textInputType: TextInputType.text,
                    widget: const Icon(
                      Icons.password,
                      color: mainColor,
                      size: Sizes.iconSize,
                    ),
                    onChanged: (value) {},
                    labelText: "New Password",
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _submit();
              },
              child: isUploading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                        SizedBox(width: 20),
                        Text("Submitting",
                            style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text("Reset Password",
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
