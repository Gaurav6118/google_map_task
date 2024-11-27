
# Google Map Polygon Drawing Task

This Flutter application demonstrates the functionality of drawing polygons on Google Maps as part of an assignment. The app includes city search, zooming, polygon drawing, and manipulation capabilities. 

## Features

1. **City Search**
   - Users can search for a city using the Google Places API.
   - Navigates to the specified city on the map.

2. **Zoom Functionality**
   - Supports standard pinch and zoom gestures.
   - Provides a detailed view of specific buildings and landmarks.

3. **Polygon Drawing**
   - Users can draw polygons by tapping points on the map.
   - Automatically completes the polygon when the user taps the initial point.

4. **Highlight Drawn Area**
   - Highlights the area enclosed within the polygon once drawing is complete.

5. **Reset Drawing**
   - Provides a reset button to clear the map and reset the drawing state.

6. **Drag Selected Area**
   - Allows dragging of the selected polygon over the map for repositioning.

## Getting Started

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install) on your system.
- Configure your development environment for Flutter.
- Obtain a Google Maps API key and enable the required APIs:
  - Google Maps SDK for Android/iOS.
  - Google Places API.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Gaurav6118/google_map_task.git
   cd google_map_task
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Add your Google Maps API key to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`.

4. Run the app:
   ```bash
   flutter run
   ```

## Architectural Decisions

- **State Management**: Cubit was used for managing the state of polygon drawing and map interactions.
- **Packages**:
  - `google_maps_flutter` for integrating Google Maps.
  - `flutter_bloc` for state management with Cubit.

## Demo

https://drive.google.com/file/d/1dkmPPo0GsAW1lpYLv0mhQv8rt09r0PBd/view?usp=sharing

## Evaluation Criteria

- **Code Quality**: Well-structured and documented code.
- **Functionality**: Implements all required features as per the assignment.
- **UI/UX**: Clean and intuitive interface.

---
