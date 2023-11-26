import 'package:flutter/material.dart';
import 'package:mobile/pages/CadastroScreen.dart';
import 'package:mobile/widgets/FormExample.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
        leading: Container(),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.0),
              Image.asset(
                'lib/assets/logo.png',
                width: 80,
                height: 80,
              ),
              SizedBox(height: 16.0),
              Text(
                'Social Study',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60.0),
              FormExample(),
              SizedBox(height: 120.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroScreen()),
                  );
                },
                child: Text(
                  'Cadastre-se',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
