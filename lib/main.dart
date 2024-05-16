import 'package:eventtracking/nav/main_menu.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/auth/login.dart';
import 'package:eventtracking/screens/auth/register.dart';
import 'package:eventtracking/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserAuthProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // onGenerateRoute: (settings) {
      //   final authProvider = Provider.of<UserAuthProvider>(
      //       context,
      //       listen: false);
      //   final isAuthenticated = authProvider.authState.isAuthenticated;
      //   // Check authentication state and decide which route to navigate to
      //   if (settings.name == '/welcome') {
      //     // If user is authenticated, allow access to the protected screen
      //     // Otherwise, redirect to the login screen
      //     return MaterialPageRoute(
      //       builder: (context) =>
      //           isAuthenticated ? const MainPage() : const LoginScreen(),
      //     );
      //   }
      //   // For other routes, navigate as usual
      //   return null;
      // },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => OnbordingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/main': (context) => MainPage(),
      },
    );
  }
}
