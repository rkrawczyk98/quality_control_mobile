class Customer {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final List<Delivery>? deliveries;

  Customer({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deliveries,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deliveries: json['deliveries'] != null
          ? (json['deliveries'] as List).map((i) => Delivery.fromJson(i)).toList()
          : null,
    );
  }
}

class Delivery {
  final int id;
  final String number;
  final DateTime deliveryDate;
  final DateTime creationDate;
  final DateTime lastModified;

  Delivery({
    required this.id,
    required this.number,
    required this.deliveryDate,
    required this.creationDate,
    required this.lastModified,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      number: json['number'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

class CreateCustomerDto {
  final String name;

  CreateCustomerDto({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class UpdateCustomerDto {
  final String? name;

  UpdateCustomerDto({this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class DeleteCustomerDto {
  final int id;

  DeleteCustomerDto({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
