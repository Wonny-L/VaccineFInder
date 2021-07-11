
import 'package:vaccine_finder/model/data/VaccineStore.dart';

class VaccineResult {
  final int total;
  final String vaccineLastSave;
  final List<VaccineStore> items;

  VaccineResult(this.total, this.vaccineLastSave, this.items);

  factory VaccineResult.fromJson(dynamic json) {
    var objItems = json['items'] as List;
    List<VaccineStore> _items = objItems.map((item) => VaccineStore.fromJson(item)).toList();

    return VaccineResult(
        json['total'],
        json['vaccineLastSave'].toString(),
        _items
    );
  }

  @override
  String toString() {
    return '{ ${this.total}, ${this.vaccineLastSave}, ${this.items} }';
  }
}