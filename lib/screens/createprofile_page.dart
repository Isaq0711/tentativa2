import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/screens/feed.dart';

class CreateProfilePage extends StatefulWidget {
  final String userId;

  const CreateProfilePage({required this.userId});

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  String? _photoURL;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.vinho,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Crie o seu perfil',
                    style: AppTheme.display1,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome de usuário';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome de usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_usernameController.text.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          // Upload da foto do perfil para o Firebase Storage
                          final photoURL = await _uploadProfilePhoto();

                          // Salvar os dados do perfil no Firestore
                          await FirebaseFirestore.instance
                              .collection('profiles')
                              .doc(widget.userId)
                              .set({
                            'username': _usernameController.text,
                            'photoURL': photoURL,
                          });

                          setState(() {
                            _isLoading = false;
                          });

                          // Navegar para a página principal ou realizar alguma outra ação
                          // como exibir uma mensagem de sucesso.
                          // Exemplo:
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedPage(),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Erro'),
                              content: Text('Ocorreu um erro ao criar o perfil.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Criar Perfil', style: AppTheme.titlewhite,),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.vinho)
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_usernameController.text.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          // Salvar os dados do perfil no Firestore sem foto
                          final photoURL = _photoURL ?? 'URL da Foto Genérica';

                          await FirebaseFirestore.instance
                              .collection('profiles')
                              .doc(widget.userId)
                              .set({
                            'username': _usernameController.text,
                            'photoURL': photoURL,
                          });

                          setState(() {
                            _isLoading = false;
                          });

                          // Navegar para a página principal ou realizar alguma outra ação
                          // como exibir uma mensagem de sucesso.
                          // Exemplo:
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedPage(),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Erro'),
                              content: Text('Ocorreu um erro ao criar o perfil.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Criar Perfil sem Foto', style: AppTheme.titlewhite,),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.vinho)
                  ),
                ],
              ),
            ),
    );
  }

  Future<String?> _uploadProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child('profile_photos/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } else {
      return null;
    }
  }
}