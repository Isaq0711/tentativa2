import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/screens/feed.dart';
import '../screens/profile_page.dart';
import 'package:tentativa_2/user_data.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  UserData _userData = UserData(userId: '', username: '', photoURL: '');

  @override
  void initState() {
    super.initState();
    fetchProfileData(_userData);
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(username: _userData.username, photoURL: _userData.photoURL)), 
        );
      } else if (_selectedIndex == 1) {
        _showImageSourceDialog();
      } else if (_selectedIndex == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
          (route) => false,
        );
      }
    });
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Selecione uma opção",
            style: AppTheme.body1,
          ),
          actions: [
            TextButton(
              child: Text("Câmera"),
              onPressed: () async {
                final imagePicker = ImagePicker();
                final pickedFile =
                    await imagePicker.pickImage(source: ImageSource.camera);
                Navigator.pop(context);
                if (pickedFile != null) {
                  // TODO: fazer algo com a imagem selecionada pela câmera
                }
              },
            ),
            TextButton(
              child: Text("Galeria"),
              onPressed: () async {
                final imagePicker = ImagePicker();
                final pickedFile =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context);
                if (pickedFile != null) {
                  // Salva a imagem no diretório temporário do dispositivo
                  final directory = await getTemporaryDirectory();
                  final filePath =
                      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
                  final imageFile = File(pickedFile.path);
                  await imageFile.copy(filePath);

                  // TODO: fazer algo com a imagem selecionada da galeria
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppTheme.vinho,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: InkWell(
            child: Icon(
              Icons.home,
              color: AppTheme.nearlyWhite,
            ),
            onTap: () => _onItemTapped(0),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: AppTheme.nearlyWhite,
            ),
            onPressed: () => _onItemTapped(1),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            child: Icon(
              Icons.person_outline,
              color: AppTheme.nearlyWhite,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(username: _userData.username,photoURL: _userData.photoURL), 
                ),
              );
            },
          ),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppTheme.nearlyWhite,
      unselectedItemColor: Colors.white.withOpacity(0.5),
    );
  }
}
