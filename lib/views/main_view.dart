// lib/views/main_view.dart
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
    const Pagina1(), // Convertidor de bases
    const Pagina2(), // Conversor de moneda
    const Pagina3(), // Verificar número primo
    Pagina4(), // Cambiar modo claro/oscuro
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horizontal_circle),
            label: 'Convertir Bases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Conversor Moneda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Número Primo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.light_mode),
            label: 'Tema',
          ),
        ],
      ),
    );
  }
}
