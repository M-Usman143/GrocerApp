import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import '../Common/SharedPreferenceHelper.dart';
import 'Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final loc.Location location = loc.Location();
  LatLng? _currentPosition;
  GoogleMapController? _mapController;
  Marker? _userMarker;
  String? _currentAddress;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final locData = await location.getLocation();
    _currentPosition = LatLng(locData.latitude!, locData.longitude!);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      locData.latitude!,
      locData.longitude!,
    );

    _currentAddress = placemarks.first.name;
    if (_currentAddress != null) {
      await SharedPreferencesHelper.saveLocation(_currentAddress!);
    }

    setState(() {
      _userMarker = Marker(
        markerId: MarkerId('current_location'),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: 'You are here'),
      );
    });
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    }
  }
  Future<void> _searchLocation(String query) async {
    // Use geocoding to search for a location based on the query
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      final newPosition = LatLng(locations.first.latitude, locations.first.longitude);
      setState(() {
        _currentPosition = newPosition;
        _userMarker = Marker(
          markerId: MarkerId('searched_location'),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: 'Searched Location'),
        );
      });
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    }
  }
  Future<void> _saveLocation(String? address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_location', address ?? 'Unknown location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(context),
      body: Stack(
        children: [
          _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _userMarker != null ? {_userMarker!} : {},
            onMapCreated: _onMapCreated,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              width: 400,
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashbaord(
                        userLocation: _currentAddress, // Pass address here
                      ),
                    ),
                  );
                },
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     leading: IconButton(
  //       icon: Icon(Icons.arrow_back, color: Colors.orange),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //     title: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //       child: TypeAheadField<String>(
  //         textFieldConfiguration: TextFieldConfiguration(
  //           controller: _searchController,
  //           decoration: InputDecoration(
  //             hintText: 'Search Location',
  //             filled: true,
  //             fillColor: Colors.white,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             prefixIcon: Icon(Icons.search, color: Colors.grey),
  //           ),
  //         ),
  //         suggestionsCallback: (pattern) async {
  //           if (pattern.isEmpty) {
  //             return [];
  //           }
  //           return await _getSuggestions(pattern);
  //         },
  //         itemBuilder: (context, suggestion) {
  //           return ListTile(
  //             title: Text(suggestion),
  //           );
  //         },
  //         onSuggestionSelected: (suggestion) {
  //           _searchController.text = suggestion;
  //           _searchLocation(suggestion);
  //         },
  //       ),
  //     ),
  //   );
  // }
  Future<List<String>> _getSuggestions(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      return locations.map((loc) => "${loc.latitude}, ${loc.longitude}").toList();
    } catch (e) {
      return [];
    }
  }

}

