// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameFormController = TextEditingController();
  final _passwordFormController = TextEditingController();

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    const apiUrl = 'https://minimalapaijwt.azurewebsites.net/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      final id = responseData['user']['id'];
      final role = responseData['user']['role'];

      return {
        'token': token,
        'id': id,
        'role': role,
      };
    } else {
      throw Exception('Failed to login');
    }
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final username = _userNameFormController.text;
      final password = _passwordFormController.text;

      try {
        final loginData = await loginUser(username, password);
        final token = loginData['token'];
        final id = loginData['id'];
        final role = loginData['role'];

        print('Token: $token');
        print('ID: $id');
        print('Role: $role');

        // Faça algo com o token, id e role, como navegar para a próxima tela ou salvar em um estado global.
      } catch (e) {
        print('Error: $e');
        // Trate o erro de login, como exibindo uma mensagem de erro.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _userNameFormController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Digite seu nome",
                    border: const OutlineInputBorder(),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _passwordFormController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Digite sua senha",
                    border: const OutlineInputBorder(),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text("LOGIN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
