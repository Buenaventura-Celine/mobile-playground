import Flutter
import UIKit
import GoogleMaps   

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBwB4rW10LhP8C3lInmjNIb08DGZKNEoJc")    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
