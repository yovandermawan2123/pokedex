import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255), // hijau tema pokemon
                Color.fromARGB(255, 223, 223, 223), // hijau gelap
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Pokeball transparan di belakang
              Positioned(
                right: -40,
                bottom: -40,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 260,
                    color: Colors.black,
                  ),
                ),
              ),

              // Logo + loading
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "POKEDEX",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 25),
                    CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
