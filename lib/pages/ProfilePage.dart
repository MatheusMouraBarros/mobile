import 'package:flutter/material.dart';
import 'package:mobile/pages/FeedPage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/Ranking.dart';

class UserProfile {
  final String name;
  String description;
  List<String> publishedArticles;
  List<String> readArticles;

  UserProfile({
    required this.name,
    required this.description,
    required this.publishedArticles,
    required this.readArticles,
  });
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfile _userProfile;
  final TextEditingController _editedDescriptionController =
      TextEditingController();
  bool _showReadArticles = true;

  @override
  void initState() {
    super.initState();

    _userProfile = UserProfile(
      name: 'Usuário Exemplo',
      description: 'Breve descrição do usuário.',
      publishedArticles: ['Artigo 1', 'Artigo 2'],
      readArticles: ['Artigo 3', 'Artigo 4'],
    );

    _editedDescriptionController.text = _userProfile.description;
  }

  void _saveEditedDescription() {
    setState(() {
      _userProfile.description = _editedDescriptionController.text;
    });
    Navigator.of(context).pop();
  }

  void _openEditDescriptionModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Descrição'),
          content: Column(
            children: [
              TextField(
                controller: _editedDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Digite sua nova descrição aqui...',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Descrição Salva: ${_userProfile.description}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: _saveEditedDescription,
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleArticlesView(bool showReadArticles) {
    setState(() {
      _showReadArticles = showReadArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 36.0,
                  color: Colors.blue,
                ),
                SizedBox(width: 16),
                Text(
                  _userProfile.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _openEditDescriptionModal,
              child: Text('Editar Descrição'),
            ),
            SizedBox(height: 16),
            Text(
              'Descrição: ${_userProfile.description}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleArticlesView(true),
                  style: ElevatedButton.styleFrom(
                    primary: _showReadArticles ? Colors.blue : null,
                    minimumSize: Size(120, 48),
                  ),
                  child: Text('Lidos'),
                ),
                ElevatedButton(
                  onPressed: () => _toggleArticlesView(false),
                  style: ElevatedButton.styleFrom(
                    primary: !_showReadArticles ? Colors.blue : null,
                    minimumSize: Size(120, 48),
                  ),
                  child: Text('Publicados'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              _showReadArticles ? 'Artigos Lidos:' : 'Artigos Publicados:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _showReadArticles
                  ? _userProfile.readArticles
                      .map((article) => Text('- $article'))
                      .toList()
                  : _userProfile.publishedArticles
                      .map((article) => Text('- $article'))
                      .toList(),
            ),
          ],
        ),
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
              title: Text('Feed'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedPage(
                      articles: [],
                    ),
                  ),
                );
              },
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
              title: Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
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

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
