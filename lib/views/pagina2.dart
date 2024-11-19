import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'dart:ui';

class Pagina2 extends StatefulWidget {
  const Pagina2({super.key});

  @override
  _Pagina2State createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> with TickerProviderStateMixin {
  double _amount = 0.0;
  String _fromCurrency = 'BOB';
  String _toCurrency = 'USD';
  final double _conversionRate = 0.1447;
  
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late TextEditingController _amountController;

  final Map<String, String> _currencySymbols = {
    'BOB': 'Bs',
    'USD': '\$',
  };

  final Map<String, String> _currencyFlags = {
    'BOB': '🇧🇴',
    'USD': '🇺🇸',
  };

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _amountController.dispose();
    super.dispose();
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
          child: CustomScrollView(
            slivers: [
              _buildAnimatedAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildFloatingCard(_buildInputSection()),
                      const SizedBox(height: 20),
                      _buildFloatingCard(_buildConversionResult()),
                      const SizedBox(height: 20),
                      _buildFloatingCard(_buildUserGuide()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Conversor Premium',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        background: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: SweepGradient(
                          colors: [
                            Colors.blue[400]!.withOpacity(0.3),
                            Colors.blue[600]!.withOpacity(0.3),
                            Colors.blue[800]!.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.2),
                    child: Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCard(Widget child) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi) * 3),
          child: Container(
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
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildShimmeringText('Ingrese el monto'),
          const SizedBox(height: 15),
          _buildAmountInput(),
          const SizedBox(height: 20),
          _buildCurrencySelector(),
        ],
      ),
    );
  }

  Widget _buildShimmeringText(String text) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.white,
              Colors.blue[300]!,
              Colors.white,
            ],
            stops: [value - 0.3, value, value + 0.3],
            tileMode: TileMode.mirror,
          ).createShader(bounds),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountInput() {
    return TextField(
      controller: _amountController,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(
          FontAwesomeIcons.moneyBillWave,
          color: Colors.green[300],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      onChanged: (value) {
        setState(() {
          _amount = double.tryParse(value) ?? 0.0;
        });
      },
    );
  }

  Widget _buildCurrencySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCurrencyDropdown(true),
        _buildAnimatedExchangeIcon(),
        _buildCurrencyDropdown(false),
      ],
    );
  }

  Widget _buildAnimatedExchangeIcon() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 4 * math.pi,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[400],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[600]!.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              FontAwesomeIcons.rightLeft,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyDropdown(bool isFrom) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(
            isFrom ? _currencyFlags[_fromCurrency]! : _currencyFlags[_toCurrency]!,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: isFrom ? _fromCurrency : _toCurrency,
            dropdownColor: Colors.blue[900]?.withOpacity(0.9),
            underline: Container(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (String? newValue) {
              setState(() {
                if (isFrom) {
                  _fromCurrency = newValue!;
                } else {
                  _toCurrency = newValue!;
                }
              });
            },
            items: ['BOB', 'USD'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionResult() {
    final convertedAmount = _amount * _conversionRate;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildShimmeringText('Resultado'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedAmount(_amount, _fromCurrency),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  FontAwesomeIcons.equals,
                  color: Colors.white,
                ),
              ),
              _buildAnimatedAmount(convertedAmount, _toCurrency),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAmount(double amount, String currency) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: amount),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Text(
          '${_currencySymbols[currency]} ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget _buildUserGuide() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildShimmeringText('Guía de Uso'),
          const SizedBox(height: 20),
          _buildGuideStep(
            icon: FontAwesomeIcons.moneyBill,
            text: 'Ingresa el monto a convertir',
          ),
          _buildGuideStep(
            icon: FontAwesomeIcons.rightLeft,
            text: 'Selecciona las monedas',
          ),
          _buildGuideStep(
            icon: FontAwesomeIcons.chartLine,
            text: 'Observa el resultado en tiempo real',
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}