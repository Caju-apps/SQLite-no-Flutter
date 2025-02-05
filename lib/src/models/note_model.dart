class NoteModel {
  final int id;
  final String text;
  final int userId;

  NoteModel({required this.id, required this.text, required this.userId});

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      NoteModel(id: json['id'], text: json['text'], userId: json['userId']);

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'userId': userId};
}
