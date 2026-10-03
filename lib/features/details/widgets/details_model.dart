class DetailsModel {
  final String id;
  final String name;
  final String description;
  final String link;

  const DetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
  });

  factory DetailsModel.fromMap(
    Map<dynamic, dynamic> map, {
    required String fallbackId,
  }) {
    return DetailsModel(
      id: map['id']?.toString().isNotEmpty == true
          ? map['id'].toString()
          : fallbackId,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      link: map['link']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'link': link,
      };
}
