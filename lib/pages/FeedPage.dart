import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/CreatePostPage.dart';
import 'package:mobile/pages/ProfilePage.dart';
import 'package:mobile/pages/Ranking.dart';

class Article {
  final String title;
  final String content;
  final String link;

  Article({required this.title, required this.content, required this.link});
}

// ignore: must_be_immutable
class FeedPage extends StatefulWidget {
  String token;

  FeedPage({required this.token});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://backend-production-153d.up.railway.app/publicacoes/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          articles = data.map((item) {
            return Article(
              title: item['title'],
              content: item['content'],
              link: item['link'],
            );
          }).toList();
        });
      } else if (response.statusCode == 401) {
        print('Token expirado. Redirecionando para a tela de login...');
        widget.token = "";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        print('Falha ao buscar as publicações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao se conectar ao servidor: $e');
    }
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
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Padding(
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
                  Text(
                    articles[index].link,
                    style: TextStyle(fontSize: 14.0, color: Colors.blue),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.thumb_up, color: Colors.white),
                        label: Text(''),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'Comentar...',
                              contentPadding: EdgeInsets.all(8.0),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share, color: Colors.white),
                        label: Text(''),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(),
            ),
          );
          if (result != null && result is Article) {
            setState(() {
              articles.add(result);
            });
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
                widget.token = "";
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
