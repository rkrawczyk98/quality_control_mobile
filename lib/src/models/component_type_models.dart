class ComponentType {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentType({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentType.fromJson(Map<String, dynamic> json) {
    return ComponentType(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateComponentTypeDto {
  final String name;

  CreateComponentTypeDto({required this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class UpdateComponentTypeDto {
  final String? name;

  UpdateComponentTypeDto({this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class DeleteComponentTypeDto {
  final int id;

  DeleteComponentTypeDto({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
