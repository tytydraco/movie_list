import 'package:flutter/material.dart';
import 'package:movie_list/screens/tab_screen.dart';
import 'package:movie_list/widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginFormWidget(
          onLogin: (listId) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TabScreen(listId: listId)
            ));
          },
        ),
      ),
    );
  }
}
