import 'package:flutter/material.dart';
import 'dart:ui';
import 'pagina1.dart';
import 'pagina2.dart';
import 'pagina3.dart';
import 'pagina4.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = [
    const Pagina1(),
    const Pagina2(),
    const Pagina3(),
    Pagina4(),
  ];

  // Gradientes modernos y vibrantes
  final List<List<Color>> _iconGradients = [
    [const Color(0xFF845EF7), const Color(0xFF7950F2)], // Violeta eléctrico
    [const Color(0xFF20C997), const Color(0xFF12B886)], // Verde esmeralda
    [const Color(0xFFFFB302), const Color(0xFFFFA000)], // Dorado premium
    [const Color(0xFFFF6B6B), const Color(0xFFF03E3E)], // Rojo coral
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true, // Permite que el contenido se extienda detrás de la barra
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    _animationController.reset();
                    _animationController.forward();
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: _iconGradients[_currentIndex][0],
                unselectedItemColor: Colors.grey.withOpacity(0.7),
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.withOpacity(0.7),
                ),
                items: List.generate(4, (index) => _buildNavigationBarItem(
                  _getIcon(index, false),
                  _getIcon(index, true),
                  _getLabel(index),
                  index,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index, bool selected) {
    switch (index) {
      case 0:
        return selected ? Icons.swap_horizontal_circle : Icons.swap_horizontal_circle_outlined;
      case 1:
        return selected ? Icons.attach_money : Icons.attach_money_outlined;
      case 2:
        return selected ? Icons.check_circle : Icons.check_circle_outline;
      case 3:
        return selected ? Icons.light_mode : Icons.light_mode_outlined;
      default:
        return Icons.circle;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Bases';
      case 1:
        return 'Moneda';
      case 2:
        return 'Primo';
      case 3:
        return 'Tema';
      default:
        return '';
    }
  }

  BottomNavigationBarItem _buildNavigationBarItem(
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(_currentIndex == index ? 12 : 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _currentIndex == index
              ? LinearGradient(
                  colors: [
                    _iconGradients[index][0].withOpacity(0.2),
                    _iconGradients[index][1].withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: ScaleTransition(
          scale: _currentIndex == index ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: _currentIndex == index
                    ? _iconGradients[index]
                    : [Colors.grey, Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(
              _currentIndex == index ? selectedIcon : unselectedIcon,
              size: _currentIndex == index ? 32 : 28,
            ),
          ),
        ),
      ),
      label: label,
    );
  }
}