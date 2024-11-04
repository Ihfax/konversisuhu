import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konversi Suhu',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 251, 5, 5), // Mengubah warna utama
        scaffoldBackgroundColor:
            Colors.grey[200], // Mengubah warna latar belakang
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.teal, // Mengubah warna tombol dan elemen lain
          secondary: const Color.fromARGB(
              255, 0, 0, 0), // Mengubah warna aksen seperti dropdown highlight
        ),
      ),
      home: KonversiSuhu(),
    );
  }
}

class KonversiSuhu extends StatefulWidget {
  const KonversiSuhu({super.key});

  @override
  _KonversiSuhuState createState() => _KonversiSuhuState();
}

class _KonversiSuhuState extends State<KonversiSuhu> {
  final TextEditingController _controller = TextEditingController();
  String _selectedUnit = 'Celcius'; // Satuan suhu input
  String _outputUnit = 'Celcius'; // Satuan suhu output
  double _celcius = 0.0;
  double _fahrenheit = 0.0;
  double _kelvin = 0.0;
  double _reamur = 0.0;

  void _convertTemperature() {
    setState(() {
      double input = double.tryParse(_controller.text) ?? 0.0;

      // Konversi suhu berdasarkan satuan yang dipilih
      switch (_selectedUnit) {
        case 'Celcius':
          _celcius = input;
          _fahrenheit = (input * 9 / 5) + 32;
          _kelvin = input + 273.15;
          _reamur = input * 4 / 5;
          break;
        case 'Fahrenheit':
          _celcius = (input - 32) * 5 / 9;
          _fahrenheit = input;
          _kelvin = _celcius + 273.15;
          _reamur = _celcius * 4 / 5;
          break;
        case 'Kelvin':
          _celcius = input - 273.15;
          _fahrenheit = (_celcius * 9 / 5) + 32;
          _kelvin = input;
          _reamur = _celcius * 4 / 5;
          break;
        case 'Reamur':
          _celcius = input * 5 / 4;
          _fahrenheit = (_celcius * 9 / 5) + 32;
          _kelvin = _celcius + 273.15;
          _reamur = input;
          break;
      }
    });
  }

  void _resetAll() {
    setState(() {
      _controller.clear();
      _selectedUnit = 'Celcius';
      _outputUnit = 'Celcius';
      _celcius = 0.0;
      _fahrenheit = 0.0;
      _kelvin = 0.0;
      _reamur = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi Suhu'),
        backgroundColor: Colors.teal, // Ubah warna AppBar
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*')), // Memungkinkan angka desimal
              ],
              decoration: InputDecoration(
                labelText: 'Masukkan suhu',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 19, 19, 19)), // Ubah warna teks label
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.teal), // Ubah warna border saat fokus
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                });
              },
              items: <String>['Celcius', 'Fahrenheit', 'Kelvin', 'Reamur']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _outputUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _outputUnit = newValue!;
                });
              },
              items: <String>['Celcius', 'Fahrenheit', 'Kelvin', 'Reamur']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _convertTemperature();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal, // Ubah warna teks tombol
              ),
              child: Text('Konversi Suhu'),
            ),
            SizedBox(height: 20),
            Text(
              _controller.text.isEmpty
                  ? 'Look At Me '
                  : 'Suhu dalam $_outputUnit: ${_getConvertedValue().toStringAsFixed(2)} ${_outputUnit.substring(0, 1)}',
              style: TextStyle(
                fontSize: 20,
                color: _controller.text.isEmpty
                    ? const Color.fromARGB(255, 255, 0, 0)
                    : Colors.black, // Warna
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetAll,
        backgroundColor: Colors.teal, // Warna FAB
        child: Icon(Icons.refresh), // Ikon reset
      ),
    );
  }

  double _getConvertedValue() {
    switch (_outputUnit) {
      case 'Celcius':
        return _celcius;
      case 'Fahrenheit':
        return _fahrenheit;
      case 'Kelvin':
        return _kelvin;
      case 'Reamur':
        return _reamur;
      default:
        return 0.0; // Jika tidak ada pilihan yang valid
    }
  }
}
