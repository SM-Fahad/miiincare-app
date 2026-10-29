import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miiincare/routes/app_routes.dart';

class Miiincare extends StatelessWidget {
  const Miiincare({super.key, this.initialRoute = AppRoutes.splash});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miiincare',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.jostTextTheme(),
        primaryTextTheme: GoogleFonts.jostTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFBFAFD),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7453A6)),
      ),
      initialRoute: initialRoute,
      getPages: AppRoutes.routes,
    );
  }
}
