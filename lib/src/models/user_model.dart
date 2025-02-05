class UserModel {
  final int id;
  final String name;

  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
