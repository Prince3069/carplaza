// PAYMENT METHOD MODEL
class PaymentMethod {
  final String id;
  final String type;
  final String lastFour;
  final String brand;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.brand,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'lastFour': lastFour,
      'brand': brand,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      type: map['type'] ?? 'card',
      lastFour: map['lastFour'] ?? '',
      brand: map['brand'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}
