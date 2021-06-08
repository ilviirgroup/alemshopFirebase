import 'package:alemshop/models/cart.dart';
import 'package:alemshop/models/category_provider.dart';
import 'package:alemshop/models/color_provider.dart';
import 'package:alemshop/models/filter.dart';
import 'package:alemshop/models/size_provider.dart';
import 'package:alemshop/screens/home_screen.dart';
import 'package:alemshop/screens/welcome.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AlemShop());
}

class AlemShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();
// Disable persistence on web platforms

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Categories(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Filters(),
        ),
        ChangeNotifierProvider.value(
          value: FetchSize(),
        ),
        ChangeNotifierProvider.value(
          value: FetchColor(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alemshop',
        color: Colors.black,
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          'welcome': (context) => HomeScreen()
        },
      ),
    );
  }
}
