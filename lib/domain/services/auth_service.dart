import 'package:flutter_themoviedb/domain/clients/account_api_client.dart';
import 'package:flutter_themoviedb/domain/clients/auth_api_client.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _authApiClient = AuthApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final sessionId = await _authApiClient.auth(username: login, password: password);
    final accountId = await _accountApiClient.getAccountId(sessionId);
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }

  Future<void> logout() async {
    await _sessionDataProvider.deleteSessionId();
    await _sessionDataProvider.deleteAccountId();
  }
}