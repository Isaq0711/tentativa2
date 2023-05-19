import 'package:flutter/material.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/screens/homescreen.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: AppTheme.headlinewhite ),
        backgroundColor: AppTheme.vinho,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Ação do botão "Falar Conosco"
              },
              icon: const Icon(Icons.mail),
              label: const Text('Falar Conosco', style: AppTheme.titlewhite),
               style: ElevatedButton.styleFrom(
                primary: AppTheme.vinho,
                
              )
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Sair', style: AppTheme.titlewhite),
              style: ElevatedButton.styleFrom(
                primary: AppTheme.vinho,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

