class ComponentSubcomponent {
  final int id;
  final int componentId;
  final int subcomponentId;
  int statusId;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentSubcomponent({
    required this.id,
    required this.componentId,
    required this.subcomponentId,
    required this.statusId,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentSubcomponent.fromJson(Map<String, dynamic> json) {
    return ComponentSubcomponent(
      id: json['id'],
      componentId: json['component']['id'], 
      subcomponentId: json['subcomponent']['id'], 
      statusId: json['status']['id'], 
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateComponentSubcomponentDto {
  final int componentId;
  final int subcomponentId;
  final int statusId;

  CreateComponentSubcomponentDto({
    required this.componentId,
    required this.subcomponentId,
    required this.statusId,
  });

  Map<String, dynamic> toJson() {
    return {
      'componentId': componentId,
      'subcomponentId': subcomponentId,
      'statusId': statusId,
    };
  }
}

class UpdateComponentSubcomponentDto {
  final int statusId;

  UpdateComponentSubcomponentDto({
    required this.statusId,
  });

  Map<String, dynamic> toJson() {
    return {
      'statusId': statusId,
    };
  }
}
