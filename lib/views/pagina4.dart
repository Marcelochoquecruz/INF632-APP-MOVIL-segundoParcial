// lib/views/pagina4.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../widgets/clock_widget.dart';
import '../widgets/custom_card.dart';

class Pagina4 extends StatelessWidget {
  Pagina4({super.key});

  final Random random = Random();
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.yellow,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lime,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Tema')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animaciones de íconos de celulares (más íconos)
          Stack(
            children: List.generate(12, (index) {
              return Positioned(
                left: random.nextDouble() * (screenWidth - 40),
                top: random.nextDouble() * (screenHeight - 40),
                child: Transform.rotate(
                  angle: random.nextDouble() * pi * 2,
                  child: Icon(
                    Icons.phone_android,
                    size: 40,
                    color: colors[index].withOpacity(0.7),
                  ),
                ),
              );
            }),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Widget del Reloj
                  const ClockWidget(),
                  const SizedBox(height: 20),
                  // Tarjeta personalizada con información
                  const CustomCard(),
                  const SizedBox(height: 20),
                  // Tarjeta con botón para cambiar el tema
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Modo Oscuro',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            title: const Text('Activar Modo Oscuro'),
                            value: themeController.isDarkMode,
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                          ),
                        ],
                      ),
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
