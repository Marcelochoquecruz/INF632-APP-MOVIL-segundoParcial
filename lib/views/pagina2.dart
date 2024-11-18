import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importamos Font Awesome

class Pagina2 extends StatefulWidget {
  const Pagina2({super.key});

  @override
  _Pagina2State createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {
  double _amount = 0.0;
  String _fromCurrency = 'BOB';
  String _toCurrency = 'USD';
  double _conversionRate = 0.1447; // 1 BOB = 0.1447 USD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Conversor de Moneda'),
        centerTitle: true,
        // Se eliminó el leading para quitar la flecha
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputSection(),
              const SizedBox(height: 20),
              _buildConversionResult(),
              const SizedBox(height: 20),
              _buildUserGuide(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingrese la cantidad:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Monto',
              prefixIcon: const Icon(FontAwesomeIcons.wallet), // Icono de billetera
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCurrencyDropdown(true),
              const Icon(FontAwesomeIcons.exchangeAlt, color: Colors.blue), // Icono de cambio de divisas
              _buildCurrencyDropdown(false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyDropdown(bool isFrom) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: isFrom ? _fromCurrency : _toCurrency,
        underline: Container(),
        icon: Icon(isFrom ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp), // Iconos de flecha hacia abajo y hacia arriba
        onChanged: (newValue) {
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
            child: Text(value, style: const TextStyle(color: Colors.blue)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConversionResult() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(FontAwesomeIcons.chartBar, color: Colors.white), // Icono de gráfico
                SizedBox(width: 10),
                Text(
                  'Resultado de la Conversión:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$_amount $_fromCurrency = ${_amount * _conversionRate} $_toCurrency',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserGuide() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(FontAwesomeIcons.infoCircle, color: Colors.blue), // Icono de info
                SizedBox(width: 10),
                Text(
                  'Guía de Uso',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: '1. Ingrese el monto a convertir.\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '2. Seleccione la moneda de origen y la moneda de destino.\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '3. El resultado de la conversión se mostrará en la parte inferior.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
