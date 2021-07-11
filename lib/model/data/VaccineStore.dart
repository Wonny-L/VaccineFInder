

import 'package:vaccine_finder/model/data/VaccineQuantity.dart';

class VaccineStore {
  final String id;
  final String name;
  final String phone;
  final String distance;
  final String commonAddress;
  final String roadAddress;
  final String address;
  final String? imageUrl;
  final String routeUrl;
  final String x;
  final String y;
  final VaccineQuantity? vaccineQuantity;

  VaccineStore(
      this.id,
      this.name,
      this.phone,
      this.distance,
      this.commonAddress,
      this.roadAddress,
      this.address,
      this.imageUrl,
      this.routeUrl,
      this.x,
      this.y,
      this.vaccineQuantity
      );

  factory VaccineStore.fromJson(dynamic json) {
    VaccineQuantity? vaccineQuantity;
    if(json['vaccineQuantity'] != null && json['vaccineQuantity']['quantity'] != null) {
      vaccineQuantity = VaccineQuantity.fromJson(json['vaccineQuantity']);
    }

    return VaccineStore(
      json['id'],
      json['name'],
      json['phone'],
      json['distance'],
      json['commonAddress'],
      json['roadAddress'],
      json['address'],
      json['imageUrl'],
      json['routeUrl'],
      json['x'],
      json['y'],
      vaccineQuantity,
    );
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.name}, ${this.phone}, ${this.distance}, ${this.commonAddress}, ${this.roadAddress}, ${this.address}, ${this.imageUrl}, ${this.routeUrl}, ${this.x}, ${this.y}, ${this.vaccineQuantity} }';
  }
}