/// Data Model for SuperAdmin Feature
class SuperAdminModel {
  final String? id;
  final String? title;

  SuperAdminModel({
    this.id,
    this.title,
  });

  factory SuperAdminModel.fromJson(Map<String, dynamic> json) {
    return SuperAdminModel(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? json['name'],
    );
  }

  /// Parse a whole JSON list into `List<SuperAdminModel>` safely
  static List<SuperAdminModel> fromJsonList(dynamic jsonList) {
    if (jsonList is! List) return [];
    return jsonList
        .whereType<Map<String, dynamic>>()
        .map(SuperAdminModel.fromJson)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
