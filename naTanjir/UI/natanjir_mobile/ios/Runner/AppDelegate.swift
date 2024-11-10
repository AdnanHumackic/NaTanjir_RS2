import UIKit
import Flutter
import GoogleMaps
import dotenv

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Dotenv.load()
        if let apiKey = Dotenv.get("_googleMapApiKey") {
            GMSServices.provideAPIKey(apiKey)
        } else {
            print("Google map api key nije pronađen.")
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
