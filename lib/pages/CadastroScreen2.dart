import 'package:flutter/material.dart';
import 'package:mobile/pages/CadastroScreen3.dart';

class CadastroScreen2 extends StatefulWidget {
  @override
  _CadastroScreen2State createState() => _CadastroScreen2State();
}

class _CadastroScreen2State extends State<CadastroScreen2> {
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cidadeController = TextEditingController();

  String _selectedEstado = "Selecione um estado";

  List<String> estados = [
    "Selecione um estado",
    "Estado A",
    "Estado B",
    "Estado C"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do Usuário'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _sobrenomeController,
                decoration: InputDecoration(
                  labelText: 'Sobrenome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: _selectedEstado,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEstado = newValue!;
                  });
                },
                items: estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _cidadeController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Lógica para o backend
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroScreen3()),
                  );
                },
                child: Text('Próximo 2/3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
