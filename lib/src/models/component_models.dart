class Component {
  final int id;
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final double size;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final User createdByUser;
  final User modifiedByUser;
  final String componentType;
  final ComponentStatus status;
  final Delivery delivery;
  final Warehouse warehouse;
  final WarehousePosition warehousePosition;
  final DateTime? scrappedAt;
  final List<Subcomponent> subcomponents;

  Component({
    required this.id,
    required this.name,
    this.controlDate,
    this.productionDate,
    required this.size,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
    required this.createdByUser,
    required this.modifiedByUser,
    required this.componentType,
    required this.status,
    required this.delivery,
    required this.warehouse,
    required this.warehousePosition,
    this.scrappedAt,
    required this.subcomponents,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json['id'],
      name: json['name'],
      controlDate: json['controlDate'] != null ? DateTime.parse(json['controlDate']) : null,
      productionDate: json['productionDate'] != null ? DateTime.parse(json['productionDate']) : null,
      size: (json['size'] as num).toDouble(),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdByUser: User.fromJson(json['createdByUser']),
      modifiedByUser: User.fromJson(json['modifiedByUser']),
      componentType: json['componentType']['name'],
      status: ComponentStatus.fromJson(json['status']),
      delivery: Delivery.fromJson(json['delivery']),
      warehouse: Warehouse.fromJson(json['warehouse']),
      warehousePosition: WarehousePosition.fromJson(json['warehousePosition']),
      scrappedAt: json['scrappedAt'] != null ? DateTime.parse(json['scrappedAt']) : null,
      subcomponents: (json['componentSubcomponents'] as List)
          .map((e) => Subcomponent.fromJson(e))
          .toList(),
    );
  }
}

class ComponentStatus {
  final int id;
  final String name;

  ComponentStatus({required this.id, required this.name});

  factory ComponentStatus.fromJson(Map<String, dynamic> json) {
    return ComponentStatus(
      id: json['id'],
      name: json['name'],
    );
  }
}

class User {
  final int id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
    );
  }
}

class Delivery {
  final int id;
  final String number;
  final DateTime? deliveryDate;

  Delivery({required this.id, required this.number, required this.deliveryDate});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      number: json['number'],
      deliveryDate: DateTime.parse(json['deliveryDate'])
    );
  }
}

class Warehouse {
  final int id;
  final String name;

  Warehouse({required this.id, required this.name});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      name: json['name'],
    );
  }
}

class WarehousePosition {
  final int id;
  final String name;

  WarehousePosition({required this.id, required this.name});

  factory WarehousePosition.fromJson(Map<String, dynamic> json) {
    return WarehousePosition(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Subcomponent {
  final int id;
  final String name;
  final SubcomponentStatus status;
  final User modifiedByUser; 
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  Subcomponent({
    required this.id,
    required this.name,
    required this.status,
    required this.modifiedByUser,
    required this.creationDate,
    required this.lastModified,
    required this.deletedAt,
  });

  factory Subcomponent.fromJson(Map<String, dynamic> json) {
    return Subcomponent(
      id: json['id'],
      name: json['name'],
      status: SubcomponentStatus.fromJson(json['status']),
      modifiedByUser: User.fromJson(json['modifiedByUser']),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

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
    required this.deletedAt,
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

class CreateComponentDto {
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final int deliveryId;
  final double size;

  CreateComponentDto({
    required this.name,
    this.controlDate,
    this.productionDate,
    required this.deliveryId,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'controlDate': controlDate?.toIso8601String(),
      'productionDate': productionDate?.toIso8601String(),
      'deliveryId': deliveryId,
      'size': size,
    };
  }
}

class UpdateComponentDto {
  final DateTime? productionDate;
  final DateTime? controlDate;
  final DateTime? scrappedAt;
  final int? statusId;

  UpdateComponentDto({
    this.productionDate,
    this.controlDate,
    this.scrappedAt,
    this.statusId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (productionDate != null) 'productionDate': productionDate!.toIso8601String(),
      if (controlDate != null) 'controlDate': controlDate!.toIso8601String(),
      if (scrappedAt != null) 'scrappedAt': scrappedAt!.toIso8601String(),
      if (statusId != null) 'statusId': statusId,
    };
  }
}
