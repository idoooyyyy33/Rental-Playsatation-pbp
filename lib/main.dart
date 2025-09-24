import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash_page.dart';
import 'state/rental_state.dart';
import 'state/food_state.dart';
import 'state/ui_state.dart';

void main() {
  runApp(const PSRentalApp());
}

class PSRentalApp extends StatelessWidget {
  const PSRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RentalState()),
        ChangeNotifierProvider(create: (context) => FoodState()),
        ChangeNotifierProvider(create: (context) => UIState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rental PS Keren',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        home: const SplashPage(),
      ),
    );
  }
}
