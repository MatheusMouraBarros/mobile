import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  final String token;

  PostPage({required this.token});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  void _publishPost() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://backend-production-153d.up.railway.app/publicacoes/publicar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'titulo': titleController.text,
          'descricao': contentController.text,
          'link': linkController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully published post
        Navigator.pop(context, true); // Navigate back to feed page
      } else {
        print('Failed to publish post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error connecting to the server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titulo'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Descriação'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Link'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _publishPost,
              child: Text('Publish'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
