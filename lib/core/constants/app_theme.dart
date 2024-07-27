import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData kTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.poppins().fontFamily,
  scaffoldBackgroundColor: const Color(0xFFF5F9FD),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0C54BE),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: Color(0xFF0C54BE),
    backgroundColor: Color(0xFFF5F9FD),
    surfaceTintColor: Colors.transparent,
  ),
);
