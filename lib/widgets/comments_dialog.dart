import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CommentDialog extends StatefulWidget {
  final String eventId;

  const CommentDialog({super.key, required this.eventId});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  bool isLoading = false;
  bool isPosting = false;
  TextEditingController commentController = TextEditingController();
  dynamic comments = [];

  _fetchAllEvents() async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.comments}?querytype=single&&eventId=${widget.eventId}",
          'get');
      print(res);
      var body = json.decode(res);
      comments = body;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error: Failing to get event check ypur internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _postController() async {
    if (commentController.text.isEmpty) {
      return;
    }
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    setState(() {
      isPosting = true;
    });
    try {
      var data = {
        "user": userAuthProvider.authState.id,
        "event": widget.eventId,
        "text": commentController.text,
      };
      var res = await CallApi().authenticatedRequest(
          data, "${AppConstants.apiBaseUrl}${AppConstants.comments}", 'post');
      print(res);
      var body = json.decode(res);
      if (body['save']) {
        _fetchAllEvents();
      } else {
        Fluttertoast.showToast(
            msg: "Error: Failing to post comment try again later!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error: Failing to post comment try again later!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isPosting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch comments for the eventId from your backend here
    // For now, we'll just use the sample comments list
    // Replace this with actual fetching logic

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Comments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 1, color: AppColors.primary),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "${AppConstants.mediaBaseUrl}/${comments[index]['user']['profile']}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLargeText(
                                text: comments[index]['user']['username'],
                                size: 16,
                              ),
                              AppSmallText(text: comments[index]['text'])
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                  //   ListTile(
                  //   title: Text(comments[index]['text']),
                  //   // Add more comment details as needed
                  // );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    // Handle adding comment
                  ),
                ),
                SizedBox(width: 10),
                isPosting
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // Handle sending comment
                          _postController();
                        },
                      ),
              ],
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
