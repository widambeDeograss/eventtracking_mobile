import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/user_management_provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isLoading = false;
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
      final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
      


    try {
      // Replace with your API call to fetch notifications based on user ID
      var res = await CallApi().authenticatedRequest(
        {},
        "${AppConstants.apiBaseUrl}${AppConstants.notifications}?querytype=single&&userId=${userAuthProvider.authState.id}",
        'get',
      );

      var body = json.decode(res);
      print(body);
      setState(() {
        notifications = body; // Adjust as per your API response structure
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Failed to fetch notifications. Check your internet connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteNotification(dynamic notificationId) async {
    try {
        var res = await CallApi().authenticatedRequest(
        {},
        "${AppConstants.apiBaseUrl}${AppConstants.notifications}?querytype=delete&&notificationId=$notificationId",
        'get',
      );
    
      var body = json.decode(res);
      if (body['save'] == true) {
        Fluttertoast.showToast(
          msg: "Notification deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Remove the deleted notification from the local list
        _fetchNotifications();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to delete notification",
          toastLength: Toast.LENGTH_SHORT,``
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: Unable to delete notification",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? Center(
                  child: Text("No notifications found"),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification['message']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteNotification(notification['id']);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
