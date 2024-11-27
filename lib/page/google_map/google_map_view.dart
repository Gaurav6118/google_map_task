import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_map_task/help/app_config.dart';
import 'package:google_map_task/help/helper.dart';
import 'package:google_map_task/page/google_map/cubit/google_map_cubit.dart';
import 'package:google_map_task/page/search_address/cubit/search_address_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => GoogleMapCubit(),
        child: const GoogleMapView(),
      ),
    );
  }

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  GoogleMapController? mapController;
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Polygon'),
      ),
      body: BlocBuilder<GoogleMapCubit, GoogleMapState>(
          builder: (context, state) {
        if (state.formStatus!.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.formStatus!.isSuccess) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: state.currentLatLng!,
                  zoom: 14.0,
                ),
                markers: state.markers!,
                polylines: state.polylines!,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: AppConfig(context).appWidth(100),
                      height: AppConfig(context).appHeight(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: AppConfig(context).appWidth(80),
                            child: TextField(
                              controller: currentLocationController,
                              readOnly: true,
                              onTap: () async {
                                if (await Permission.location.isDenied ||
                                    await Permission
                                        .location.isPermanentlyDenied) {
                                  context
                                      .read<SearchAddressCubit>()
                                      .requestLocationPermission();
                                } else {
                                  Navigator.of(context)
                                      .pushNamed('/address_selection_new')
                                      .then((value) async {
                                    if (value != null) {
                                      var map = value as Map<String, dynamic>;

                                      var latitude = map['latitude'];
                                      var longitude = map['longitude'];

                                      context
                                          .read<GoogleMapCubit>()
                                          .setCurrentLatLng(
                                              latitude: double.parse(latitude),
                                              longitude:
                                                  double.parse(longitude));
                                      currentLocationController.text =
                                          "${map['street']}, ${map['city']}, ${map['zipCode']}";
                                      destinationLocationController.text = "";
                                    }
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                hintText:
                                    "Enter location or use current location",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: const Icon(Icons.my_location,
                                  color: Colors.blue),
                              onPressed: () {
                                if (context
                                        .read<GoogleMapCubit>()
                                        .state
                                        .currentLatLng !=
                                    null) {
                                  mapController!.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                          context
                                              .read<GoogleMapCubit>()
                                              .state
                                              .currentLatLng!,
                                          14));

                                  context
                                      .read<GoogleMapCubit>()
                                      .getAddressFromLatLng(
                                          lat: state.currentLatLng!.latitude,
                                          lng: state.currentLatLng!.longitude);

                                  currentLocationController.text =
                                      state.currentLocation ?? '';
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: AppConfig(context).appWidth(100),
                      height: AppConfig(context).appHeight(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: destinationLocationController,
                        readOnly: true,
                        onTap: () async {
                          if (currentLocationController.text.isNotEmpty) {
                            if (await Permission.location.isDenied ||
                                await Permission.location.isPermanentlyDenied) {
                              context
                                  .read<SearchAddressCubit>()
                                  .requestLocationPermission();
                            } else {
                              Navigator.of(context)
                                  .pushNamed('/address_selection_new')
                                  .then((value) async {
                                if (value != null) {
                                  var map = value as Map<String, dynamic>;

                                  var latitude = map['latitude'];
                                  var longitude = map['longitude'];

                                  context
                                      .read<GoogleMapCubit>()
                                      .setDestinationLatLng(
                                          latitude: double.parse(latitude),
                                          longitude: double.parse(longitude));
                                  destinationLocationController.text =
                                      "${map['street']}, ${map['city']}, ${map['zipCode']}";

                                  // Zoom to fit polyline
                                  LatLngBounds bounds = LatLngBounds(
                                    southwest: LatLng(
                                      min(state.currentLatLng!.latitude,
                                          state.destinationLatLng!.latitude),
                                      min(state.currentLatLng!.longitude,
                                          state.destinationLatLng!.longitude),
                                    ),
                                    northeast: LatLng(
                                      max(state.currentLatLng!.latitude,
                                          state.destinationLatLng!.latitude),
                                      max(state.currentLatLng!.longitude,
                                          state.destinationLatLng!.longitude),
                                    ),
                                  );
                                  mapController!.animateCamera(
                                    CameraUpdate.newLatLngBounds(
                                        bounds, 14), // Adjust padding as needed
                                  );
                                }
                              });
                            }
                          } else {
                            Helper.showToast(
                                "Please select current address first");
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "Enter destination",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(child: Text("Unable to fetch location."));
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AppConfig(context).appHeight(2.5)),
        child: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: const Icon(Icons.refresh),
          onPressed: () {
            currentLocationController.text = "";
            destinationLocationController.text = "";
            context.read<GoogleMapCubit>().clearData();
          },
        ),
      ),
    );
  }
}
