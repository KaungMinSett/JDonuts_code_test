import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const authBackground = Color(0xFFFCE9F0);
  static const authStepBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [authBackground, Color(0xFFFFFCFD)],
  );
  static const authControlSurface = Colors.white;
  static const doughnutProgressTrack = Color(0xFF9DE0F5);
  static const onboardingBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    // Keep the artwork area pale before reaching the pink actions area.
    colors: [Color(0xFFFEFAFC), Color(0xFFFEFAFC),
      Color(0xFFF8E5EC)],
    stops: [0, 0.33, 0.5],
  );
  static const welcomeBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    // Welcome's taller artwork moves the pink transition farther down.
    colors: [
      Color(0xFFFEF9FB),
      Color(0xFFFEF9FB),
      Color(0xFFF6E1E7)],
    stops: [0, 0.67, 0.74],
  );
  static const onboardingContentPadding = EdgeInsets.fromLTRB(32, 24, 32, 28);
  static const catalogContentPadding = EdgeInsets.all(16);

  static const _brandCyan = Color(0xFF58CEEB);
  static const _brandPink = Color(0xFFF1589F);
  static const _ink = Color(0xFF232A31);
  static const _buttonHeight = 54.0;
  static const _fieldPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 17,
  );

  static const _fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide.none,
  );

  static final _colorScheme = ColorScheme.fromSeed(
    seedColor: _brandCyan,
    primary: _brandCyan,
    onSurfaceVariant: const Color(0xFF737F8E),
    onPrimary: Colors.white,
    secondary: _brandPink,
    onSurface: _ink,
  );

  static final _fieldErrorBorder = _fieldBorder.copyWith(
    borderSide: BorderSide(color: _colorScheme.error),
  );

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    // Keep Material 3 type sizes and apply the mockup's heavier weights.
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontWeight: FontWeight.w700),
      headlineLarge: TextStyle(fontWeight: FontWeight.w700),
      labelLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.8),
    ),
    filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, _buttonHeight)),
        shape: WidgetStatePropertyAll(StadiumBorder()),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: authControlSurface,
      contentPadding: _fieldPadding,
      border: _fieldBorder,
      // Material animates between these borders as focus or validity changes.
      focusedBorder: _fieldBorder.copyWith(
        borderSide: BorderSide(color: _colorScheme.onSurfaceVariant),
      ),
      errorBorder: _fieldErrorBorder,
      focusedErrorBorder: _fieldErrorBorder,
    ),
  );
}
