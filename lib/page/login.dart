import 'package:flutter/material.dart';
import 'package:perpus_app/page/beranda.dart';
import 'package:perpus_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perpus_app/user/BerandaPageUser.dart';
import 'package:perpus_app/page/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    final success = await loginProvider.login(email, password);
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    final name = prefs.getString('name') ?? '';

    if (success) {
      if (role == 'customer') {
        // Navigate to BerandaPageUser for customers
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BerandaPageUser(
              role: role,
              name: name,
            ),
          ),
        );
      } else {
        // Navigate to BerandaPage for other roles
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BerandaPage(
              role: role,
              name: name,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginProvider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          Color(0xFFF1F1F1), // Light grey background for the entire page
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'img/logo2.png',
                  width: screenWidth *
                      0.8, // Adjusted width for a proportional size
                  height: screenWidth * 0.8, // Height proportional to width
                  fit: BoxFit
                      .contain, // Ensures the logo retains its aspect ratio
                ),
                const SizedBox(height: 20),

                // App Title
                Text(
                  'Welcome to Happy Soping',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(
                        255, 0, 0, 0), // Blue color for the title
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Please login to continue',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Username Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock,
                        color: Color.fromARGB(255, 4, 4, 5)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Login Button
                loginProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.2, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color.fromRGBO(
                              0, 0, 0, 1), // Blue color for the button
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.045, // Responsive font size
                            color: Colors.white,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                Column(
                  children: [
                    Text(
                      'Login With',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10), // Adds 2px space below the text
                  ],
                ),

                // Social Media Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Login Button
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'img/google.png', // Replace with actual Google logo path
                        width: 24, // Set the size of the Google logo
                        height: 24, // Set the size of the Google logo
                      ),
                      label: const Text('Login Google'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromARGB(
                            255, 255, 255, 255), // Google Red color
                      ),
                    ),
                    const SizedBox(width: 10), // Space between buttons

                    // Facebook Login Button
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'img/facebook.png', // Replace with actual Facebook icon path
                        width: 24, // Set the size of the Facebook logo
                        height: 24, // Set the size of the Facebook logo
                      ),
                      label: const Text('Login Facebook'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromARGB(
                            255, 253, 253, 255), // Facebook Blue color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Footer Text
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterPage()), // Ganti dengan halaman register Anda
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Contact your admin.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
