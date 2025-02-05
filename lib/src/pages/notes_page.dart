import 'package:flutter/material.dart';
import 'package:sqlite/src/controlles/sqlite_controller.dart';
import 'package:sqlite/src/models/note_model.dart';
import 'package:sqlite/src/models/user_model.dart';

class NotesPage extends StatefulWidget {
  final UserModel user;
  const NotesPage({super.key, required this.user});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<NoteModel> notes = [];
  final SqliteController _sqliteController = SqliteController();

  final TextEditingController _noteEditController = TextEditingController();

  NoteModel? _noteToEdit;

  @override
  void initState() {
    super.initState();
    _sqliteController.initDb().then((_) {
      _getUserNotes();
    });
  }

  _getUserNotes() {
    _sqliteController.getUserNotes(widget.user.id).then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  _deleteNote(int noteId) {
    _sqliteController.deleteNote(noteId).then((value) {
      _getUserNotes();
    });
  }

  _createNote(String text) {
    _sqliteController
        .insertNote(NoteModel(id: -1, text: text, userId: widget.user.id))
        .then((value) {
      _getUserNotes();
    });
  }

  _updateNote(NoteModel note) {
    _sqliteController.updateNote(note).then((value) {
      _getUserNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) => ListTile(
                          subtitle: Text(notes[index].text),
                          onTap: () {
                            //
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _noteToEdit = notes[index];
                                    _noteEditController.text = notes[index].text;
                                    _showNoteBottonSheet();
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _deleteNote(notes[index].id);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ))),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    _showNoteBottonSheet();
                  },
                  child: const Text("Criar nova nota")),
            )
          ],
        ),
      ),
    );
  }

  _showNoteBottonSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                TextField(
                  controller: _noteEditController,
                  decoration: const InputDecoration(labelText: "Nota..."),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_noteToEdit != null) {
                          _updateNote(NoteModel(
                              id: _noteToEdit!.id,
                              text: _noteEditController.text,
                              userId: widget.user.id));
                        } else {
                          _createNote(_noteEditController.text);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Criar")),
                )
              ],
            ),
          );
        }).then((_) {
      _noteToEdit = null;
      _noteEditController.clear();
    });
  }
}
