class SubcomponentStatus {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  SubcomponentStatus({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory SubcomponentStatus.fromJson(Map<String, dynamic> json) {
    return SubcomponentStatus(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateSubcomponentStatusDto {
  final String name;

  CreateSubcomponentStatusDto({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class UpdateSubcomponentStatusDto {
  final String? name;

  UpdateSubcomponentStatusDto({
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
