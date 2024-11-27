import 'package:flutter/material.dart';
import 'package:google_map_task/page/google_map/google_map_view.dart';
import 'package:google_map_task/page/search_address/address_selection_new.dart';
import 'package:google_map_task/page/splash.dart';

// This class is using for set route
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    debugPrint(settings.name.toString());
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());

      case '/GoogleMapPage':
        return GoogleMapView.route();

      case "/address_selection_new":
        return AddressSelectionNew.route();

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(
                body: SafeArea(child: Center(child: Text('Route Error')))));
    }
  }
}
