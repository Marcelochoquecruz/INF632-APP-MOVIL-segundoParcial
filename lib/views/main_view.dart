import 'package:flutter/material.dart';
import 'pagina1.dart';
import 'pagina2.dart';
import 'pagina3.dart';
import 'pagina4.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Pagina1(),
    const Pagina2(),
    const Pagina3(),
    Pagina4(),
  ];

  // Lista de gradientes para cada ícono
  final List<List<Color>> _iconGradients = [
    [const Color(0xFF6D28D9), const Color(0xFF4F46E5)], // Violeta a Azul para Bases
    [const Color(0xFF059669), const Color(0xFF10B981)], // Verde para Moneda
    [const Color(0xFFD97706), const Color(0xFFFBBF24)], // Naranja para Primo
    [const Color(0xFFDB2777), const Color(0xFFF472B6)], // Rosa para Tema
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Sombra más intensa
              blurRadius: 12, // Mayor difuminado
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30), // Bordes más redondeados
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A1A1A) // Fondo más oscuro
                : Colors.white,
            selectedItemColor: _iconGradients[_currentIndex][0], // Color dinámico
            unselectedItemColor: Colors.grey.withOpacity(0.7),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15, // Texto más grande
              height: 1.5, // Mejor espaciado
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              height: 1.5,
            ),
            elevation: 0,
            iconSize: 32, // Iconos más grandes
            selectedIconTheme: const IconThemeData(
              size: 34, // Iconos seleccionados aún más grandes
            ),
            items: [
              _buildNavigationBarItem(
                Icons.swap_horizontal_circle_outlined,
                Icons.swap_horizontal_circle,
                'Convertir\nBases',
                0,
              ),
              _buildNavigationBarItem(
                Icons.attach_money_outlined,
                Icons.attach_money,
                'Conversor\nMoneda',
                1,
              ),
              _buildNavigationBarItem(
                Icons.check_circle_outline,
                Icons.check_circle,
                'Número\nPrimo',
                2,
              ),
              _buildNavigationBarItem(
                Icons.light_mode_outlined,
                Icons.light_mode,
                'Tema',
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(unselectedIcon),
          if (_currentIndex == index)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _iconGradients[index][0].withOpacity(0.1),
                    Colors.transparent,
                  ],
                  radius: 0.7,
                ),
              ),
            ),
        ],
      ),
      activeIcon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: _iconGradients[index],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Icon(
          selectedIcon,
          size: 34, // Tamaño del ícono activo
        ),
      ),
      label: label,
    );
  }
}