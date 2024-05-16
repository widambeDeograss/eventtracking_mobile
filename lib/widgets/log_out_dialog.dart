import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/custom_colors.dart';
import '../providers/user_management_provider.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);

    return AlertDialog(
      backgroundColor: AppColors.primary,
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            userAuthProvider.logoutUser();
            // Perform logout actions here

            Navigator.of(context).pop();
            SystemNavigator.pop(); // Close the dialog
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
