import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.login(email, password);
      if (result['status'] == 200) {
        return true;
      } else {
        _error = result['body']['message'] ?? 'Login failed';
        return false;
      }
    } catch (e) {
      _error = 'An error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String firstName, String lastName, String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final result = await AuthService.signup(firstName, lastName, email, password);

    if (result['status'] == 201) {
      return true;
    } else {
      _error = result['body']['message'] ?? 'Signup failed';
      return false;
    }
  } catch (e) {
    _error = 'An error occurred';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}

