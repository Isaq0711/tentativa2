import 'package:flutter/material.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/search.dart';
import 'configuration_bar.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({Key? key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  TextEditingController _searchController = TextEditingController();

  void handleSearch(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(query: query)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.nearlyWhite,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppTheme.darkText,
                    ),
                    onPressed: () {
                      handleSearch(_searchController.text);
                    },
                  ),
                  suffixIcon: Icon(
                    Icons.camera_alt_rounded,
                    color: AppTheme.darkText,
                  ),
                ),
                onFieldSubmitted: handleSearch,
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      centerTitle: true,
      backgroundColor: AppTheme.vinho,
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfigPage()),
            );
          },
        ),
      ],
    );
  }
}
