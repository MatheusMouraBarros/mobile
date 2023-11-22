import 'package:flutter/material.dart';
import 'package:mobile/pages/FeedPage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/ProfilePage.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  int _currentIndex = 0;

  List<Widget> _screens = [
    _RankingScreen(category: 'Lidos'),
    _RankingScreen(category: 'Publicados'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _screens[_currentIndex],
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
                _navigateToFeed(context);
              },
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPerfil(context);
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Lidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Publicados',
          ),
        ],
      ),
    );
  }

  void _navigateToFeed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FeedPage(
                articles: [],
              )),
    );
  }

  void _navigateToPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }
}

class _RankingScreen extends StatelessWidget {
  final String category;

  const _RankingScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ranking $category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Center(
                    child: Text(
                      '${index + 1} - Nome do usuário',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  trailing: Icon(
                    category == 'Lidos' ? Icons.book : Icons.note,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
