class FolderModel {
  final String id;
  final String name;

  const FolderModel({
    required this.id,
    required this.name,
  });

  factory FolderModel.fromMap(Map<dynamic, dynamic> map) {
    return FolderModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
