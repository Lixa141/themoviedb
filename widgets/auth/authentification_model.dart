import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/clients/api_client_exception.dart';
import 'package:flutter_themoviedb/domain/services/auth_service.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Server is unavailable. Check internet connection';
        case ApiClientExceptionType.auth:
          return 'Wrong username or password';
        case ApiClientExceptionType.sessionExpired:
        case ApiClientExceptionType.other:
          return 'Something went wrong. Try again later';
      }
    } catch (e) {
      return 'Unknown error, try again';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (login.isEmpty || password.isEmpty) {
      _updateState('Fill login or password', false);
      return;
    }

    _updateState(null, true);

    _errorMessage = await _login(login, password);

    if (_errorMessage == null) {
      MainNavigation.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
