import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_playground/bluetooth/bluetooth_screen.dart';
import 'package:mobile_playground/camera/camera_screen.dart';
import 'package:mobile_playground/home/presentation/home_screen.dart';
import 'package:mobile_playground/location/location_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_scanner_screen.dart';
import 'package:mobile_playground/sensors/sensors_screen.dart';
import 'package:mobile_playground/storage/storage_screen.dart';

enum AppRoute {
  nfc,
  camera,
  location,
  sensors,
  bluetooth,
  storage,
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoute.nfc.name,
          builder: (BuildContext context, GoRouterState state) {
            return const NfcScannerScanner();
          },
        ),
        GoRoute(
          path: AppRoute.camera.name,
          builder: (BuildContext context, GoRouterState state) {
            return const CameraScreen();
          },
        ),
        GoRoute(
          path: AppRoute.location.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LocationScreen();
          },
        ),
        GoRoute(
          path: AppRoute.sensors.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SensorsScreen();
          },
        ),
        GoRoute(
          path: AppRoute.bluetooth.name,
          builder: (BuildContext context, GoRouterState state) {
            return const BluetoothScreen();
          },
        ),
        GoRoute(
          path: AppRoute.storage.name,
          builder: (BuildContext context, GoRouterState state) {
            return const StorageScreen();
          },
        ),
      ],
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) {
  return router;
});
