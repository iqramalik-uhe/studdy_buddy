import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF5B6CFF); // Indigo-Blue
  static const Color secondary = Color(0xFFFF8A5B); // Coral
  static const Color accent = Color(0xFF20C997); // Teal-Green
  static const Color background = Color(0xFFF7F7FB);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        background: background,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        color: MaterialStateProperty.all(Colors.white),
        selectedColor: primary.withOpacity(0.12),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        side: const BorderSide(color: Color(0xFFE7E7EF)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static LinearGradient get brandGradient => const LinearGradient(
        colors: [Color(0xFF5B6CFF), Color(0xFF8A5BFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}


