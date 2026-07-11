import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/enums.dart';

class StudybeatColors {
  const StudybeatColors({
    required this.primary,
    required this.primarySoft,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.gradientTop,
    required this.gradientBottom,
    required this.isDark,
  });

  final Color primary;
  final Color primarySoft;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;
  final Color gradientTop;
  final Color gradientBottom;
  final bool isDark;

  static StudybeatColors forTheme(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.oceanBlue:
        return const StudybeatColors(
          primary: Color(0xFF1A6B8A),
          primarySoft: Color(0xFF2E8AAB),
          secondary: Color(0xFF0D3B4C),
          accent: Color(0xFF3ECFB2),
          background: Color(0xFF071820),
          surface: Color(0xFF0E2A36),
          surfaceElevated: Color(0xFF143848),
          textPrimary: Color(0xFFF2F8FB),
          textSecondary: Color(0xFF9BB8C5),
          border: Color(0xFF1F4A5C),
          success: Color(0xFF3ECFB2),
          warning: Color(0xFFE8B84A),
          danger: Color(0xFFE86A6A),
          gradientTop: Color(0xFF0A2430),
          gradientBottom: Color(0xFF051018),
          isDark: true,
        );
      case AppColorTheme.forestGreen:
        return const StudybeatColors(
          primary: Color(0xFF2D6A4F),
          primarySoft: Color(0xFF40916C),
          secondary: Color(0xFF1B4332),
          accent: Color(0xFF95D5B2),
          background: Color(0xFF081410),
          surface: Color(0xFF0F241C),
          surfaceElevated: Color(0xFF163028),
          textPrimary: Color(0xFFF1FAF5),
          textSecondary: Color(0xFF9DBBAE),
          border: Color(0xFF1E3D32),
          success: Color(0xFF52B788),
          warning: Color(0xFFE8B84A),
          danger: Color(0xFFE86A6A),
          gradientTop: Color(0xFF0C1F18),
          gradientBottom: Color(0xFF050E0A),
          isDark: true,
        );
      case AppColorTheme.lavender:
        return const StudybeatColors(
          primary: Color(0xFF7B6B9B),
          primarySoft: Color(0xFF9585B5),
          secondary: Color(0xFF4A3F5C),
          accent: Color(0xFFD4A5C9),
          background: Color(0xFF12101A),
          surface: Color(0xFF1C1828),
          surfaceElevated: Color(0xFF282234),
          textPrimary: Color(0xFFF7F4FA),
          textSecondary: Color(0xFFB0A5C0),
          border: Color(0xFF342E42),
          success: Color(0xFF7BC9A6),
          warning: Color(0xFFE8B84A),
          danger: Color(0xFFE86A6A),
          gradientTop: Color(0xFF181420),
          gradientBottom: Color(0xFF0C0A12),
          isDark: true,
        );
      case AppColorTheme.darkMode:
        return const StudybeatColors(
          primary: Color(0xFF5B8DEF),
          primarySoft: Color(0xFF7BA4F5),
          secondary: Color(0xFF2A3444),
          accent: Color(0xFF6EE7B7),
          background: Color(0xFF0B0D10),
          surface: Color(0xFF151920),
          surfaceElevated: Color(0xFF1E2430),
          textPrimary: Color(0xFFF4F6F8),
          textSecondary: Color(0xFF9AA3B2),
          border: Color(0xFF2A3140),
          success: Color(0xFF6EE7B7),
          warning: Color(0xFFE8B84A),
          danger: Color(0xFFE86A6A),
          gradientTop: Color(0xFF12151A),
          gradientBottom: Color(0xFF08090C),
          isDark: true,
        );
      case AppColorTheme.solarOrange:
        return const StudybeatColors(
          primary: Color(0xFFD97706),
          primarySoft: Color(0xFFF59E0B),
          secondary: Color(0xFF78350F),
          accent: Color(0xFFFBBF24),
          background: Color(0xFF140E08),
          surface: Color(0xFF241810),
          surfaceElevated: Color(0xFF322214),
          textPrimary: Color(0xFFFFF8F0),
          textSecondary: Color(0xFFC4A882),
          border: Color(0xFF3D2A18),
          success: Color(0xFF6EE7B7),
          warning: Color(0xFFFBBF24),
          danger: Color(0xFFE86A6A),
          gradientTop: Color(0xFF1C120A),
          gradientBottom: Color(0xFF0C0804),
          isDark: true,
        );
      case AppColorTheme.midnightPurple:
        return const StudybeatColors(
          primary: Color(0xFF6D28D9),
          primarySoft: Color(0xFF8B5CF6),
          secondary: Color(0xFF3B0764),
          accent: Color(0xFFC4B5FD),
          background: Color(0xFF0C0614),
          surface: Color(0xFF160E22),
          surfaceElevated: Color(0xFF221830),
          textPrimary: Color(0xFFF5F3FF),
          textSecondary: Color(0xFFB0A0C8),
          border: Color(0xFF2E2040),
          success: Color(0xFF6EE7B7),
          warning: Color(0xFFE8B84A),
          danger: Color(0xFFE86A6A),
          gradientTop: Color(0xFF140A1E),
          gradientBottom: Color(0xFF080410),
          isDark: true,
        );
      case AppColorTheme.minimalWhite:
        return const StudybeatColors(
          primary: Color(0xFF1A6B8A),
          primarySoft: Color(0xFF2E8AAB),
          secondary: Color(0xFFE8F1F5),
          accent: Color(0xFF0D9488),
          background: Color(0xFFF7FAFC),
          surface: Color(0xFFFFFFFF),
          surfaceElevated: Color(0xFFF0F5F8),
          textPrimary: Color(0xFF0F2430),
          textSecondary: Color(0xFF5A7380),
          border: Color(0xFFD4E2E9),
          success: Color(0xFF0D9488),
          warning: Color(0xFFD97706),
          danger: Color(0xFFDC2626),
          gradientTop: Color(0xFFEEF5F8),
          gradientBottom: Color(0xFFF7FAFC),
          isDark: false,
        );
    }
  }
}

class AppTheme {
  static ThemeData build(AppColorTheme colorTheme) {
    final colors = StudybeatColors.forTheme(colorTheme);
    final display = GoogleFonts.outfit();
    final body = GoogleFonts.dmSans();

    final base = colors.isDark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: colors.isDark ? Brightness.dark : Brightness.light,
        primary: colors.primary,
        onPrimary: Colors.white,
        secondary: colors.accent,
        onSecondary: colors.isDark ? colors.background : Colors.white,
        error: colors.danger,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: display.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          letterSpacing: -1.2,
        ),
        displayMedium: display.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          letterSpacing: -0.8,
        ),
        headlineLarge: display.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        headlineMedium: display.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        titleLarge: display.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        titleMedium: body.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: body.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: body.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          height: 1.45,
        ),
        labelLarge: body.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: display.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        labelStyle: body.copyWith(color: colors.textSecondary),
        hintStyle: body.copyWith(color: colors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: body.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceElevated,
        selectedColor: colors.primary.withValues(alpha: 0.25),
        labelStyle: body.copyWith(color: colors.textPrimary),
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.accent,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: colors.border,
      extensions: [StudybeatThemeExtension(colors: colors)],
    );
  }
}

@immutable
class StudybeatThemeExtension extends ThemeExtension<StudybeatThemeExtension> {
  const StudybeatThemeExtension({required this.colors});

  final StudybeatColors colors;

  @override
  StudybeatThemeExtension copyWith({StudybeatColors? colors}) {
    return StudybeatThemeExtension(colors: colors ?? this.colors);
  }

  @override
  StudybeatThemeExtension lerp(
    ThemeExtension<StudybeatThemeExtension>? other,
    double t,
  ) {
    if (other is! StudybeatThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}

extension ThemeX on BuildContext {
  StudybeatColors get sbColors =>
      Theme.of(this).extension<StudybeatThemeExtension>()!.colors;
}
