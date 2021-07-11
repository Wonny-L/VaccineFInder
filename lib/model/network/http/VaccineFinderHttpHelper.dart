import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vaccine_finder/model/data/VaccineQuantity.dart';
import 'package:vaccine_finder/model/data/VaccineResult.dart';
import 'package:vaccine_finder/model/data/VaccineStore.dart';

import '../../../NotificationHelper.dart';

class VaccineFinderHttpHelper {
  static final VaccineFinderHttpHelper _vaccineFinderHelper = VaccineFinderHttpHelper._internal();

  factory VaccineFinderHttpHelper() => _vaccineFinderHelper;

  VaccineFinderHttpHelper._internal();

  static const url = 'https://api.place.naver.com/graphql';
  static const header = {'content-type': 'application/json'};

  // max = 100
  static const query = r'[{"operationName":"vaccineList","variables":{"input":{"keyword":"코로나백신위탁의료기관","x":"Longitude","y":"Latitude"},"businessesInput":{"start":0,"display":100,"deviceType":"mobile","x":"Longitude","y":"Latitude","sortingOrder":"distance"},"isNmap":false,"isBounds":false},"query":"query vaccineList($input: RestsInput, $businessesInput: RestsBusinessesInput, $isNmap: Boolean!, $isBounds: Boolean!) {\n  rests(input: $input) {\n    businesses(input: $businessesInput) {\n      total\n      vaccineLastSave\n      isUpdateDelayed\n      items {\n        id\n        name\n        dbType\n        phone\n        virtualPhone\n        hasBooking\n        hasNPay\n        bookingReviewCount\n        description\n        distance\n        commonAddress\n        roadAddress\n        address\n        imageUrl\n        imageCount\n        tags\n        distance\n        promotionTitle\n        category\n        routeUrl\n        businessHours\n        x\n        y\n        imageMarker @include(if: $isNmap) {\n          marker\n          markerSelected\n          __typename\n        }\n        markerLabel @include(if: $isNmap) {\n          text\n          style\n          __typename\n        }\n        isDelivery\n        isTakeOut\n        isPreOrder\n        isTableOrder\n        naverBookingCategory\n        bookingDisplayName\n        bookingBusinessId\n        bookingVisitId\n        bookingPickupId\n        vaccineQuantity {\n          quantity\n          quantityStatus\n          vaccineType\n          vaccineOrganizationCode\n          __typename\n        }\n        __typename\n      }\n      optionsForMap @include(if: $isBounds) {\n        maxZoom\n        minZoom\n        includeMyLocation\n        maxIncludePoiCount\n        center\n        __typename\n      }\n      __typename\n    }\n    queryResult {\n      keyword\n      vaccineFilter\n      categories\n      region\n      isBrandList\n      filterBooking\n      hasNearQuery\n      isPublicMask\n      __typename\n    }\n    __typename\n  }\n}\n"}]';

  String getQuery(String lat, String long) {
    return query.replaceAll('Latitude', lat).replaceAll('Longitude', long);
  }

  // '37.39477329384583', '127.1114569883597'
  Future<VaccineQuantity> getAvailableVaccines(String lat, String long) async {
    http.Response response = await http.post(
        Uri.parse(url),
        headers: header,
        body: getQuery(lat, lat),
        encoding: Encoding.getByName("UTF-8"));

    // print(json.decode(utf8.decode(response.bodyBytes))[0]["data"]["rests"]);
    final vaccineResult =  VaccineResult.fromJson(json.decode(utf8.decode(response.bodyBytes))[0]["data"]["rests"]["businesses"]);

    // print(utf8.decode(response.bodyBytes));
    // print(vaccineResult);
    // print(vaccineResult.items.length);
    var count = 0;
    vaccineResult.items.forEach((item) {
      if(item.vaccineQuantity != null && item.vaccineQuantity!.quantity > 0) {
        count += item.vaccineQuantity!.quantity;

        NotificationHelper().showNotification('vaccine find! ${item.name} \n address: ${item.address}');
      }
    });

    // print(utf8.decode(response.bodyBytes));
    return VaccineQuantity.fromRaw(count, vaccineResult.vaccineLastSave);
  }
}
