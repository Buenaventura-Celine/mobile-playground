import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/directions_service.dart';
import 'services/location_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;

  // Default center (will be updated with user's location)
  LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController _searchController = TextEditingController();
  final DirectionsService _directionsService = DirectionsService();
  final LocationService _locationService = LocationService();
  bool _isLoading = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LatLng? currentLocation = await _locationService.getCurrentLocation();

      if (currentLocation != null) {
        setState(() {
          _center = currentLocation;
          _markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: _center,
              infoWindow: const InfoWindow(title: 'Current Location'),
            ),
          );
        });

        // Move camera to current location
        mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 15.0));
      } else {
        // Permission denied or location unavailable
        _showSnackBar('Location permission required to show your current location');
        // Still add marker at default location
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: _center,
              infoWindow: const InfoWindow(title: 'Default Location'),
            ),
          );
        });
      }
    } catch (e) {
      _showSnackBar('Error getting location: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchAndShowDirections(String query) async {
    if (query.isEmpty) {
      _showSnackBar('Please enter a location');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Geocode the search query to get coordinates
      List<Location> locations = await locationFromAddress(query);

      if (locations.isEmpty) {
        _showSnackBar('Location not found');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final destination = LatLng(
        locations.first.latitude,
        locations.first.longitude,
      );

      // Get directions from current location to destination
      List<LatLng> routeCoordinates = await _directionsService.getDirections(
        _center,
        destination,
      );

      setState(() {
        // Clear existing polylines
        _polylines.clear();

        // Add new polyline for the route
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: routeCoordinates,
            color: Colors.blue,
            width: 5,
            patterns: [PatternItem.dot, PatternItem.gap(10)],
          ),
        );

        // Add destination marker
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            infoWindow: InfoWindow(title: query),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );

        _isLoading = false;
      });

      // Animate camera to show both origin and destination
      _animateCameraToShowRoute(routeCoordinates);

      _showSnackBar('Route found!');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  void _animateCameraToShowRoute(List<LatLng> routeCoordinates) {
    if (routeCoordinates.isEmpty) return;

    double minLat = routeCoordinates.first.latitude;
    double maxLat = routeCoordinates.first.latitude;
    double minLng = routeCoordinates.first.longitude;
    double maxLng = routeCoordinates.first.longitude;

    for (var point in routeCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearRoute() {
    setState(() {
      _polylines.clear();
      _markers.removeWhere((marker) => marker.markerId.value == 'destination');
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: GooglePlaceAutoCompleteTextField(
            textEditingController: _searchController,
            googleAPIKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '',
            inputDecoration: InputDecoration(
              hintText: 'Search location',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 26,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _clearRoute,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            debounceTime: 400,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              _searchAndShowDirections(prediction.description ?? '');
            },
            itemClick: (Prediction prediction) {
              _searchController.text = prediction.description ?? '';
              _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchController.text.length),
              );
            },
            seperatedBuilder: Divider(
              height: 1,
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            containerHorizontalPadding: 16,
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction.structuredFormatting?.mainText ??
                                prediction.description ??
                                '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (prediction.structuredFormatting?.secondaryText !=
                              null) ...[
                            const SizedBox(height: 4),
                            Text(
                              prediction.structuredFormatting!.secondaryText!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            boxDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
            markers: _markers,
            polylines: _polylines,
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
