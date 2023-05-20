import 'package:flutter/material.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/bars/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tentativa_2/user_data.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String photoURL; // Add the photoURL field

  const ProfileScreen({Key? key, required this.username, required this.photoURL}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData _userData = UserData(userId: '', username: '', photoURL: '');

  @override
  void initState() {
    super.initState();
    fetchProfileData(_userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meu perfil",
          style: AppTheme.titlewhite,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.vinho,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.photoURL), // Access the photoURL value through the widget
            ),
            SizedBox(height: 20),
            Text(
          widget.username, // Acessa o valor de username através do widget
          style: AppTheme.headline
        ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '200',
                  style: AppTheme.body1,
                ),
                SizedBox(width: 5),
                Text(
                  'seguidores',
                  style: AppTheme.body1,
                ),
                SizedBox(width: 20),
                Text(
                  '150',
                  style: AppTheme.body1,
                ),
                SizedBox(width: 5),
                Text(
                  'seguindo',
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
