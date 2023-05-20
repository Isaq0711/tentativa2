import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String userId;
  late String username;
  late String photoURL;

   UserData({required this.userId, required this.username, String? photoURL}) {
    this.photoURL = photoURL ?? 'URL da Foto do Perfil';
  }


  factory UserData.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final userId = snapshot.id;
    final username = data["username"] ?? "";
    final photoURL = data["photoURL"];
    return UserData(userId: userId, username: username, photoURL: photoURL);
  }
}

Future<void> fetchProfileData(UserData userData) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userId = user.uid;

    final profileSnapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();

    if (profileSnapshot.exists) {
      final profileData = profileSnapshot.data() as Map<String, dynamic>;
      userData.username = profileData['username'];
      userData.photoURL = profileData['photoURL'];
    } else {
      userData.username = 'Nome de Usuário';
      userData.photoURL = 'URL da Foto do Perfil';
    }
  }
}
