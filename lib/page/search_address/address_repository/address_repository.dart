import 'dart:convert';

import 'package:google_map_task/help/constant.dart';
import 'package:http/http.dart' as http;

class AddressRepository {
  AddressRepository();

  Future<dynamic> getPlacesPredictions(
      {String? input, String? sessionToken}) async {
    String kplacesApiKey = AppConstant.googleMapApiKey;
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    Uri url = Uri.parse(
        "$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$sessionToken");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) /*['predictions']*/;
    }
    return response;
  }

  Future<dynamic> getPlacesByPlaceId({String? placeId}) async {
    String kPlacesApiKey = AppConstant.googleMapApiKey;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kPlacesApiKey';

    Uri url = Uri.parse(baseURL);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return response;
  }
}
