import 'package:flutter/material.dart';
import 'package:mobile/pages/CadastroScreen2.dart';
import 'package:mobile/widgets/UserRegistrationData.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _userData = UserRegistrationData();

  void _cadastrar() {
    if (_userData.email.isEmpty ||
        _userData.confirmarEmail.isEmpty ||
        _userData.senha.isEmpty ||
        _userData.confirmarSenha.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_userData.email != _userData.confirmarEmail) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Os campos de e-mail não correspondem.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_userData.senha != _userData.confirmarSenha) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Os campos de senha não correspondem.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    print('E-mail: ${_userData.email}');
    print('Confirmar E-mail: ${_userData.confirmarEmail}');
    print('Senha: ${_userData.senha}');
    print('Confirmar Senha: ${_userData.confirmarSenha}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen2(userRegistrationData: _userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => _userData.email = value,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) => _userData.confirmarEmail = value,
              decoration: InputDecoration(
                labelText: 'Confirmar E-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) => _userData.senha = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) => _userData.confirmarSenha = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _cadastrar,
              child: Text('Próximo 1/3'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
