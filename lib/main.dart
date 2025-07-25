import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/auth/presentation/pages/login_page.dart';
import 'package:hotelbooking/app/features/owner/presentation/pages/hotel_details.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/core/services/shared_pref_service.dart';
import 'app/features/auth/data/datasources/auth_local_data_source.dart';
import 'app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'app/features/auth/data/datasources/database.dart';
import 'app/features/auth/data/repositories/auth_repository_impl.dart';
import 'app/features/auth/presentation/controllers/login_controller.dart';
import 'app/features/auth/presentation/controllers/signup_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        /// Provide AuthRepository for controllers
        Provider<AuthRepositoryImpl>(
          create: (_) => AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(FirebaseAuth.instance),
            AuthLocalDataSourceImpl(SharedPrefServiceHelper()),
            DatabaseMethods(),
          ),
        ),

        ///  Provide Login Controller
        ChangeNotifierProvider(
          create: (context) =>
              LoginController(context.read<AuthRepositoryImpl>()),
        ),

        ///  Provide Signup Controller
        ChangeNotifierProvider(
          create: (context) =>
              SignupController(context.read<AuthRepositoryImpl>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), //
    );
  }
}
