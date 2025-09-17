import 'package:flutter/foundation.dart';
import 'auth_store.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  String? get token => _token;

  Future<void> load() async {
    _token = await AuthStore.getToken();
    notifyListeners();
  }

  Future<void> loginWithToken(String token) async {
    _token = token;
    await AuthStore.setToken(token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await AuthStore.clear();
    notifyListeners();
  }
}


