class PersonDetailsModel {
  final int id;
  final String? knownForDepartment;
  final String? name;
  final String? profilePath;

  PersonDetailsModel({
    required this.id,
    this.knownForDepartment,
    this.name,
    this.profilePath,
  });

  factory PersonDetailsModel.fromJson(Map<String, dynamic> json) => PersonDetailsModel(
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "profile_path": profilePath,
      };
}
