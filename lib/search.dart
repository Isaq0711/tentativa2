import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/screens/feed.dart';
import 'package:tentativa_2/user/user_data.dart';
import 'bars/appbar.dart';
import 'screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Search extends StatefulWidget {
  final String query;

  Search({required this.query});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  void handleSearch(String query) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .where("id", isGreaterThanOrEqualTo: query)
        .get();

    setState(() {
      searchResults = snapshot.docs.map((doc) => doc.data()['id'] as String).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    handleSearch(widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return UserResult(username: searchResults[index]);
        },
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final String username;

  UserResult({required this.username});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username, style: AppTheme.body2,),
      onTap: () {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.displayName != username) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(username: username),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(username: user!.displayName!),
            ),
          );
        }
      },
    );
  }
}
