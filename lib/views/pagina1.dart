import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});

  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedInputBase = 'Decimal';
  String _selectedOutputBase = 'Binario';
  String _resultConversion = '';

  final List<String> _bases = ['Decimal', 'Binario', 'Octal', 'Hexadecimal'];

  String _convertNumber(String input, String inputBase, String outputBase) {
    try {
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
          return decimalValue.toRadixString(2);
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
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Convertidor de Bases',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue[200],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildInfoSection(),
              const SizedBox(height: 20),
              _buildConversionInputs(),
              const SizedBox(height: 20),
              _buildConvertButton(),
              const SizedBox(height: 20),
              _buildResultDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.infoCircle, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                'Información sobre Bases',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildBaseInfo('Decimal', 'Sistema de base 10 (0-9)', Icons.numbers),
          _buildBaseInfo('Binario', 'Sistema de base 2 (0-1)', Icons.satellite),
          _buildBaseInfo('Octal', 'Sistema de base 8 (0-7)', Icons.looks_one),
          _buildBaseInfo('Hexadecimal', 'Sistema de base 16 (0-9, A-F)', Icons.code),
        ],
      ),
    );
  }

  Widget _buildBaseInfo(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            decoration: InputDecoration(
              labelText: 'Número a convertir',
              labelStyle: TextStyle(color: Colors.blue[700]),
              prefixIcon: const Icon(FontAwesomeIcons.edit, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBaseDropdown(_selectedInputBase, (newValue) {
                setState(() {
                  _selectedInputBase = newValue!;
                });
              }, true),
              const Icon(Icons.refresh, color: Colors.black),
              _buildBaseDropdown(_selectedOutputBase, (newValue) {
                setState(() {
                  _selectedOutputBase = newValue!;
                });
              }, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBaseDropdown(String currentValue, void Function(String?)? onChanged, bool isInput) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        underline: Container(),
        icon: Icon(isInput ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: Colors.black),
        onChanged: onChanged,
        items: _bases.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orange[300],
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      icon: const Icon(Icons.refresh, color: Colors.black),
      label: const Text(
        'Convertir',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        setState(() {
          _resultConversion = _convertNumber(
            _inputController.text,
            _selectedInputBase,
            _selectedOutputBase,
          );
        });
      },
    );
  }

  Widget _buildResultDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Resultado:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _resultConversion.isEmpty
                ? 'Esperando conversión...'
                : _resultConversion,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
