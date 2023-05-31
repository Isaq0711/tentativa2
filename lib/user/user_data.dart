import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String userId;
  late String username;

  UserData({required this.userId, required this.username});

  factory UserData.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final userId = snapshot.id;
    final username = data["username"] ?? "";
    return UserData(userId: userId, username: username);
  }
}

Future<UserData> currentUser() async {
  final user = FirebaseAuth.instance.currentUser;
  
  if (user != null) {
    final userId = user.uid;

    final profileSnapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();

    if (profileSnapshot.exists) {
      final profileData = profileSnapshot.data() as Map<String, dynamic>;
      final username = profileData['id'];
      return UserData(userId: userId, username: username);
    } else {
      return UserData(userId: userId, username: 'Nome de Usuário');
    }
  }

  throw Exception('Usuário não autenticado');
}
