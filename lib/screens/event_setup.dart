import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../providers/user_management_provider.dart';

class AddSetupRequestScreen extends StatefulWidget {
  @override
  _AddSetupRequestScreenState createState() => _AddSetupRequestScreenState();
}

class _AddSetupRequestScreenState extends State<AddSetupRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
     final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });


    final String description = _descriptionController.text;

    final url = Uri.parse("${AppConstants.apiBaseUrl}api/event-setup");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'artist': userAuthProvider.authState.id,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Setup Request Created Successfully')),
      );
      _formKey.currentState!.reset();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create Event Setup Request')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        title: const Text(' Event Setup Request'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // TextFormField(
              //   controller: _artistController,
              //   decoration: InputDecoration(labelText: 'Artist ID'),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter the artist ID';
              //     }
              //     return null;
              //   },
              // ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 9,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
