import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseReadyProvider = FutureProvider<bool>((ref) async {
  try {
    // If firebase_options.dart is not present, this still may succeed on web with defaults
    await Firebase.initializeApp();
    return true;
  } catch (e) {
    // Try again on non-web platforms with default app; otherwise fallback to disabled
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isMacOS)) {
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        return true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }
});


