import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:formz/formz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_task/help/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit() : super(const GoogleMapState()) {
    checkPermission();
  }

  void checkPermission() async {
    emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
    await Geolocator.requestPermission();
    getCurrentLocation();
  }

  final directions.GoogleMapsDirections _direction =
      directions.GoogleMapsDirections(apiKey: AppConstant.googleMapApiKey);

  // get current location
  void getCurrentLocation() async {
    if (await location.Location().serviceEnabled() ||
        await Permission.location.isGranted) {
      await Geolocator.getCurrentPosition().then((currLocation) {
        emit(state.copyWith(
            formStatus: FormzSubmissionStatus.success,
            currentLatLng:
                LatLng(currLocation.latitude, currLocation.longitude)));

        getAddressFromLatLng(
            lat: currLocation.latitude, lng: currLocation.longitude);
      });
    } else {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.canceled));
    }
  }

  setCurrentLatLng({double? latitude, double? longitude}) {
    emit(state.copyWith(markers: {}, polylines: {}, destinationLatLng: null));

    // Create a new Marker
    final Marker currentMarker = Marker(
      markerId: const MarkerId('current'),
      position: LatLng(latitude!, longitude!),
      infoWindow: const InfoWindow(title: 'Current Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    // Add the new Marker to the existing set of markers
    final updatedMarkers = Set<Marker>.from(state.markers ?? {});
    updatedMarkers.add(currentMarker);

    emit(state.copyWith(
        currentLatLng: LatLng(latitude, longitude), markers: updatedMarkers));
  }

  setDestinationLatLng({double? latitude, double? longitude}) {
    // Create a new Marker
    final Marker currentMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(latitude!, longitude!),
      infoWindow: const InfoWindow(title: 'Destination Location'),
    );

    // Add the new Marker to the existing set of markers
    final updatedMarkers = Set<Marker>.from(state.markers ?? {});
    updatedMarkers.add(currentMarker);

    emit(state.copyWith(
        destinationLatLng: LatLng(latitude, longitude),
        markers: updatedMarkers));

    drawPolyline();
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

      emit(state.copyWith(
          currentLocation:
              "${map['street']}, ${map['city']}, ${map['zipCode']}"));
      setCurrentLatLng(latitude: lat, longitude: lng);
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> drawPolyline() async {
    if (state.currentLatLng == null || state.destinationLatLng == null) return;

    final directionsResponse = await _direction.directionsWithLocation(
      directions.Location(
        lat: state.currentLatLng!.latitude,
        lng: state.currentLatLng!.longitude,
      ),
      directions.Location(
        lat: state.destinationLatLng!.latitude,
        lng: state.destinationLatLng!.longitude,
      ),
    );

    if (directionsResponse.isOkay) {
      final route = directionsResponse.routes[0];
      final polylinePoints =
          PolylinePoints().decodePolyline(route.overviewPolyline.points);

      // Convert to a list of LatLng points
      final List<LatLng> latLngPoints = polylinePoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Create a new polyline
      final Polyline polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: latLngPoints,
        color: Colors.blue,
        width: 5,
      );

      // Create a new set of polylines and add the new polyline
      final updatedPolylines = Set<Polyline>.from(state.polylines ?? {});
      updatedPolylines.add(polyline);

      // Emit the new state with updated polylines
      emit(state.copyWith(polylines: updatedPolylines));
    }
  }

  void clearData() {
    emit(state.copyWith(
        currentLatLng: null,
        destinationLatLng: null,
        markers: {},
        polylines: {}));
  }
}
