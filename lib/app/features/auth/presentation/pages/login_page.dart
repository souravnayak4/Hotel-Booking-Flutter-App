import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/app/core/services/network_service.dart';
import 'package:hotelbooking/app/core/services/shared_pref_service.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/database.dart';
import 'package:hotelbooking/app/features/auth/presentation/pages/signup_page.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/main_navigation_page.dart';
import 'package:random_string/random_string.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "", password = "";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  userLogin() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //  Check Internet Before Proceeding
      bool hasInternet = await NetworkServiceHelper.hasInternetConnection();
      if (!hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
        return;
      }

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "LogIn Successfully",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationPage()),
        );
      } on FirebaseAuthException catch (e) {
        String message = "";
        if (e.code == "user-not-found") {
          message = "No User Found For that Email ";
        } else if (e.code == "wrong-password") {
          message = "Wrong Password Provided By the User";
        } else {
          message = "Somting Wrong: ${e.message}";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(message, style: const TextStyle(fontSize: 18.0)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please fill all fields",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            Center(
              child: Image.asset(
                'images/login.png',
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30.0),

            /// Title
            Center(
              child: Text('Log In', style: AppWidget.headelinetextstyle(28)),
            ),
            const SizedBox(height: 8.0),

            /// Subtitle
            Center(
              child: Text(
                'Please enter your details to continue',
                style: AppWidget.normaltextstyle(18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),

            /// Email Label
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'Email',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            /// Email Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail, color: Color(0xFF0766B3)),
                  border: InputBorder.none,
                  hintText: 'Enter email',
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            /// Password Label
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'Password',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            /// Password Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF0766B3)),
                  border: InputBorder.none,
                  hintText: 'Enter password',
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            /// Forgot Password (Right aligned)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF0766B3),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            /// Login Button
            Center(
              child: GestureDetector(
                onTap: () {
                  if (emailController.text != "" &&
                      passwordController.text != "") {
                    setState(() {
                      email = emailController.text;
                      password = passwordController.text;
                    });
                    userLogin();
                  }
                },
                child: Container(
                  height: 55.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0766B3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),

            /// Sign Up Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppWidget.normaltextstyle(18.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF0766B3),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
