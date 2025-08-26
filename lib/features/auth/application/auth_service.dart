import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/services/app_init.dart';

class AuthService {
  AuthService(this._ref);
  final Ref _ref;

  Future<bool> signInAnonymouslyOrEmail({String? email}) async {
    final isReady = await _ref.read(firebaseReadyProvider.future);
    if (isReady) {
      try {
        if (email == null) {
          await fb.FirebaseAuth.instance.signInAnonymously();
        } else {
          // demo: use anonymous sign-in and store email separately
          await fb.FirebaseAuth.instance.signInAnonymously();
        }
        return true;
      } catch (_) {
        // fallthrough to local
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email ?? 'guest@local');
    return true;
  }

  Future<void> signOut() async {
    final isReady = await _ref.read(firebaseReadyProvider.future);
    if (isReady) {
      try {
        await fb.FirebaseAuth.instance.signOut();
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_email');
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));


