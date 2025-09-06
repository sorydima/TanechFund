import Flutter
import UIKit
import UserNotifications
import BackgroundTasks
import CloudKit
import AuthenticationServices

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure notifications
    configureNotifications()
    
    // Configure background tasks
    configureBackgroundTasks()
    
    // Configure URL schemes
    configureURLSchemes()
    
    // Configure CloudKit
    configureCloudKit()
    
    // Configure Apple Sign In
    configureAppleSignIn()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - Notifications Configuration
  private func configureNotifications() {
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { granted, error in
        if granted {
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
        }
      }
    )
  }
  
  // MARK: - Background Tasks Configuration
  private func configureBackgroundTasks() {
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: "com.rechain.vc.background-sync",
      using: nil
    ) { task in
      self.handleBackgroundSync(task: task as! BGAppRefreshTask)
    }
    
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: "com.rechain.vc.notifications",
      using: nil
    ) { task in
      self.handleNotificationTask(task: task as! BGProcessingTask)
    }
  }
  
  // MARK: - URL Schemes Configuration
  private func configureURLSchemes() {
    // Handle deep links and custom URL schemes
  }
  
  // MARK: - CloudKit Configuration
  private func configureCloudKit() {
    let container = CKContainer(identifier: "iCloud.com.rechain.vc")
    container.accountStatus { status, error in
      if let error = error {
        print("CloudKit account status error: \(error)")
      } else {
        print("CloudKit account status: \(status.rawValue)")
      }
    }
  }
  
  // MARK: - Apple Sign In Configuration
  private func configureAppleSignIn() {
    // Configure Apple Sign In if needed
  }
  
  // MARK: - Background Task Handlers
  private func handleBackgroundSync(task: BGAppRefreshTask) {
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
    }
    
    // Perform background sync
    DispatchQueue.global().async {
      // Sync Web3 data, notifications, etc.
      task.setTaskCompleted(success: true)
    }
  }
  
  private func handleNotificationTask(task: BGProcessingTask) {
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
    }
    
    // Process notifications
    DispatchQueue.global().async {
      // Process pending notifications
      task.setTaskCompleted(success: true)
    }
  }
  
  // MARK: - Remote Notifications
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
    
    // Send token to your server
    sendTokenToServer(token: token)
  }
  
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register for remote notifications: \(error)")
  }
  
  private func sendTokenToServer(token: String) {
    // Implement token sending to your server
    print("Sending token to server: \(token)")
  }
  
  // MARK: - URL Handling
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    return handleURL(url: url)
  }
  
  private func handleURL(url: URL) -> Bool {
    guard let scheme = url.scheme else { return false }
    
    switch scheme {
    case "rechain", "rechainvc":
      return handleRechainURL(url: url)
    case "metamask", "trust", "coinbase":
      return handleWalletURL(url: url)
    default:
      return false
    }
  }
  
  private func handleRechainURL(url: URL) -> Bool {
    // Handle REChain deep links
    print("Handling REChain URL: \(url)")
    return true
  }
  
  private func handleWalletURL(url: URL) -> Bool {
    // Handle wallet app URLs
    print("Handling wallet URL: \(url)")
    return true
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Show notification even when app is in foreground
    completionHandler([.alert, .badge, .sound])
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // Handle notification tap
    let userInfo = response.notification.request.content.userInfo
    print("Notification tapped: \(userInfo)")
    
    // Handle deep link or navigation
    handleNotificationTap(userInfo: userInfo)
    
    completionHandler()
  }
  
  private func handleNotificationTap(userInfo: [AnyHashable: Any]) {
    // Handle notification tap actions
    if let deepLink = userInfo["deep_link"] as? String,
       let url = URL(string: deepLink) {
      handleURL(url: url)
    }
  }
}
