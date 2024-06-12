// component_models.dart

class Component {
  final int id;
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final double size;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  Component({
    required this.id,
    required this.name,
    this.controlDate,
    this.productionDate,
    required this.size,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json['id'],
      name: json['name'],
      controlDate: json['controlDate'] != null ? DateTime.parse(json['controlDate']) : null,
      productionDate: json['productionDate'] != null ? DateTime.parse(json['productionDate']) : null,
      size: json['size']?.toDouble(),
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
