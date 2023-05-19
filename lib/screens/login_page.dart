import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tentativa_2/app_theme.dart';
import 'package:tentativa_2/screens/feed.dart';
import 'package:tentativa_2/screens/homescreen.dart';
import 'package:tentativa_2/screens/register_page.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: AppTheme.vinho),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Faça o login',
                      style: AppTheme.display1,
                    ),
                    SizedBox(height: 35),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16,),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            widget.onLoginSuccess();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FeedPage()));
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (e.code == 'user-not-found') {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Usuário não encontrado'),
                                  content: Text('O e-mail ou a senha estão incorretos'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (e.code == 'wrong-password') {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Senha incorreta'),
                                  content: Text('O e-mail ou a senha estão incorretos'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(''),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.vinho
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login), // Ícone adicionado aqui
                          SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                          Text(
                            'Entrar',
                            style: AppTheme.headlinewhite, 
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage(onRegisterSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedPage(),
                              ),
                            );
                          })),
                        );
                      },
                      child: Text(
                        'Não tem uma conta? Cadastre-se aqui',
                        style: AppTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class AuthCheckPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Aguardando a verificação de autenticação
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // Verifica se o usuário está autenticado
          if (snapshot.hasData) {
            // Redireciona para a página inicial se o usuário estiver autenticado
            return HomeScreen();
          } else {
            // Redireciona para a página de login se o usuário não estiver autenticado
            return LoginPage(
              onLoginSuccess: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            );
          }
        }
      },
    );
  }
}
