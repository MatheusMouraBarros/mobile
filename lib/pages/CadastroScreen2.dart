import 'package:flutter/material.dart';
import 'package:mobile/pages/CadastroScreen3.dart';
import 'package:mobile/widgets/UserData.dart';
import 'package:mobile/widgets/UserRegistrationData.dart';

class CadastroScreen2 extends StatefulWidget {
  final UserRegistrationData userRegistrationData;

  CadastroScreen2({required this.userRegistrationData});

  @override
  _CadastroScreen2State createState() => _CadastroScreen2State();
}

class _CadastroScreen2State extends State<CadastroScreen2> {
  final _userData = UserData();
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
                onChanged: (value) => _userData.nome = value,
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) => _userData.sobrenome = value,
                controller: _sobrenomeController,
                decoration: InputDecoration(
                  labelText: 'Sobrenome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) => _userData.dataNascimento = value,
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
                    _userData.estado = newValue;
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
                onChanged: (value) => _userData.cidade = value,
                controller: _cidadeController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  print('Nome: ${_userData.nome}');
                  print('Sobrenome: ${_userData.sobrenome}');
                  print('Data de Nascimento: ${_userData.dataNascimento}');
                  print('Estado: ${_userData.estado}');
                  print('Cidade: ${_userData.cidade}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroScreen3(
                        userRegistrationData: widget.userRegistrationData,
                        userData: _userData,
                      ),
                    ),
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
