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

    // Load API key from .env file
    if let apiKey = loadEnvVariable(key: "GOOGLE_MAPS_API_KEY") {
      GMSServices.provideAPIKey(apiKey)
    } else {
      print("Warning: GOOGLE_MAPS_API_KEY not found in .env file")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func loadEnvVariable(key: String) -> String? {
    guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
      return nil
    }

    do {
      let contents = try String(contentsOfFile: path, encoding: .utf8)
      let lines = contents.components(separatedBy: .newlines)

      for line in lines {
        let parts = line.components(separatedBy: "=")
        if parts.count == 2 && parts[0] == key {
          return parts[1]
        }
      }
    } catch {
      print("Error reading .env file: \(error)")
    }

    return nil
  }
}
