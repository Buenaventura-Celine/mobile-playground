import 'package:flutter/material.dart';
import 'package:mobile_playground/router/router.dart';

class Feature {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  const Feature({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}

final List<Feature> features = [
  Feature(
    title: 'NFC Scanner',
    description: 'Scan and read NFC tags',
    icon: Icons.nfc,
    color: Colors.blue,
    route: '/${AppRoute.nfc.name}',
  ),
  Feature(
    title: 'Camera',
    description: 'Take photos and videos',
    icon: Icons.camera_alt,
    color: Colors.green,
    route: '/${AppRoute.camera.name}',
  ),
  Feature(
    title: 'Location',
    description: 'GPS and location services',
    icon: Icons.location_on,
    color: Colors.red,
    route: '/${AppRoute.location.name}',
  ),
  Feature(
    title: 'Sensors',
    description: 'Device sensors data',
    icon: Icons.sensors,
    color: Colors.orange,
    route: '/${AppRoute.sensors.name}',
  ),
  Feature(
    title: 'Bluetooth',
    description: 'Connect to BLE devices',
    icon: Icons.bluetooth,
    color: Colors.purple,
    route: '/${AppRoute.bluetooth.name}',
  ),
  Feature(
    title: 'Storage',
    description: 'File system access',
    icon: Icons.storage,
    color: Colors.teal,
    route: '/${AppRoute.storage.name}',
  ),
];
