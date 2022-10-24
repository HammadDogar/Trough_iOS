//
//  AppDelegate.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import UserNotifications
import Messages
import Firebase
import FacebookCore
import GoogleSignIn
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        StripeAPI.defaultPublishableKey = "sk_test_51IL65uDNJ1INqA5ATGSx5lrTIWSMRDaFqihR2HSPQeYekbwqqmgysRr8rUnNLShJbMp8C9qVnQCA986JBA05cjOG00TxAsqKxi"
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
            window = UIWindow(frame: UIScreen.main.bounds)

        }

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        GMSServices.provideAPIKey("AIzaSyDS3g4PfBUR_OmZ8ntmfKzqJguCtG9JeeM")
        GMSPlacesClient.provideAPIKey("AIzaSyDS3g4PfBUR_OmZ8ntmfKzqJguCtG9JeeM")
//        GMSServices.provideAPIKey("AIzaSyDoi8qaEsHfpsfoOfjUsvzxTeu-gaFYhbg")
//        GMSPlacesClient.provideAPIKey("AIzaSyDMZJZzK8nRSl-q3k-bXSopwMmFu_JTKJI")
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            Global.shared.fcmToken = token
          }
        }
        self.registerForPushNotifications()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handled
    }
    

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


extension AppDelegate{
    func registerForPushNotifications() {
        //1
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID will pre: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID did: \(messageID)")
    }
    GCD.async(.Main, delay: 1.0) {
        self.handleNotification()
    }
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    print(userInfo)

    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
//        Global.shared.fcmToken  = token
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID did reci: \(messageID)")
        }
        if let messageType = userInfo["type"] {
            print("Message Type \(messageType)")
        }
        if let messageMsg = userInfo["msg"] {
            print("Message Message \(messageMsg)")
        }

      // Print full message.
      print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch UIApplication.shared.applicationState {
        case .active:
            //app is currently active, can update badges count here
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
//            GCD.async(.Main, delay: 4.0) {
//                self.handleNotification()
//            }

//            self.showTopNotification(userInfo: userInfo)
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        
        print("recieved")
        
    }
    
}

extension AppDelegate {
    func handleNotification(){
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        var controller = viewController
        while ((controller?.presentedViewController) != nil){
            controller = controller?.presentedViewController
        }
        if let topVC = UIApplication.topViewController() {
            if let vc = topVC as? BaseViewController {
                vc.openNotification()
                
            }
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

