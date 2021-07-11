
class VaccineQuantity {
  late int quantity;
  String? quantityStatus;
  String? vaccineType;
  String? vaccineOrganizationCode;
  String? updateTime;

  VaccineQuantity(this.quantity, this.quantityStatus, this.vaccineType, this.vaccineOrganizationCode);

  VaccineQuantity.fromRaw(int quantity, String updateTime) {
    this.quantity = quantity;
    this.updateTime = updateTime;
  }

  factory VaccineQuantity.fromJson(dynamic json) {
    return VaccineQuantity(
        int.parse(json['quantity']),
        json['quantityStatus'],
        json['vaccineType'],
        json['vaccineOrganizationCode'],
    );
  }

  @override
  String toString() {
    return '{ ${this.quantity}, ${this.quantityStatus}, ${this.vaccineType}, ${this.vaccineOrganizationCode} }';
  }
}