import 'package:flutter/material.dart';
import 'package:mobile/pages/LoginPage.dart';

class Graduacao {
  String tipo;
  String universidade;
  String curso;
  String dataEntrada;
  String dataFormacao;

  Graduacao({
    required this.tipo,
    required this.universidade,
    required this.curso,
    required this.dataEntrada,
    required this.dataFormacao,
  });
}

class CadastroScreen3 extends StatefulWidget {
  @override
  _CadastroScreen3State createState() => _CadastroScreen3State();
}

class _CadastroScreen3State extends State<CadastroScreen3> {
  List<Graduacao> graduacoes = [];
  TextEditingController _tipoFormacaoController = TextEditingController();
  TextEditingController _universidadeController = TextEditingController();
  TextEditingController _cursoController = TextEditingController();
  TextEditingController _dataEntradaController = TextEditingController();
  TextEditingController _dataFormacaoController = TextEditingController();

  void _adicionarGraduacao() {
    setState(() {
      graduacoes.add(
        Graduacao(
          tipo: _tipoFormacaoController.text,
          universidade: _universidadeController.text,
          curso: _cursoController.text,
          dataEntrada: _dataEntradaController.text,
          dataFormacao: _dataFormacaoController.text,
        ),
      );
      _tipoFormacaoController.clear();
      _universidadeController.clear();
      _cursoController.clear();
      _dataEntradaController.clear();
      _dataFormacaoController.clear();
    });
  }

  void _finalizarCadastro() {
    // Lógica para o backend - está imprimindo no console para teste
    print('Graduações Salvas:');
    for (var grad in graduacoes) {
      print('${grad.tipo} em ${grad.curso} - ${grad.universidade}');
      print('Entrada: ${grad.dataEntrada}, Formação: ${grad.dataFormacao}');
      print('---------------------------');
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('informações acadêmicas'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _tipoFormacaoController,
                decoration: InputDecoration(
                  labelText: 'Tipo de Formação',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _universidadeController,
                decoration: InputDecoration(
                  labelText: 'Universidade',
                  prefixIcon: Icon(Icons.account_balance),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _cursoController,
                decoration: InputDecoration(
                  labelText: 'Nome do Curso',
                  prefixIcon: Icon(Icons.menu_book),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _dataEntradaController,
                decoration: InputDecoration(
                  labelText: 'Data de Entrada',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _dataFormacaoController,
                decoration: InputDecoration(
                  labelText: 'Data de Formação',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _adicionarGraduacao,
                child: Text('Adicionar Graduação'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _finalizarCadastro,
                child: Text('Finalizar Cadastro'),
              ),
              SizedBox(height: 32.0),
              Text(
                'Graduações Cadastradas:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: graduacoes.length,
                itemBuilder: (context, index) {
                  final grad = graduacoes[index];
                  return ListTile(
                    title: Text(
                      '${grad.tipo} em ${grad.curso} - ${grad.universidade}',
                    ),
                    subtitle: Text(
                      'Entrada: ${grad.dataEntrada}, Formação: ${grad.dataFormacao}',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
