import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_playground/authentication/presentation/authentication_screen.dart';
import 'package:mobile_playground/bluetooth/bluetooth_screen.dart';
import 'package:mobile_playground/document_scanner/presentation/document_scanner_screen.dart';
import 'package:mobile_playground/file_upload/presentation/file_upload_screen.dart';
import 'package:mobile_playground/home/presentation/home_screen.dart';
import 'package:mobile_playground/location/location_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_scanner_screen.dart';
import 'package:mobile_playground/sensors/sensors_screen.dart';
import 'package:mobile_playground/storage/storage_screen.dart';

enum AppRoute {
  nfc,
  documentScanner,
  location,
  sensors,
  bluetooth,
  storage,
  authentication,
  fileUpload
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
          path: AppRoute.documentScanner.name,
          builder: (BuildContext context, GoRouterState state) {
            return const DocumentScannerScreen();
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
        GoRoute(
          path: AppRoute.authentication.name,
          builder: (BuildContext context, GoRouterState state) {
            return const AuthenticationScreen();
          },
        ),
        GoRoute(
          path: AppRoute.fileUpload.name,
          builder: (BuildContext context, GoRouterState state) {
            return const FileUploadScreen();
          },
        ),
      ],
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) {
  return router;
});
