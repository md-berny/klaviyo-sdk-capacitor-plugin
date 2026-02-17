import Foundation
import Capacitor
import KlaviyoSwift
import UserNotifications

@objc(KlaviyoSDKCapacitorPlugin)
public class KlaviyoSDKCapacitorPlugin: CAPPlugin, UNUserNotificationCenterDelegate {
  private let implementation = KlaviyoSDKCapacitor()
  
  public override func load() {
    // Listen for the notification from the AppDelegate
    UNUserNotificationCenter.current().delegate = self
  }
  
  @objc func initSDK(_ call: CAPPluginCall) {
    let value = call.getString("klaviyoKey") ?? ""
    KlaviyoSDK().initialize(with: value)
    call.resolve([
      "result": true
    ])
  }
  
  @objc func setUser(_ call: CAPPluginCall) {
    let email = call.getString("email") ?? ""
    let firstName = call.getString("firstName") ?? ""
    let lastName = call.getString("lastName") ?? ""

    let profile = Profile(email: email,  firstName: firstName,  lastName: lastName)

    KlaviyoSDK().set(profile: profile)

    call.resolve([
      "result": true
    ])
  }
  
  @objc func setPushToken(_ call: CAPPluginCall) {
    let token = call.getString("token") ?? ""
    KlaviyoSDK().set(pushToken: token)
    call.resolve([
      "result": true
    ])
  }
  
  @objc func resetProfile(_ call: CAPPluginCall) {
    KlaviyoSDK().resetProfile()
    call.resolve([
      "result": true
    ])
  }
}

extension KlaviyoSDKCapacitorPlugin {
  // below method will be called when the user interacts with the push notification
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
      if #available(iOS 16.0, *) {
        UNUserNotificationCenter.current().setBadgeCount(UIApplication.shared.applicationIconBadgeNumber - 1)
      } else {
        UIApplication.shared.applicationIconBadgeNumber -= 1
      }
      
      // If this notification is Klaviyo's notification we'll handle it
      // else pass it on to the next push notification service to which it may belong
      let handled = KlaviyoSDK().handle(notificationResponse: response, withCompletionHandler: completionHandler)
      if !handled {
        completionHandler()
      }
    }
  
  // below method is called when the app receives push notifications when the app is the foreground
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      if #available(iOS 14.0, *) {
        completionHandler([.list, .banner])
      } else {
        completionHandler([.alert])
      }
    }
}
