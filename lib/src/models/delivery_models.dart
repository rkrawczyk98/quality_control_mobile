class Delivery {
  final int id;
  final String number;
  final CreatedByUserResponseDto createdByUser;
  final ComponentTypeResponseDto componentType;
  final DeliveryStatusResponseDto status;
  final CustomerResponseDto customer;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  Delivery({
    required this.id,
    required this.number,
    required this.createdByUser,
    required this.componentType,
    required this.status,
    required this.customer,
    required this.creationDate,
    required this.deliveryDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      number: json['number'],
      createdByUser: CreatedByUserResponseDto.fromJson(json['createdByUser']),
      componentType: ComponentTypeResponseDto.fromJson(json['componentType']),
      status: DeliveryStatusResponseDto.fromJson(json['status']),
      customer: CustomerResponseDto.fromJson(json['customer']),
      creationDate: DateTime.parse(json['creationDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateDeliveryDto {
  final int componentTypeId;
  final int customerId;
  final String deliveryDate;

  CreateDeliveryDto({required this.componentTypeId, required this.customerId, required this.deliveryDate});

  Map<String, dynamic> toJson() {
    return {
      'componentTypeId': componentTypeId,
      'customerId': customerId,
      'deliveryDate': deliveryDate,
    };
  }
}

class CreatedByUserResponseDto {
  final int id;
  final String username;

  CreatedByUserResponseDto({required this.id, required this.username});

  factory CreatedByUserResponseDto.fromJson(Map<String, dynamic> json) {
    return CreatedByUserResponseDto(id: json['id'], username: json['username']);
  }
}

class ComponentTypeResponseDto {
  final int id;
  final String name;

  ComponentTypeResponseDto({required this.id, required this.name});

  factory ComponentTypeResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentTypeResponseDto(id: json['id'], name: json['name']);
  }
}

class DeliveryStatusResponseDto {
  final int id;
  final String name;

  DeliveryStatusResponseDto({required this.id, required this.name});

  factory DeliveryStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return DeliveryStatusResponseDto(id: json['id'], name: json['name']);
  }
}

class CustomerResponseDto {
  final int id;
  final String name;

  CustomerResponseDto({required this.id, required this.name});

  factory CustomerResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerResponseDto(id: json['id'], name: json['name']);
  }
}
