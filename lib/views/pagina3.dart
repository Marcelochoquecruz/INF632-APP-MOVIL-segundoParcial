import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class Pagina3 extends StatefulWidget {
  const Pagina3({super.key});

  @override
  _Pagina3State createState() => _Pagina3State();
}

class _Pagina3State extends State<Pagina3> with TickerProviderStateMixin {
  final TextEditingController _numberController = TextEditingController();
  String _result = '';
  bool _isAnimating = false;
  List<PrimeNumber> _primeNumbers = [];
  late AnimationController _checkAnimation;
  late AnimationController _resultAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _checkAnimation = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _resultAnimation = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultAnimation, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _checkAnimation.dispose();
    _resultAnimation.dispose();
    _numberController.dispose();
    super.dispose();
  }

  bool _isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;

    int i = 5;
    while (i * i <= n) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
      i += 6;
    }
    return true;
  }

  void _checkPrime() async {
    int? number = int.tryParse(_numberController.text);
    if (number != null) {
      setState(() {
        _isAnimating = true;
        _primeNumbers.clear();
      });

      // Animación de verificación
      await _checkAnimation.forward(from: 0.0);

      setState(() {
        _result = _isPrime(number)
            ? '¡$number es un número primo! 🎉'
            : '$number no es un número primo 😔';
        
        // Generar números primos cercanos para visualización
        for (int i = math.max(2, number - 5); i <= number + 5; i++) {
          if (_isPrime(i)) {
            _primeNumbers.add(PrimeNumber(
              number: i,
              isTarget: i == number,
              isPrime: _isPrime(i),
            ));
          }
        }
      });

      _resultAnimation.forward(from: 0.0);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _isAnimating = false);
    } else {
      setState(() {
        _result = 'Por favor, ingrese un número válido 🤔';
        _resultAnimation.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInputCard(),
                  const SizedBox(height: 20),
                  _buildResultCard(),
                  if (_primeNumbers.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildPrimeVisualization(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Números Primos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildAnimatedBackground(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.withOpacity(0.7),
                    Colors.purple.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _checkAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: PrimeNumbersPainter(
            animation: _checkAnimation.value,
            numbers: List.generate(20, (index) => index + 1),
          ),
        );
      },
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingrese un número',
                prefixIcon: const Icon(FontAwesomeIcons.calculator),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            _buildCheckButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckButton() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _isAnimating ? null : _checkPrime,
          icon: _isAnimating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(FontAwesomeIcons.magnifyingGlass),
          label: Text(_isAnimating ? 'Verificando...' : 'Verificar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: _result.contains('es un número primo')
                  ? [Colors.green.shade300, Colors.green.shade100]
                  : [Colors.orange.shade300, Colors.orange.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    _result.contains('es un número primo')
                        ? FontAwesomeIcons.crown
                        : FontAwesomeIcons.circleXmark,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPrimeVisualization() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _primeNumbers.length,
        itemBuilder: (context, index) {
          final primeNumber = _primeNumbers[index];
          return AnimatedBuilder(
            animation: _resultAnimation,
            builder: (context, child) {
              final delay = index * 0.1;
              final value = math.max(0.0, _resultAnimation.value - delay);
              return Transform.scale(
                scale: Curves.elasticOut.transform(value),
                child: Card(
                  color: primeNumber.isTarget
                      ? Colors.blue.shade400
                      : (primeNumber.isPrime
                          ? Colors.green.shade300
                          : Colors.orange.shade300),
                  child: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      '${primeNumber.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PrimeNumber {
  final int number;
  final bool isTarget;
  final bool isPrime;

  PrimeNumber({
    required this.number,
    required this.isTarget,
    required this.isPrime,
  });
}

class PrimeNumbersPainter extends CustomPainter {
  final double animation;
  final List<int> numbers;

  PrimeNumbersPainter({required this.animation, required this.numbers});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    for (var i = 0; i < numbers.length; i++) {
      final x = (i % 5) * (size.width / 5);
      final y = (i ~/ 5) * (size.height / 4);
      final number = numbers[i];

      final offset = math.sin((animation * 2 * math.pi) + i) * 10;

      canvas.save();
      canvas.translate(x + offset, y);
      canvas.rotate(animation * math.pi * 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '$number',
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 20 + (math.sin(animation * 2 * math.pi + i) + 1) * 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(PrimeNumbersPainter oldDelegate) =>
      animation != oldDelegate.animation;
}