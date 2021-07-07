import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    GMSServices.provideAPIKey("AIzaSyBIiQWhcafuBg-tx6P0wQ5q8QvpZx0RsHE")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
