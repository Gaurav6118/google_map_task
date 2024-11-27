import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_map_task/help/app_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cubit/search_address_cubit.dart';

class AddressSelectionNew extends StatefulWidget {
  const AddressSelectionNew({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const AddressSelectionNew(),
    );
  }

  @override
  State<AddressSelectionNew> createState() => _AddressSelectionNewState();
}

class _AddressSelectionNewState extends State<AddressSelectionNew> {
  CameraPosition? positionNew = const CameraPosition(target: LatLng(0, 0));

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchAddressCubit, SearchAddressState>(
      listenWhen: (p, c) => p.selectedAddress != c.selectedAddress,
      listener: (context, state) {
        if (state.initialPosition != null) {
          if (state.initialPosition!.latitude != positionNew!.target.latitude ||
              state.initialPosition!.longitude !=
                  positionNew!.target.longitude) {
          } else if (positionNew == null) {}
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back, size: 26)),
          titleSpacing: 0,
          title: Container(
            width: MediaQuery.of(context).size.width * 0.80,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              readOnly: true,
              onTap: () {
                seeLocationDetailSheet();
              },
              onChanged: (text) {},
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Search address',
                prefixIconColor: Colors.black,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(top: 0, left: 16, right: 10, bottom: 12),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<SearchAddressCubit, SearchAddressState>(
            builder: (context, state) {
              return state.status!.isInProgress
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors().accentColor(1),
                      ),
                    )
                  : Stack(
                      children: [
                        state.initialPosition != null
                            ? GoogleMap(
                                onCameraIdle: () {
                                  debugPrint(
                                      "onCameraIdle ${positionNew!.target.longitude} ${positionNew!.target.latitude}");
                                  if (positionNew != null) {
                                    context
                                        .read<SearchAddressCubit>()
                                        .onMapDragConvertLatLngToAddress(
                                          lng: positionNew!.target.longitude,
                                          lat: positionNew!.target.latitude,
                                        );
                                  }
                                },
                                markers: Set<Marker>.of(state.markers),
                                mapType: MapType.normal,
                                onCameraMove: ((position) {
                                  positionNew = position;
                                }),
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      state.initialPosition!.latitude,
                                      state.initialPosition!.longitude),
                                  zoom: 18.0,
                                ),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: false,
                                onMapCreated: (controller) {
                                  // mapController=controller;
                                  context
                                      .read<SearchAddressCubit>()
                                      .initialiseMapController(
                                          mapControllerI: controller);
                                },
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: AppConfig(context).appHeight(9)),
                            child: Icon(Icons.location_on_sharp,
                                size: AppConfig(context).appHeight(6)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      AppConfig(context).appHeight(1)),
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<SearchAddressCubit>()
                                          .getUserLocation(
                                              isUpdate: false, isFromMap: true);
                                    },
                                    child: Container(
                                      width: AppConfig(context).appHeight(25),
                                      padding: const EdgeInsets.all(2),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors().accentColor(1),
                                              width: 2),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.my_location,
                                            size: AppConfig(context)
                                                .appHeight(2.5),
                                            color: AppColors().accentColor(1),
                                          ),
                                          Text(
                                            'Current Location',
                                            style: TextStyle(
                                                fontFamily: 'Tahoma',
                                                fontSize: AppConfig(context)
                                                    .appWidth(4.0),
                                                color:
                                                    AppColors().accentColor(1),
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: AppColors().accentColor(1),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: AppConfig(context).appHeight(1),
                                      bottom: AppConfig(context).appHeight(3),
                                      left: AppConfig(context).appWidth(5),
                                      right: AppConfig(context).appWidth(5)),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height:
                                              AppConfig(context).appHeight(2),
                                        ),
                                        Text(
                                          'Your Location',
                                          style: TextStyle(
                                              fontSize: AppConfig(context)
                                                  .appWidth(4.5),
                                              color: AppColors().accentColor(1),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height:
                                              AppConfig(context).appHeight(2),
                                        ),
                                        Text(
                                          state.selectedAddress != null
                                              ? state.selectedAddress![
                                                      "primaryText"]
                                                  .toString()
                                              : "",
                                          style: TextStyle(
                                              fontFamily: 'Tahoma',
                                              fontSize: AppConfig(context)
                                                  .appWidth(3.5),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height:
                                              AppConfig(context).appHeight(3),
                                        ),
                                        Center(
                                          child: InkWell(
                                            onTap: () {
                                              if (state.selectedAddress !=
                                                      null &&
                                                  state.selectedAddress![
                                                          "primaryText"] !=
                                                      "") {
                                                context
                                                    .read<SearchAddressCubit>()
                                                    .onSelectedAddress(
                                                        state.selectedAddress!);
                                              }
                                            },
                                            child: Container(
                                              height: AppConfig(context)
                                                  .appHeight(6),
                                              width: AppConfig(context)
                                                  .appWidth(80),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppConfig(context)
                                                            .appHeight(1)),
                                                color: Colors.white,
                                              ),
                                              alignment: Alignment.center,
                                              child: state.checkAddressStatus
                                                      .isInProgress
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                      color: AppColors()
                                                          .accentColor(1),
                                                    ))
                                                  : Text(
                                                      'Confirm location',
                                                      style: TextStyle(
                                                          fontSize: AppConfig(
                                                                  context)
                                                              .appWidth(4.5),
                                                          color: AppColors()
                                                              .accentColor(1),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  seeLocationDetailSheet({LatLng? latLng}) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConfig(context).appHeight(2)),
            topRight: Radius.circular(AppConfig(context).appHeight(2))),
      ),
      context: context,
      builder: (context) {
        return BlocBuilder<SearchAddressCubit, SearchAddressState>(
          builder: (context, state) {
            return SizedBox(
              height: AppConfig(context).appHeight(80),
              child: Padding(
                padding: EdgeInsets.only(
                    top: AppConfig(context).appHeight(1),
                    bottom: AppConfig(context).appHeight(3),
                    left: AppConfig(context).appWidth(5),
                    right: AppConfig(context).appWidth(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 36,
                      decoration: BoxDecoration(
                        //    color: AppColors().colorPrimary(1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        onChanged: (text) {
                          context.read<SearchAddressCubit>().searchPlaces(text);
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors().accentColor(1),
                            size: AppConfig(context).appHeight(4),
                          ),
                          hintText: 'Search address',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              top: 0, left: 16, right: 0, bottom: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppConfig(context).appHeight(2),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.placeList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      context
                                          .read<SearchAddressCubit>()
                                          .onSelectedAddressNew(
                                            selectedPrediction:
                                                state.placeList[index],
                                          );
                                      Navigator.of(context).pop();
                                    },
                                    horizontalTitleGap: 6,
                                    leading: Container(
                                        height: 40,
                                        width: 40,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 0),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: AppColors().accentColor(1),
                                        )),
                                    minLeadingWidth: 0,
                                    title: Text(
                                      // "1100 Congress Avenue",
                                      state.placeList[index]["primaryText"] ??
                                          "",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      state.placeList[index]["fullText"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14),
                                    ),
                                  );
                                }),
                            state.recentPlaceList.isNotEmpty
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 12, top: 16),
                                      child: const Text(
                                        'Recent Addresses',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto-Regular",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 16,
                            ),
                            ListView.builder(
                                itemCount: state.recentPlaceList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      context
                                          .read<SearchAddressCubit>()
                                          .onSelectedAddressNew(
                                            selectedPrediction:
                                                state.recentPlaceList[index],
                                          );
                                      Navigator.of(context).pop();
                                    },
                                    horizontalTitleGap: 6,
                                    leading: Container(
                                        height: 40,
                                        width: 40,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 0),
                                        child: const Icon(Icons.location_on)),
                                    minLeadingWidth: 0,
                                    title: Text(
                                      // "1100 Congress Avenue",
                                      state.recentPlaceList[index]
                                          ["primaryText"],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      state.recentPlaceList[index]["fullText"],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto-Regular",
                                          fontSize: 14),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
