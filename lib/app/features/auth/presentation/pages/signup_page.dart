import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/owner/presentation/pages/hotel_details.dart';
import 'package:provider/provider.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';
import 'package:hotelbooking/app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:hotelbooking/app/features/auth/presentation/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signupController = Provider.of<SignupController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'images/signup.png',
                  height: 250,
                  width: 250,
                ),
              ),
              const SizedBox(height: 15.0),
              Center(
                child: Text('Sign Up', style: AppWidget.headelinetextstyle(28)),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Text(
                  'Please enter the details to continue.',
                  style: AppWidget.normaltextstyle(18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30.0),

              // Name
              buildTextField("Name", Icons.person, nameController),
              const SizedBox(height: 20.0),

              // Email
              buildTextField("Email", Icons.mail, emailController),
              const SizedBox(height: 20.0),

              // Password
              buildTextField(
                "Password",
                Icons.lock,
                passwordController,
                obscure: true,
              ),
              const SizedBox(height: 35.0),

              // Sign Up Button
              GestureDetector(
                onTap: () async {
                  String? result = await signupController.registerUser(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Registered Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HotelDetailsByOwnerPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: signupController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildButton("Sign Up"),
              ),
              const SizedBox(height: 10.0),

              // Login Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppWidget.normaltextstyle(18.0),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: AppWidget.headelinetextstyle(20.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF0766B3)),
              border: InputBorder.none,
              hintText: 'Enter $label',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton(String text) {
    return Center(
      child: Container(
        height: 55.0,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF0766B3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
