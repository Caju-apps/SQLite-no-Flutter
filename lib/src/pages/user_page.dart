import 'package:flutter/material.dart';
import 'package:sqlite/src/controlles/sqlite_controller.dart';
import 'package:sqlite/src/models/user_model.dart';
import 'package:sqlite/src/pages/notes_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserModel> users = [];
  final SqliteController _sqliteController = SqliteController();

  final TextEditingController _userEditController = TextEditingController();

  UserModel? _userToEdit;

  @override
  void initState() {
    super.initState();
    _sqliteController.initDb().then((_) {
      _getUsers();
    });
  }

  _getUsers() {
    _sqliteController.getUsers().then((value) {
      setState(() {
        users = value;
      });
    });
  }

  _deleteUser(int userId) {
    _sqliteController.deleteUser(userId).then((value) {
      _getUsers();
    });
  }

  _createUser(String name) {
    _sqliteController.insertUser(UserModel(id: -1, name: name)).then((value) {
      _getUsers();
    });
  }

  _updateUser(UserModel user) {
    _sqliteController.updateUser(user).then((value) {
      _getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(users[index].name),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => NotesPage(user: users[index])));
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _userToEdit = users[index];
                                    _userEditController.text = users[index].name;
                                    _showUserBottonSheet();
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _deleteUser(users[index].id);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ))),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    _showUserBottonSheet();
                  },
                  child: const Text("Criar novo usuario")),
            )
          ],
        ),
      ),
    );
  }

  _showUserBottonSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                TextField(
                  controller: _userEditController,
                  decoration: const InputDecoration(labelText: "Nome"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_userToEdit != null) {
                          _updateUser(
                              UserModel(id: _userToEdit!.id, name: _userEditController.text));
                        } else {
                          _createUser(_userEditController.text);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(_userToEdit == null ? "Criar" : "Atualizar")),
                )
              ],
            ),
          );
        }).then((_) {
      _userToEdit = null;
      _userEditController.clear();
    });
  }
}
