import Flutter
import UIKit
import Foundation

public class SwiftLearnflutterPlugin: NSObject, FlutterPlugin {
  private static var handerMap : [String : (() -> Void)] = [String : (() -> Void)]()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "platform", binaryMessenger: registrar.messenger())
    let instance = SwiftLearnflutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    print("behind47 SwiftLearnflutterPlugin.register");
  }
    
  public static func registerHandler(key : String, handler : @escaping (() -> Void)) {
      handerMap[key] = handler
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      break;
    case "getBatteryLevel":
      self.receiveBatteryLevel(result: result)
      break;
    case "test":
      SwiftLearnflutterPlugin.handerMap["test"]
      print("channel test")
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


