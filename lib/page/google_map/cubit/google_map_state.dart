part of 'google_map_cubit.dart';

class GoogleMapState extends Equatable {
  const GoogleMapState(
      {this.currentLocation,
      this.currentLatLng,
      this.destinationLatLng,
      this.formStatus = FormzSubmissionStatus.initial,
      this.markers = const {},
      this.polylines = const {}});

  final FormzSubmissionStatus? formStatus;
  final String? currentLocation;
  final LatLng? currentLatLng;
  final LatLng? destinationLatLng;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;

  GoogleMapState copyWith(
      {String? currentLocation,
      LatLng? currentLatLng,
      LatLng? destinationLatLng,
      FormzSubmissionStatus? formStatus,
      Set<Marker>? markers,
      Set<Polyline>? polylines}) {
    return GoogleMapState(
      formStatus: formStatus ?? this.formStatus,
      currentLocation: currentLocation ?? this.currentLocation,
      currentLatLng: currentLatLng ?? this.currentLatLng,
      destinationLatLng: destinationLatLng ?? this.destinationLatLng,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }

  @override
  List<Object?> get props => [
        currentLocation,
        markers,
        polylines,
        formStatus,
        currentLatLng,
        destinationLatLng,
      ];
}
