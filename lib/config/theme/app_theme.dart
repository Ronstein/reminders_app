import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true, // Estilo moderno con Material 3
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      primaryColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey.shade50,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // 🔹 Fuente global MontserratAlternates
      fontFamily: "MontserratAlternates",

      // 🔹 AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: "MontserratAlternates",
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),

      // 🔹 Botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade500,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: "MontserratAlternates",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // 🔹 Botón flotante
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.indigo.shade500,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // 🔹 Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.indigo.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: "MontserratAlternates",
          color: Colors.indigo.shade700,
        ),
      ),

      // 🔹 Tarjetas
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.indigo.shade50, // 👈 reemplazo recomendado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // 🔹 Texto
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 14,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
