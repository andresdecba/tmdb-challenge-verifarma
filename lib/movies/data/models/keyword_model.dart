class KeywordModel {
  final int id;
  final String? name;

  KeywordModel({
    required this.id,
    this.name,
  });

  factory KeywordModel.fromJson(Map<String, dynamic> json) => KeywordModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
