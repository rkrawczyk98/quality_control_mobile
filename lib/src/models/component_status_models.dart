class ComponentStatus {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentStatus({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentStatus.fromJson(Map<String, dynamic> json) {
    return ComponentStatus(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateComponentStatusDto {
  final String name;

  CreateComponentStatusDto({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class UpdateComponentStatusDto {
  final String? name;

  UpdateComponentStatusDto({
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
