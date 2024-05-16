import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../constants/app_constants.dart';
import '../model/auth_state.dart';

class UserAuthProvider extends ChangeNotifier {
  late AuthState _authState;

  UserAuthProvider() {
    _authState = const AuthState(
        isAuthenticated: false,
        apiToken: null,
        id: null,
        email: null,
        role: null,
        username: null,
        isArtist: "user");
    _fetchAuthStateFromStorage().then((authState) {
      _authState = authState;
      notifyListeners();
    });
  }

  AuthState get authState => _authState;

  Future<AuthState> _fetchAuthStateFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    if (isAuthenticated) {
      final String? userId = prefs.getString('userId');
      final String? username = prefs.getString('userName');
      final String? email = prefs.getString('email');
      final String? apiToken = prefs.getString('apiToken');
      final String? role = prefs.getString('role');
      final String? isArtist = prefs.getString('isArtist');

      return AuthState(
        isAuthenticated: true,
        apiToken: apiToken,
        id: userId,
        email: email,
        role: role,
        username: username,
        isArtist: role == "2" ? "artist" : "user",
      );
    } else {
      return const AuthState(
          isAuthenticated: false,
          apiToken: null,
          id: null,
          email: null,
          role: null,
          username: null,
          isArtist: "user");
    }
  }

  Future<bool> loginUser(String username, String password) async {
    final body = {"username": username, 'password': password};
    print("=====================");
    try {
      final response = await CallApi().authenticatedRequest(
        body,
        AppConstants.apiUserLogin,
        "post",
      );
      print(response);
      var responseBody = json.decode(response);
      if (responseBody['success']) {
        final String userFName = responseBody['user']['username'];
        final String userId = responseBody['user']['id'];

        final String userEmail = responseBody['user']['email'];

        final String userToken = responseBody['token'];
        var userRole = responseBody['user']['role'];

        // final String userProfile = responseBody['profile'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isAuthenticated', true);
        prefs.setString('userName', userFName);
        prefs.setString('userId', userId);
        prefs.setString('email', userEmail);
        prefs.setString('apiToken', userToken);

        prefs.setString('isArtist', userRole == 2 ? "artist" : "user");
        print(responseBody['user']['role']);
        _authState = AuthState(
          isAuthenticated: true,
          apiToken: userToken,
          id: userId,
          email: userEmail,
          role: userRole,
          username: userFName,
          isArtist: userRole == 2 ? "artist" : "user",
        );

        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to authenticate user');
      }
    } catch (error) {
      print('Error during login: $error');
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _authState = const AuthState(
        isAuthenticated: false,
        apiToken: null,
        id: null,
        email: null,
        role: null,
        username: null,
        isArtist: "user");
    notifyListeners();
  }
}
