import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final loginTextController = TextEditingController(); //admin
  final passwordTextController = TextEditingController(); //qwerty123
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  final _sessionDataProvider = SessionDataProvider();

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Fill login or password';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    int? accountId;
    try {
      sessionId = await _apiClient.auth(username: login, password: password);
      accountId = await _apiClient.getAccountId(sessionId);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          _errorMessage = 'Server is unavailable. Check internet connection';
          break;
        case ApiClientExceptionType.auth:
          _errorMessage = 'Wrong username or password';
          break;
        case ApiClientExceptionType.other:
          _errorMessage = 'Something went wrong. Try again later';
          break;
      }
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null || accountId == null) {
      _errorMessage = 'Unknown error, try again';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
    unawaited(Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen));
  }
}
