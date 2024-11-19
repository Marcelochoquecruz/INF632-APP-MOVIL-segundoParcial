import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../widgets/clock_widget.dart';
import '../widgets/custom_card.dart';

class Pagina4 extends StatefulWidget {
  Pagina4({super.key});

  @override
  _Pagina4State createState() => _Pagina4State();
}

class _Pagina4State extends State<Pagina4> with TickerProviderStateMixin {
  final Random random = Random();
  late AnimationController _backgroundController;
  late AnimationController _floatingIconsController;
  
  final List<Color> colors = [
    const Color(0xFF6D28D9),
    const Color(0xFF059669),
    const Color(0xFFD97706),
    const Color(0xFFDB2777),
    const Color(0xFF4F46E5),
    const Color(0xFF10B981),
    const Color(0xFFFBBF24),
    const Color(0xFFF472B6),
    const Color(0xFF3B82F6),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
    const Color(0xFF14B8A6),
  ];

  final List<IconData> icons = [
    Icons.phone_android,
    Icons.laptop,
    Icons.tablet_android,
    Icons.watch,
    Icons.headphones,
    Icons.camera,
    Icons.speaker,
    Icons.mouse,
    Icons.keyboard,
    Icons.memory,
    Icons.router,
    Icons.wifi,
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _floatingIconsController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingIconsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Personalización',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo animado
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(
                  animation: _backgroundController.value,
                  isDarkMode: themeController.isDarkMode,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Íconos flotantes animados
          ...List.generate(12, (index) {
            return AnimatedBuilder(
              animation: _floatingIconsController,
              builder: (context, child) {
                final angle = 2 * pi * _floatingIconsController.value + (index * pi / 6);
                final radius = screenWidth * 0.3;
                final dx = cos(angle) * radius;
                final dy = sin(angle) * radius;
                
                return Positioned(
                  left: screenWidth / 2 + dx - 20,
                  top: screenHeight / 2 + dy - 20,
                  child: Transform.rotate(
                    angle: angle,
                    child: Icon(
                      icons[index],
                      size: 40,
                      color: colors[index].withOpacity(0.5),
                    ),
                  ),
                );
              },
            );
          }),

          // Contenido principal
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 100),
                      // Reloj mejorado
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const ClockWidget(),
                      ),
                      const SizedBox(height: 30),
                      // Tarjeta personalizada
                      const CustomCard(),
                      const SizedBox(height: 30),
                      // Control de tema
                      _buildThemeCard(themeController),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Personaliza tu experiencia',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeSwitch(themeController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(ThemeController themeController) {
    return GestureDetector(
      onTap: () => themeController.toggleTheme(),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: themeController.isDarkMode
                ? [Colors.indigo.shade800, Colors.purple.shade800]
                : [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              themeController.isDarkMode ? 'Modo Oscuro' : 'Modo Claro',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Switch(
              value: themeController.isDarkMode,
              onChanged: (value) => themeController.toggleTheme(),
              activeColor: Colors.white,
              activeTrackColor: Colors.purple.shade300,
              inactiveThumbColor: Colors.grey.shade300,
              inactiveTrackColor: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;

  BackgroundPainter({required this.animation, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final baseColor = isDarkMode ? Colors.black : Colors.white;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = baseColor,
    );

    for (var i = 0; i < 5; i++) {
      final offset = i * (pi / 2.5);
      final gradient = LinearGradient(
        colors: isDarkMode
            ? [
                Colors.purple.withOpacity(0.3),
                Colors.blue.withOpacity(0.3),
              ]
            : [
                Colors.blue.withOpacity(0.2),
                Colors.purple.withOpacity(0.2),
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      paint.shader = gradient;

      final path = Path();
      path.moveTo(0, size.height * 0.5);
      
      for (var x = 0.0; x <= size.width; x++) {
        final y = size.height * 0.5 +
            sin(x / 50 + animation * 2 * pi + offset) * 50;
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      animation != oldDelegate.animation ||
      isDarkMode != oldDelegate.isDarkMode;
}