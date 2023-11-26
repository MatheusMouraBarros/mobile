import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/FeedPage.dart';

class FormExample extends StatefulWidget {
  const FormExample({Key? key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  void _loginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('JSON enviado: {email: $_email, password: $_password}');

      try {
        final response = await http.post(
          Uri.parse(
              'https://backend-production-153d.up.railway.app/auth/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': _email!,
            'password': _password!,
          }),
        );

        print('Resposta do servidor: ${response.body}');

        if (response.statusCode == 200) {
          final token = json.decode(response.body)['token'];
          print('Token: $token');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedPage(token: token),
            ),
          );
        } else {
          print('Falha na autenticação: ${response.statusCode}');
        }
      } catch (e) {
        print('Erro ao se conectar ao servidor: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Digite seu email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, coloque seu email';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          SizedBox(height: 20.0),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: 'Digite sua senha',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, coloque sua senha';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _loginButtonPressed,
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
