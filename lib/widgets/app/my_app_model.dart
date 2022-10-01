import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';

class MyAppModel {
  final _sessionDataProvider = SessionDataProvider();
  var _isAuth = false;

  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    _isAuth = sessionId != null;
  }

  Future<void> resetSession(BuildContext context) async {
    await _sessionDataProvider.setSessionId(null);
    await _sessionDataProvider.setAccountId(null);
    await Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.auth, (route) => false);
  }
}
