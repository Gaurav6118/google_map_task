import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_task/app.dart';
import 'package:google_map_task/help/constant.dart';
import 'package:google_map_task/help/helper.dart';
import 'package:google_map_task/page/search_address/address_repository/address_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart' as loc;
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

part 'search_address_state.dart';

class SearchAddressCubit extends Cubit<SearchAddressState> {
  SearchAddressCubit(this.addressRepository)
      : super(const SearchAddressState());

  resetSelectedAddress() {
    emit(state.copyWith(selectedAddress: ""));
  }

  var uuid = const Uuid();
  AddressRepository addressRepository;

  Future<void> searchPlaces(String s) async {
    try {
      if (s.isNotEmpty) {
        final response = await addressRepository.getPlacesPredictions(
            input: s, sessionToken: uuid.v4());
        List<dynamic> data = (response["predictions"] as List<dynamic>)
            .map((e) => {
                  "placeId": e["place_id"],
                  "primaryText": e["structured_formatting"]["main_text"],
                  "fullText": e["description"],
                  "secondaryText": e["structured_formatting"]["secondary_text"],
                })
            .toList();
        emit(state.copyWith(placeList: data));
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  onSelectedAddressNew({
    dynamic selectedPrediction,
  }) async {
    dynamic response = await addressRepository.getPlacesByPlaceId(
        placeId: selectedPrediction!["placeId"]);

    emit(state.copyWith(
        selectedAddress: selectedPrediction,
        initialPosition: gmaps.LatLng(
            response["result"]["geometry"]["location"]["lat"],
            response["result"]["geometry"]["location"]["lng"])));

    mapController!.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
        gmaps.LatLng(response["result"]["geometry"]["location"]["lat"],
            response["result"]["geometry"]["location"]["lng"]),
        18));
  }

  gmaps.GoogleMapController? mapController;

  initialiseMapController({gmaps.GoogleMapController? mapControllerI}) {
    mapController = mapControllerI;
  }

  onMapDragConvertLatLngToAddress({double? lat, double? lng, bool? isUpdate}) {
    emit(state.copyWith(initialPosition: gmaps.LatLng(lat!, lng!)));
    loc.GoogleMapsGeocoding(
      apiKey: AppConstant.googleMapApiKey,
    ).searchByLocation(loc.Location(lat: lat, lng: lng)).then((value) {
      if (value.results.isNotEmpty) {
        dynamic data = {};
        data["placeId"] = value.results[0].placeId;
        data["primaryText"] = value.results[0].formattedAddress;
        data["secondaryText"] = value.results[0].formattedAddress!;
        data["fullText"] = value.results[0].formattedAddress;

        emit(state.copyWith(
          selectedAddress: data,
        ));
      }
    });
  }

  Future onSelectedAddress(dynamic selectedPrediction,
      {bool? isUpdate = true}) async {
    var response = await addressRepository.getPlacesByPlaceId(
        placeId: selectedPrediction!["placeId"]);

    Map<String, dynamic> geoHashMap;
    geoHashMap = {
      "lat": response["result"]["geometry"]["location"]["lat"],
      "lng": response["result"]["geometry"]["location"]["lng"]
    };

    if (isUpdate!) {
      getAddressFromLatLng(lat: geoHashMap['lat'], lng: geoHashMap['lng']);
    }
  }

  Future<bool?> getUserLocation(
      {bool? isUpdate, bool? isFromMap = false}) async {
    if (await location.Location().serviceEnabled()) {
      var granted1 = await Permission.location.isGranted;
      var granted2 = await Permission.locationAlways.isGranted;
      var granted3 = await Permission.locationWhenInUse.isGranted;

      debugPrint('$granted3  $granted2 $granted1');

      if (granted1 || granted2 || granted3) {
        await Geolocator.getCurrentPosition().then((currLocation) {
          var currentLatLng =
              gmaps.LatLng(currLocation.latitude, currLocation.longitude);

          debugPrint(
              'current_location ${currentLatLng.latitude} ${currentLatLng.longitude}');

          convertLatLngToAddress(
              lng: currentLatLng.latitude,
              lat: currentLatLng.longitude,
              isUpdate: isUpdate);
          if (isFromMap!) {
            mapController!.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
                gmaps.LatLng(currentLatLng.latitude, currentLatLng.longitude),
                18));
          }
        });
      } else {
        if (await Permission.location.isPermanentlyDenied) {
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          debugPrint('openAppSettings AuthBloc');

          if (Platform.isAndroid) {
            Helper.showToast('Please enable location');
            openAppSettings();
          } else if (Platform.isIOS) {
            // OpenSettings.openLocationSourceSetting();
            Helper.showToast('Please enable location');
          }
        } else if (await Permission.location.isDenied) {
          requestLocationPermission();
        }
      }
    } else {
      debugPrint('getUserLocation ');
      await Geolocator.openLocationSettings();
    }
    return null;
  }

  requestLocationPermission() async {
    debugPrint("request service");
    await Geolocator.requestPermission().then((value) {
      // debugPrint("requestPermission ${value}");
      if (value.name == "deniedForever") {
        debugPrint("inside deniedForever");
        if (Platform.isAndroid) {
          Helper.showToast('Please enable location');
          openAppSettings();
        } else if (Platform.isIOS) {
          // OpenSettings.openLocationSourceSetting();
          Helper.showToast('Please enable location');
        }
        return;
      } else {
        debugPrint(value.name);
      }

      getUserLocation(isUpdate: false);
    });
  }

  Future<void> convertLatLngToAddress(
      {double? lat, double? lng, bool? isUpdate}) async {
    loc.GoogleMapsGeocoding(
      apiKey: AppConstant.googleMapApiKey,
    ).searchByLocation(loc.Location(lat: lat!, lng: lng!)).then((value) {
      emit(state.copyWith(initialPosition: gmaps.LatLng(lat, lng)));
      if (value.results.isNotEmpty) {
        onSelectedAddress({
          "placeId": value.results[0].placeId,
          "primaryText": value.results[0].formattedAddress!,
          "secondaryText": value.results[0].formattedAddress!,
          "fullText": value.results[0].formattedAddress!,
        }, isUpdate: isUpdate);
      }
    });
  }

  Future<void> getAddressFromLatLng({double? lat, double? lng}) async {
    await placemarkFromCoordinates(lat!, lng!)
        .then((List<Placemark> placeMarks) async {
      Placemark place = placeMarks[0];

      Map<String, String> map = {};

      map['street'] =
          '${place.street}, ${place.subLocality}, ${place.locality}';
      map['city'] = place.locality.toString();
      map['zipCode'] = place.postalCode.toString();
      map['latitude'] = lat.toString();
      map['longitude'] = lng.toString();
      navigatorKey.currentState!.pop(map);
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
