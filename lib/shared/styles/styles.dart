import 'package:flutter/material.dart';

/// This class holds the App Light and Dark Themes.
class AppTheme {
  /// This method return [ThemeData] of Light Theme
  static ThemeData lightTheme() => ThemeData(
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),

        /// [TextTheme] of Light Theme
        /// This Includes:
        textTheme: const TextTheme(
          /// Display Large [TextStyle] of Light Theme
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),

          /// Label Large [TextStyle] of Light Theme
          labelLarge: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),

          /// Label Medium [TextStyle] of Light Theme
          labelMedium: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),

        /// Primary Swatch of Light Theme
        primarySwatch: Colors.indigo,

        /// [Scaffold] Background color of Light Theme
        scaffoldBackgroundColor: Colors.white,

        /// [BottomNavigationBarTheme] of Light Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(

            /// backgroundColor of bottomNavigationBar for Light Theme
            backgroundColor: Colors.white,

            /// selectedIconTheme of bottomNavigationBar for Light Theme
            selectedIconTheme: IconThemeData(
              color: Colors.indigo,
            ),

            /// unSelectedIconTheme of bottomNavigationBar for Light Theme
            unselectedItemColor: Colors.black38),

        /// BottomSheetTheme of Light Theme
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.indigo[50]),

        /// InputDecorationTheme of TextField/TextFormField for Dark Theme
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusColor: Colors.black,
          iconColor: Colors.black,
          labelStyle: TextStyle(color: Colors.black),
        ),
      );

  /// This method return [ThemeData] of Dark Theme
  static ThemeData darkTheme() => ThemeData(
        timePickerTheme: const TimePickerThemeData(
          helpTextStyle: TextStyle(color: Colors.white70),
          dayPeriodTextStyle: TextStyle(color: Colors.white),
          backgroundColor: Colors.black38,
          hourMinuteTextColor: Colors.white,
          hourMinuteColor: Colors.white10,
          dayPeriodColor: Colors.white10,
          entryModeIconColor: Colors.amber,
        ),
        colorScheme: const ColorScheme.dark(
            primary: Colors.amber,
            // onPrimary: Colors.amber,
            secondary: Colors.amber,
            surface: Colors.amber,
            onSurface: Colors.white70),
        dialogBackgroundColor: Colors.black.withOpacity(.7),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),

        /// [TextTheme] of Dark Theme
        /// This Includes:
        textTheme: const TextTheme(
          /// Display Large [TextStyle] of Dark Theme
          displayLarge: TextStyle(
            color: Colors.black87,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),

          /// Label Large [TextStyle] of Dark Theme
          labelLarge: TextStyle(
              color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),

          /// Label Medium [TextStyle] of Dark Theme
          labelMedium: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),

        /// Primary Swatch of Dark Theme
        primarySwatch: Colors.amber,

        /// [Scaffold] Background color of Dark Theme
        scaffoldBackgroundColor: Colors.black,

        /// [BottomNavigationBarTheme] of Dark Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(

            /// backgroundColor of bottomNavigationBar for Dark Theme
            backgroundColor: Colors.black87,

            /// selectedIconTheme of bottomNavigationBar for Dark Theme
            selectedIconTheme: IconThemeData(
              color: Colors.amber,
            ),

            /// unSelectedIconTheme of bottomNavigationBar for Dark Theme
            unselectedItemColor: Colors.white70),

        /// BottomSheetTheme of Dark Theme
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.amber.shade600),

        /// InputDecorationTheme of TextField/TextFormField for Dark Theme
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black12,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black87,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          fillColor: Colors.black,
          focusColor: Colors.black,
          iconColor: Colors.black,
          hintStyle: TextStyle(color: Colors.black87),
          labelStyle: TextStyle(color: Colors.black),
        ),
      );
}
