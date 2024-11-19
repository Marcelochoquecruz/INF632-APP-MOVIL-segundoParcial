import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});

  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  String _selectedInputBase = 'Decimal';
  String _selectedOutputBase = 'Binario';
  String _resultConversion = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<String> _bases = ['Decimal', 'Binario', 'Octal', 'Hexadecimal'];
  final Map<String, Color> _baseColors = {
    'Decimal': Colors.blue,
    'Binario': Colors.green,
    'Octal': Colors.orange,
    'Hexadecimal': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  String _convertNumber(String input, String inputBase, String outputBase) {
    try {
      if (input.isEmpty) return '';
      int decimalValue;
      switch (inputBase) {
        case 'Decimal':
          decimalValue = int.parse(input);
          break;
        case 'Binario':
          decimalValue = int.parse(input, radix: 2);
          break;
        case 'Octal':
          decimalValue = int.parse(input, radix: 8);
          break;
        case 'Hexadecimal':
          decimalValue = int.parse(input, radix: 16);
          break;
        default:
          throw const FormatException('Base no soportada');
      }

      switch (outputBase) {
        case 'Decimal':
          return decimalValue.toString();
        case 'Binario':
          return decimalValue.toRadixString(2).padLeft(8, '0');
        case 'Octal':
          return decimalValue.toRadixString(8);
        case 'Hexadecimal':
          return decimalValue.toRadixString(16).toUpperCase();
        default:
          throw const FormatException('Base no soportada');
      }
    } catch (e) {
      return 'Error en la conversión';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[900]!,
              Colors.blue[700]!,
              Colors.blue[500]!,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildMainContent(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Convertidor Universal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.transform_rounded,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildGlassCard(
                  child: _buildInputSection(),
                ),
                const SizedBox(height: 20),
                _buildGlassCard(
                  child: _buildBaseSelectionSection(),
                ),
                const SizedBox(height: 20),
                _buildConvertButton(),
                const SizedBox(height: 20),
                _buildResultSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Número a convertir',
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(FontAwesomeIcons.keyboard, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBaseSelectionSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBaseDropdown(_selectedInputBase, (newValue) {
            setState(() {
              _selectedInputBase = newValue!;
            });
          }),
          _buildAnimatedArrow(),
          _buildBaseDropdown(_selectedOutputBase, (newValue) {
            setState(() {
              _selectedOutputBase = newValue!;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildAnimatedArrow() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 2 * math.pi),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: const Icon(
            Icons.swap_horiz,
            color: Colors.white,
            size: 30,
          ),
        );
      },
      curve: Curves.linear,
    );
  }

  Widget _buildBaseDropdown(String currentValue, void Function(String?)? onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _baseColors[currentValue]?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        dropdownColor: Colors.blue[900]?.withOpacity(0.9),
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        onChanged: onChanged,
        items: _bases.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConvertButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[400]!,
            Colors.blue[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[900]!.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          setState(() {
            _resultConversion = _convertNumber(
              _inputController.text,
              _selectedInputBase,
              _selectedOutputBase,
            );
            _animationController.reset();
            _animationController.forward();
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bolt, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'CONVERTIR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return AnimatedOpacity(
      opacity: _resultConversion.isEmpty ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: _buildGlassCard(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'RESULTADO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                _resultConversion.isEmpty ? '' : _resultConversion,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _selectedOutputBase.toUpperCase(),
                style: TextStyle(
                  color: _baseColors[_selectedOutputBase],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}