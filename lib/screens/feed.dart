import 'package:flutter/material.dart';
import '../bars/bottom_nav_bar.dart';
import 'package:tentativa_2/app_theme.dart';
import '../bars/appbar.dart';
import '../bars/configuration_bar.dart';
import 'package:tentativa_2/search.dart';


class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  TextEditingController _searchController = TextEditingController();
  List<Postagem> postagens = [
    Postagem(
      imagem: 'https://picsum.photos/200/300',
      likes: 10,
      dislikes: 2,
      comentarios: 2,
    ),
    Postagem(
      imagem: 'https://picsum.photos/200/300',
      likes: 20,
      dislikes: 7,
      comentarios: 3,
    ),
    Postagem(
      imagem: 'https://picsum.photos/200/300',
      likes: 30,
      dislikes: 10,
      comentarios: 4,
    ),
  ];

  void handleSearch(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRESSME',
      home: Scaffold(
        appBar: MyAppBar(),
        body: ListView.builder(
          itemCount: postagens.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Image.network(postagens[index].imagem),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {
                            setState(() {
                              postagens[index].likes++;
                            });
                          },
                        ),
                        Text('${postagens[index].likes} likes', style: AppTheme.body1),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {
                            setState(() {
                              postagens[index].dislikes++;
                            });
                          },
                        ),
                        Text('${postagens[index].dislikes} dislikes', style: AppTheme.body1),
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            // Ação do botão de comentar
                          },
                        ),
                        Text('${postagens[index].comentarios} comentários', style: AppTheme.body1),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class Postagem {
  final String imagem;
  int likes;
  int dislikes;
  final int comentarios;

  Postagem({required this.imagem, required this.likes, required this.dislikes, required this.comentarios});
}
