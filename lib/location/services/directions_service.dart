import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DirectionsService {
  static String get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final polylinePoints = PolylinePoints();
          final String encodedPolyline =
              data['routes'][0]['overview_polyline']['points'];

          final List<PointLatLng> result =
              polylinePoints.decodePolyline(encodedPolyline);

          return result
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
        } else {
          String errorMessage = 'Directions API error: ${data['status']}';
          if (data['error_message'] != null) {
            errorMessage += ' - ${data['error_message']}';
          }
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting directions: $e');
    }
  }
}
