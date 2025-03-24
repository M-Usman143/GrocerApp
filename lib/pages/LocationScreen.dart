import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';
import '../LocalStorageHelper/LocalStorageService.dart';
import 'Dashboard/Dashboard.dart';
import 'dart:async';
import 'dart:developer' as developer;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final places.GoogleMapsPlaces _placesApi = places.GoogleMapsPlaces(apiKey: "AIzaSyA6XL4zvqFPY8r5-gfoplw3No_zUWQid5k");
  final loc.Location _location = loc.Location();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoadingCurrentLocation = false;
  bool _mapCreated = false;
  Timer? _debounce;
  bool _isSearching = false;
  List<places.Prediction> _searchPredictions = [];
  String? _currentAddress;
  bool _isLoading = false;
  bool _hasCheckedPermission = false;
  final FocusNode _searchFocusNode = FocusNode();

  // API Key
  final String _apiKey = "AIzaSyA6XL4zvqFPY8r5-gfoplw3No_zUWQid5k";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_hasCheckedPermission) {
      _checkAndRequestPermissions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    try {
      setState(() => _hasCheckedPermission = true);

      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          setState(() => _isLoading = false);
          _showError("Location permission is required. Please enable it in your device settings.");
          return;
        }
      }

      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          setState(() => _isLoading = false);
          _showError("Location services are disabled. Please enable them in your device settings.");
          return;
        }
      }

      await _getCurrentLocation();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError("Error with permissions: $e");
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingCurrentLocation) return;

    try {
      setState(() => _isLoadingCurrentLocation = true);

      final locData = await _location.getLocation();

      if (!mounted) return;

      _currentPosition = LatLng(locData.latitude!, locData.longitude!);

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locData.latitude!,
          locData.longitude!,
        ).timeout(Duration(seconds: 10));

        if (!mounted) return;

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final address = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
          final cleanedAddress = address.replaceAll(RegExp(r', ,'), ',').replaceAll(RegExp(r'^, |, $'), '');
          await _saveLocation(cleanedAddress);
          _currentAddress = cleanedAddress;
        }
      } catch (geocodeError) {
        final address = "Current Location (${locData.latitude!.toStringAsFixed(4)}, ${locData.longitude!.toStringAsFixed(4)})";
        await _saveLocation(address);
        _currentAddress = address;
        developer.log("Geocoding error: $geocodeError");
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingCurrentLocation = false;
          _markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: _currentPosition!,
              infoWindow: InfoWindow(title: 'Your Current Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          };
        });

        _moveCamera();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found your current location'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingCurrentLocation = false;
        });
        _showError("Unable to access your location. Please check your device settings.");
        developer.log("Location access error: $e");
      }
    }
  }

  void _moveCamera() {
    if (_mapCreated && _mapController != null && _currentPosition != null) {
      Future.delayed(Duration(milliseconds: 800), () {
        if (mounted && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition!, 15),
          );
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() => _mapCreated = true);
    Future.delayed(Duration(milliseconds: 500), () => _moveCamera());
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _getPlacePredictions(_searchController.text);
      } else {
        setState(() {
          _searchPredictions = [];
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _getPlacePredictions(String input) async {
    if (input.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final response = await _placesApi.autocomplete(
        input,
        components: [places.Component(places.Component.country, "in")],
      );

      setState(() {
        _searchPredictions = response.predictions;
        _isSearching = false;
      });
    } catch (e) {
      print('Error getting place predictions: $e');
      setState(() {
        _searchPredictions = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _selectPlace(places.Prediction prediction) async {
    try {
      final placeDetails = await _placesApi.getDetailsByPlaceId(prediction.placeId!);
      if (placeDetails.result.geometry != null) {
        final location = placeDetails.result.geometry!.location;
        setState(() {
          _currentPosition = LatLng(location.lat, location.lng);
          _currentAddress = prediction.description;
          _markers = {
            Marker(
              markerId: const MarkerId('selected_location'),
              position: LatLng(location.lat, location.lng),
              infoWindow: InfoWindow(title: prediction.description),
            ),
          };
          _searchController.text = prediction.description ?? '';
          _searchPredictions = [];
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.lat, location.lng),
            15,
          ),
        );

        await _saveLocation(prediction.description);
      }
    } catch (e) {
      print('Error getting place details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error getting place details')),
      );
    }
  }

  Future<void> _saveLocation(String? address) async {
    if (address != null && address.isNotEmpty) {
      await LocalStorageService.saveUserLocation(address);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _navigateToDashboard() {
    if (_currentAddress != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            userLocation: _currentAddress,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Location'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _isLoading && !_isLoadingCurrentLocation
              ? Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
              : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? const LatLng(20.5937, 78.9629),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
            ),
          ),

          if (_markers.isEmpty && !_isLoading && !_isLoadingCurrentLocation)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_rounded, size: 48, color: AppTheme.primaryColor),
                      SizedBox(height: 16),
                      Text(
                        'Search for your location',
                        style: AppTheme.subheadingStyle.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please use the search bar above to find and select your location',
                        style: AppTheme.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppTheme.primaryColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search for your location...',
                          hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onChanged: _getPlacePredictions,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (_searchPredictions.isNotEmpty) {
                            _selectPlace(_searchPredictions.first);
                          }
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: AppTheme.primaryColor),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchPredictions = []);
                          _searchFocusNode.requestFocus();
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (_searchPredictions.isNotEmpty || _isSearching)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              bottom: _currentAddress != null ? 170 : 100,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _isSearching
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primaryColor),
                        SizedBox(height: 16),
                        Text('Finding suggestions...', style: AppTheme.bodyStyle),
                      ],
                    ),
                  )
                      : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: _searchPredictions.length,
                    itemBuilder: (context, index) {
                      final prediction = _searchPredictions[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _selectPlace(prediction),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getPredictionIcon(prediction.types),
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prediction.description ?? '',
                                          style: AppTheme.bodyStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (prediction.structuredFormatting?.secondaryText != null)
                                          Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Text(
                                              prediction.structuredFormatting!.secondaryText!,
                                              style: AppTheme.captionStyle,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < _searchPredictions.length - 1)
                            Divider(height: 1, indent: 70, endIndent: 16),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

          if (_isLoadingCurrentLocation)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppTheme.primaryColor),
                      SizedBox(height: 16),
                      Text(
                        'Getting your current location...',
                        style: AppTheme.bodyStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_currentAddress != null && _searchPredictions.isEmpty)
            Positioned(
              bottom: 90,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Selected Location',
                          style: AppTheme.subheadingStyle.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _currentAddress!,
                      style: AppTheme.bodyStyle,
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _currentAddress == null ? null : _navigateToDashboard,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Use This Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoadingCurrentLocation ? null : _getCurrentLocation,
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  IconData _getPredictionIcon(List<String>? types) {
    if (types == null || types.isEmpty) {
      return Icons.location_on;
    }

    if (types.contains('establishment')) {
      return Icons.store;
    } else if (types.contains('street_address') || types.contains('route')) {
      return Icons.add_road;
    } else if (types.contains('locality') || types.contains('administrative_area_level_1')) {
      return Icons.location_city;
    } else if (types.contains('premise') || types.contains('subpremise')) {
      return Icons.home;
    } else {
      return Icons.location_on;
    }
  }
}