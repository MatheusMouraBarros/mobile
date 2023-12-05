import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/PostPage.dart';
import 'package:mobile/pages/ProfilePage.dart';
import 'package:mobile/pages/Ranking.dart';
import 'package:mobile/widgets/Token.dart';

class Article {
  final int postId;
  final String title;
  final String content;
  final String link;
  final int likeCount;
  final String personName;
  final String personLastName;
  final String personCity;
  final String personState;
  final String personBirthday;

  Article({
    required this.postId,
    required this.title,
    required this.content,
    required this.link,
    required this.likeCount,
    required this.personName,
    required this.personLastName,
    required this.personCity,
    required this.personState,
    required this.personBirthday,
  });
}

class FeedPage extends StatefulWidget {
  FeedPage();

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Article> articles = [];
  TextEditingController commentController = TextEditingController();

  List<Article> _decodeArticles(String responseBody) {
    final List<dynamic> jsonData =
        json.decode(utf8.decode(responseBody.codeUnits))['publicacoes'];
    return jsonData.map((item) {
      return Article(
        postId: item['id'],
        title: item['titulo'],
        content: item['descricao'],
        link: item['link'],
        likeCount: item['like_count'],
        personName: item['pessoa']['nome'],
        personLastName: item['pessoa']['sobrenome'],
        personCity: item['pessoa']['cidade'],
        personState: item['pessoa']['estado'],
        personBirthday: item['pessoa']['data_aniversario'],
      );
    }).toList();
  }

  bool _isTokenValid(String token) {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      if (decodedToken.containsKey('exp')) {
        int expirationTime = decodedToken['exp'];
        int currentTimeInSeconds =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;

        bool isValid = expirationTime > currentTimeInSeconds;
        print('O token é ${isValid ? 'válido' : 'inválido ou expirado'}');

        return isValid;
      }
    } catch (e) {
      print('Erro ao verificar a validade do token: $e');
    }
    return false;
  }

  Future<void> _fetchArticles() async {
    try {
      print('Token antes da requisição: ${Token().token}');

      if (!_isTokenValid(Token().token)) {
        print('Token inválido ou expirado');
        _handleInvalidToken();
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://backend-production-153d.up.railway.app/publicacoes',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Token().token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          articles = _decodeArticles(response.body);
        });
      } else {
        print('Falha ao carregar as publicações: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro ao se conectar ao servidor: $e');
    }
  }

  Future<void> _likePost(int publicacaoId) async {
    try {
      if (!_isTokenValid(Token().token)) {
        print('Token inválido ou expirado');
        _handleInvalidToken();
        return;
      }

      final response = await http.post(
        Uri.parse(
            'https://backend-production-153d.up.railway.app/curtir/$publicacaoId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Token().token}',
        },
      );

      if (response.statusCode == 200) {
        print('Publicação curtida com sucesso!');
        _fetchArticles();
      } else {
        print('Falha ao curtir a publicação: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro ao se conectar ao servidor: $e');
    }
  }

  Future<void> _postComment(int postId, String comment) async {
    try {
      if (!_isTokenValid(Token().token)) {
        print('Token inválido ou expirado');
        _handleInvalidToken();
        return;
      }

      // Adicione sua lógica para enviar o comentário ao servidor
      print('Comentário postado: $comment');
    } catch (e) {
      print('Erro ao postar comentário: $e');
    }
  }

  void _handleInvalidToken() {
    Token().token = "";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      _fetchArticles();
    });
  }

  Future<void> _openCommentModal(int postId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comentar'),
          content: TextField(
            controller: commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Escreva seu comentário...',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _postComment(postId, commentController.text);
                Navigator.of(context).pop();
              },
              child: Text('Comentar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        articles[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        articles[index].content,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      InkWell(
                        onTap: () async {
                          String url = articles[index].link;
                          await launch(url);
                        },
                        child: Text(
                          articles[index].link,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Autor: ${articles[index].personName} ${articles[index].personLastName}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'Cidade: ${articles[index].personCity}, Estado: ${articles[index].personState}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'Aniversário: ${articles[index].personBirthday}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _likePost(articles[index].postId);
                                },
                                icon: Icon(Icons.thumb_up, color: Colors.white),
                                label: Text('${articles[index].likeCount}',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 45.0),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _openCommentModal(articles[index].postId);
                                },
                                icon: Icon(Icons.comment, color: Colors.white),
                                label: Text('',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.share, color: Colors.white),
                            label:
                                Text('', style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostPage(token: Token().token),
            ),
          );
          if (result != null && result is bool && result) {
            _fetchArticles();
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Ranking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ranking(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Token().token = "";
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
