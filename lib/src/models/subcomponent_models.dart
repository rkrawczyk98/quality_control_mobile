class Subcomponent {
  final int id;
  final String name;
  final ComponentType componentType;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  Subcomponent({
    required this.id,
    required this.name,
    required this.componentType,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory Subcomponent.fromJson(Map<String, dynamic> json) {
    return Subcomponent(
      id: json['id'],
      name: json['name'],
      componentType: ComponentType.fromJson(json['componentType'] as Map<String, dynamic>),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

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

class CreateSubcomponentDto {
  final String name;
  final int componentTypeId;

  CreateSubcomponentDto({
    required this.name,
    required this.componentTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'componentTypeId': componentTypeId,
    };
  }
}

class UpdateSubcomponentDto {
  final String? name;
  final int? componentTypeId;

  UpdateSubcomponentDto({
    this.name,
    this.componentTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'componentTypeId': componentTypeId,
    };
  }
}
