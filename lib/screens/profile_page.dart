import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/bars/bottom_nav_bar.dart';
import 'package:tentativa_2/user/user_data.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData _userData = UserData(userId: '', username: '');
  int _followerCount = 0;
  bool _isFollowing = false;
  bool _isCurrentUser = false;
  List<String> _followers = [];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final profileSnapshot = await FirebaseFirestore.instance.collection('profiles').doc(widget.username).get();
      final profileData = profileSnapshot.data();

      setState(() {
        _userData = UserData(userId: userId, username: widget.username);
        _isCurrentUser = user.displayName == widget.username;
      });

      // Verificar se o usuário autenticado já segue o perfil
      final followingSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .collection('following')
          .doc(widget.username)
          .get();
      setState(() {
        _isFollowing = followingSnapshot.exists;
      });

      // Obter a lista de usernames dos seguidores
      final followersSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(widget.username)
          .collection('followers')
          .get();
      setState(() {
        _followers = followersSnapshot.docs.map((doc) => doc.data()['username'] as String).toList();
        _followerCount = followersSnapshot.size;
      });
    }
  }

  Future<void> updateFollowerCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final profileRef = FirebaseFirestore.instance.collection('profiles').doc(userId);
      final profileSnapshot = await profileRef.get();
      final profileData = profileSnapshot.data();

      if (!_isFollowing) {
        // Seguir o perfil
        await profileRef.collection('following').doc(widget.username).set({});
        setState(() {
          _isFollowing = true;
        });

        // Adicionar o username do seguidor à lista
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(widget.username)
            .collection('followers')
            .doc(userId)
            .set({'username': widget.username});
        setState(() {
          _followers.add(widget.username);
        });
      } else {
        // Deixar de seguir o perfil
        await profileRef.collection('following').doc(widget.username).delete();
        setState(() {
          _isFollowing = false;
        });

        // Remover o username do seguidor da lista
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(widget.username)
            .collection('followers')
            .doc(userId)
            .delete();
        setState(() {
          _followers.remove(widget.username);
        });
      }

      // Atualizar o contador de seguidores do perfil
      await FirebaseFirestore.instance.collection('profiles').doc(widget.username).update({
        'followerCount': _followers.length,
      });
      setState(() {
        _followerCount = _followers.length;
      });
    }
  }

  void showFollowersList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seguidores'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _followers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_followers[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
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
        title: Text(
          _isCurrentUser ? "Meu perfil" : "Perfil",
          style: AppTheme.titlewhite,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.vinho,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              widget.username,
              style: AppTheme.headline,
            ),
            if (!_isCurrentUser) SizedBox(height: 10),
            // Botão "Seguir"
            Visibility(
              visible: !_isCurrentUser,
              child: ElevatedButton(
                onPressed: () {
                  updateFollowerCount();
                },
                child: Text(_isFollowing ? 'Seguindo' : 'Seguir'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: showFollowersList,
                  child: Text(
                    '$_followerCount',
                    style: AppTheme.body1.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  _followerCount == 1 ? ' Seguidor' : ' Seguidores',
                  style: AppTheme.body1,
                ),
              ],
            ),
            SizedBox(height: 40),
            const Text('Minhas peças', style: AppTheme.headline),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            const Text('Meus looks', style: AppTheme.headline),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
