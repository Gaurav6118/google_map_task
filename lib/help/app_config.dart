import 'package:flutter/material.dart';

// This class is used for height/width using MediaQuery
class AppConfig {
  late BuildContext _context;
  late double _height;
  late double _width;
  late double _heightPadding;
  late double _widthPadding;

  AppConfig(BuildContext _context) {
    this._context = _context;
    var _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;

    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}

// This class is used for app color
class AppColors {
  Color redColor(double opacity) {
    try {
      return const Color(0xFFF22F3F);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color accentColor(double opacity) {
    try {
      return const Color(0xFF043553);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color skyColor(double opacity) {
    try {
      return const Color(0xFF74DEFF);
      // return const Color(0xFF000000);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color blueColor(double opacity) {
    try {
      return const Color(0xFF276EC0);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color orangeColor(double opacity) {
    try {
      return const Color(0xFFFF5E2C);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }
}
