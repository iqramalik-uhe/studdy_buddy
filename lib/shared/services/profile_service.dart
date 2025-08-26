import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';

// Stores profiles in a registry keyed by email for multi-user support
// Keys:
// - profiles_registry: JSON map of email -> profile JSON
// - current_email: currently signed-in email
// Legacy key migration:
// - user_profile (single profile JSON) -> migrated into registry on first load

class ProfileService {
  Future<Map<String, dynamic>> _readRegistry(SharedPreferences prefs) async {
    final raw = prefs.getString('profiles_registry');
    if (raw == null) return <String, dynamic>{};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<void> _writeRegistry(SharedPreferences prefs, Map<String, dynamic> registry) async {
    await prefs.setString('profiles_registry', jsonEncode(registry));
  }

  Future<void> _migrateLegacyIfNeeded(SharedPreferences prefs) async {
    final legacy = prefs.getString('user_profile');
    if (legacy == null) return;
    try {
      final legacyJson = jsonDecode(legacy) as Map<String, dynamic>;
      final profile = UserProfile.fromJson(legacyJson);
      final reg = await _readRegistry(prefs);
      reg[profile.email.toLowerCase()] = profile.toJson();
      await _writeRegistry(prefs, reg);
      await prefs.setString('current_email', profile.email.toLowerCase());
      await prefs.remove('user_profile');
    } catch (_) {
      // ignore corrupt legacy data
      await prefs.remove('user_profile');
    }
  }

  Future<UserProfile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyIfNeeded(prefs);
    final current = prefs.getString('current_email');
    if (current == null) return null;
    final reg = await _readRegistry(prefs);
    final entry = reg[current];
    if (entry == null) return null;
    return UserProfile.fromJson((entry as Map).cast<String, Object?>());
  }

  Future<UserProfile?> getByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyIfNeeded(prefs);
    final reg = await _readRegistry(prefs);
    final entry = reg[email.toLowerCase()];
    if (entry == null) return null;
    return UserProfile.fromJson((entry as Map).cast<String, Object?>());
  }

  Future<void> setCurrent(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_email', email.toLowerCase());
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final reg = await _readRegistry(prefs);
    reg[profile.email.toLowerCase()] = profile.toJson();
    await _writeRegistry(prefs, reg);
    await prefs.setString('current_email', profile.email.toLowerCase());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_email');
  }
}

final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService());


