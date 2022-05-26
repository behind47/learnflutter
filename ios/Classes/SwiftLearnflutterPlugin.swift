import Flutter
import UIKit

public class SwiftLearnflutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "platform", binaryMessenger: registrar.messenger())
    let instance = SwiftLearnflutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      break;
    case "getBatteryLevel":
      self.receiveBatteryLevel(result: result)
      break;
    default:
      result(FlutterMethodNotImplemented)
      break;
    }
  }

  private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
}


