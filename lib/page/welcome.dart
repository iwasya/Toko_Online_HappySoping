import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/page/login.dart';
import 'package:perpus_app/page/register.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Image carousel slider as the background
          CarouselSlider(
            items: [
              Image.asset(
                'slide/image1.jpg',
                fit: BoxFit.cover,
                height: screenHeight,
                width: double.infinity,
              ),
              Image.asset(
                'slide/image2.jpg',
                fit: BoxFit.cover,
                height: screenHeight,
                width: double.infinity,
              ),
              Image.asset(
                'slide/image3.jpg',
                fit: BoxFit.cover,
                height: screenHeight,
                width: double.infinity,
              ),
              Image.asset(
                'slide/image4.jpg',
                fit: BoxFit.cover,
                height: screenHeight,
                width: double.infinity,
              ),
              Image.asset(
                'slide/image5.jpg',
                fit: BoxFit.cover,
                height: screenHeight,
                width: double.infinity,
              )
            ],
            options: CarouselOptions(
              height: screenHeight,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 1.0,
            ),
          ),
          // Logo placed in the top-center of the screen


          // Overlaying login and register buttons at the bottom of the screen
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(height: 20), // Space between logo and buttons
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
