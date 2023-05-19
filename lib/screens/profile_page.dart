import 'package:flutter/material.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/bars/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String username; // Adiciona o campo username

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: AppTheme.nearlyWhite),
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
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'),
            ),
            SizedBox(height: 20),
            Text(
              "Meu perfil",
              style: AppTheme.headline,
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
