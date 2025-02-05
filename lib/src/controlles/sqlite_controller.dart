import 'package:sqflite/sqflite.dart';
import 'package:sqlite/src/models/note_model.dart';
import 'package:sqlite/src/models/user_model.dart';

class SqliteController {
  late final Database _db;

  Future<void> initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/demo.db';

    _db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE User (id INTEGER PRIMARY KEY, name TEXT)');
      await db.execute(
          'CREATE TABLE Note (id INTEGER PRIMARY KEY, text TEXT, userId INTEGER, FOREIGN KEY (userId) REFERENCES User(id))');
    });
  }

  Future<void> insertUser(UserModel user) async {
    await _db.insert("User", {'name': user.name});
    printDatabase();
  }

  Future<void> insertNote(NoteModel note) async {
    await _db.insert('Note', {'text': note.text, 'userId': note.userId});
    printDatabase();
  }

  Future<List<UserModel>> getUsers() async {
    List<Map<String, dynamic>> users = await _db.query('User');
    printDatabase();
    return users.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<List<NoteModel>> getUserNotes(int userId) async {
    // SELECT * FROM Note WHERE userId = userId
    List<Map<String, dynamic>> notes =
        await _db.query('Note', where: 'userId = ?', whereArgs: [userId]);
    printDatabase();
    return notes.map((note) => NoteModel.fromJson(note)).toList();
  }

  Future<void> deleteUser(int userId) async {
    await _db.delete('User', where: 'id = ?', whereArgs: [userId]);
    await _db.delete('Note', where: 'userId = ?', whereArgs: [userId]);
    printDatabase();
  }

  Future<void> deleteNote(int noteId) async {
    await _db.delete('Note', where: 'id = ?', whereArgs: [noteId]);
    printDatabase();
  }

  Future<void> updateUser(UserModel user) async {
    await _db.update('User', {'name': user.name}, where: 'id = ?', whereArgs: [user.id]);
    printDatabase();
  }

  Future<void> updateNote(NoteModel note) async {
    await _db.update('Note', {'text': note.text}, where: 'id = ?', whereArgs: [note.id]);
    printDatabase();
  }

  Future<void> printDatabase() async {
    // Consultar todos os usuários
    List<Map<String, dynamic>> users = await _db.query('User');

    // Consultar todas as notas
    List<Map<String, dynamic>> notes = await _db.query('Note');

    // Imprimir os usuários
    print('--- Users ---');
    for (var user in users) {
      print('ID: ${user['id']}, Name: ${user['name']}');
    }

    // Imprimir as notas
    print('--- Notes ---');
    for (var note in notes) {
      print('ID: ${note['id']}, Text: ${note['text']}, User ID: ${note['userId']}');
    }
  }
}
