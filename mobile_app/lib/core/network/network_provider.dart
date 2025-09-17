import 'dart:async';
import 'package:flutter/foundation.dart';
import '../api/stackapp_api_client.dart';

class NetworkProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Timer? _timer;

  void start() {
    _poll();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _poll());
  }

  Future<void> _poll() async {
    final ok = await StackAppApiClient.healthCheck();
    if (ok != _isOnline) {
      _isOnline = ok;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}


