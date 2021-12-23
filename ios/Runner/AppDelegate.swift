import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as ? 
      UNUserNotificationCenterDelegate    
    }
    super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
