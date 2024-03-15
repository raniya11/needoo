import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/core/services/bottom_nav_service.dart';
import 'package:food_delivery_app/core/services/location_provider.dart';
import 'package:provider/provider.dart';

import 'core/widgets/bottom_navbar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context)=>BottomNavBarProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Needoo',
        theme: ThemeData(
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BottomNavPage(),
      ),
    );
  }
}
