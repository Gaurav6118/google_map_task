part of 'search_address_cubit.dart';

class SearchAddressState extends Equatable {
  const SearchAddressState({
    this.placeList = const [],
    this.recentPlaceList = const [],
    this.selectedAddress,
    this.geoHashmap,
    this.initialPosition,
    this.status = FormzSubmissionStatus.initial,
    this.checkAddressStatus = FormzSubmissionStatus.initial,
    this.address = '',
    this.markers = const [],
  });

  final List<dynamic> placeList;
  final List<dynamic> recentPlaceList;
  final dynamic selectedAddress;
  final Map<String, dynamic>? geoHashmap;
  final LatLng? initialPosition;
  final FormzSubmissionStatus? status;
  final FormzSubmissionStatus checkAddressStatus;
  final String? address;
  final List<gmaps.Marker> markers;

  SearchAddressState copyWith({
    List<dynamic>? placeList,
    Map<String, dynamic>? geoHashmap,
    List<dynamic>? recentPlaceList,
    dynamic selectedAddress,
    LatLng? initialPosition,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? checkAddressStatus,
    String? address,
    List<gmaps.Marker>? markers,
  }) {
    return SearchAddressState(
      geoHashmap: geoHashmap ?? this.geoHashmap,
      placeList: placeList ?? this.placeList,
      recentPlaceList: recentPlaceList ?? this.recentPlaceList,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      initialPosition: initialPosition ?? this.initialPosition,
      status: status ?? this.status,
      address: address ?? this.address,
      checkAddressStatus: checkAddressStatus ?? this.checkAddressStatus,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object?> get props => [
        geoHashmap,
        placeList,
        recentPlaceList,
        selectedAddress,
        checkAddressStatus,
        initialPosition,
        status,
        address,
        markers
      ];
}
