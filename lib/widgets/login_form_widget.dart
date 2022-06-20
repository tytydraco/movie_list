import 'package:flutter/material.dart';
import 'package:movie_list/remote/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String) onLogin;

  const LoginFormWidget({
    Key? key,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final listIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false;

  Future _onLogin() async {
    if (formKey.currentState!.validate()) {
      await setSavedLogin();
      widget.onLogin(listIdController.text);
    }
  }

  Future _onDeleteList() async {
    if (formKey.currentState!.validate()) {
      final dialog = AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to permanently delete this list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              final database = Database(listIdController.text);
              setState(() => isLoading = true);
              await database.deleteList();
              setState(() => isLoading = false);
            },
            child: const Text('Confirm'),
          ),
        ],
      );
      showDialog(
        context: context,
        builder: (context) => dialog,
      );
    }
  }

  Future loadSavedLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final listId = sharedPrefs.getString('listId') ?? '';
    listIdController.text = listId;
  }

  Future setSavedLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('listId', listIdController.text);
  }

  static String? validateListId(String? input) {
    if (input == null || input.isEmpty) {
      return 'Required';
    } else if (input.length > 300) {
      return 'Too long';
    } else if (input.contains('/') || input.contains('.')) {
      return 'Invalid characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    } else {
      loadSavedLogin();
      return Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  validator: validateListId,
                  controller: listIdController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'List id'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: ElevatedButton(
                  onPressed: _onLogin,
                  onLongPress: _onDeleteList,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Text('Log in'),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}