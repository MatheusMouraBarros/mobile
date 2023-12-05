import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/widgets/Token.dart';

class Comment {
  final int commentId;
  final String commentText;
  final String commenterName;

  Comment({
    required this.commentId,
    required this.commentText,
    required this.commenterName,
  });
}

class CommentsPage extends StatefulWidget {
  final int postId;

  CommentsPage({required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  List<Comment> _decodeComments(String responseBody) {
    final List<dynamic> jsonData =
        json.decode(utf8.decode(responseBody.codeUnits))['comentarios'];
    return jsonData.map((item) {
      final String commenterName =
          item['pessoa'] != null ? item['pessoa']['nome'] : 'Anônimo';

      return Comment(
        commentId: item['id'],
        commentText: item['texto_comentario'],
        commenterName: commenterName,
      );
    }).toList();
  }

  Future<void> _fetchComments() async {
    try {
      if (!_isTokenValid(Token().token)) {
        _handleInvalidToken();
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://backend-production-153d.up.railway.app/comentarios/${widget.postId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Token().token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          comments = _decodeComments(response.body);
        });
      } else {
        print('Falha ao carregar os comentários: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro ao se conectar ao servidor: $e');
    }
  }

  Future<void> _postComment(String comment) async {
    try {
      if (!_isTokenValid(Token().token)) {
        _handleInvalidToken();
        return;
      }

      final response = await http.post(
        Uri.parse(
            'https://backend-production-153d.up.railway.app/comentarios/comentar/${widget.postId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Token().token}',
        },
        body: jsonEncode({'texto_comentario': comment}),
      );

      if (response.statusCode == 200) {
        print('Comentário postado com sucesso!');
        _fetchComments();

        // Limpar o texto do controlador após o comentário ser postado
        commentController.clear();
      } else {
        print('Falha ao postar o comentário: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro ao postar o comentário: $e');
    }
  }

  bool _isTokenValid(String token) {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      if (decodedToken.containsKey('exp')) {
        int expirationTime = decodedToken['exp'];
        int currentTimeInSeconds =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;

        return expirationTime > currentTimeInSeconds;
      }
    } catch (e) {
      print('Erro ao verificar a validade do token: $e');
    }
    return false;
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
      _fetchComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentários'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comments[index].commentText,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Comentado por: ${comments[index].commenterName}',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Escreva seu comentário...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _postComment(commentController.text);
                  },
                  child: Text(
                    'Comentar',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
