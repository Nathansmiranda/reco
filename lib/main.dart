import 'package:flutter/material.dart';
import 'package:reco/colors.dart';
import 'package:reco/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reco',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: lavendar),
        canvasColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Color(0xFF896AC0)),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(fontSize: 20),
          floatingLabelStyle: const TextStyle(color: Colors.black),
          prefixIconColor: Colors.black45,
          suffixIconColor: Colors.black45,
          filled: true,
          fillColor: const Color.fromARGB(255, 225, 225, 225),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
