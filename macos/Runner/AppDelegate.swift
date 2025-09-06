import Cocoa
import FlutterMacOS
import UserNotifications
import CloudKit
import AuthenticationServices

@main
class AppDelegate: FlutterAppDelegate {
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    
    // Configure notifications
    configureNotifications()
    
    // Configure CloudKit
    configureCloudKit()
    
    // Configure Apple Sign In
    configureAppleSignIn()
    
    // Configure URL scheme handling
    configureURLSchemeHandling()
    
    // Configure menu bar
    configureMenuBar()
    
    // Configure window management
    configureWindowManagement()
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  // MARK: - Notifications Configuration
  private func configureNotifications() {
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        print("Notification permission granted")
      } else if let error = error {
        print("Notification permission error: \(error)")
      }
    }
  }
  
  // MARK: - CloudKit Configuration
  private func configureCloudKit() {
    let container = CKContainer.default()
    container.accountStatus { status, error in
      switch status {
      case .available:
        print("CloudKit account available")
      case .noAccount:
        print("No CloudKit account")
      case .restricted:
        print("CloudKit account restricted")
      case .couldNotDetermine:
        print("Could not determine CloudKit account status")
      @unknown default:
        print("Unknown CloudKit account status")
      }
    }
  }
  
  // MARK: - Apple Sign In Configuration
  private func configureAppleSignIn() {
    // Apple Sign In is available on macOS 10.15+
    if #available(macOS 10.15, *) {
      // Configure Apple Sign In
      print("Apple Sign In configured for macOS")
    }
  }
  
  // MARK: - URL Scheme Handling
  private func configureURLSchemeHandling() {
    // URL scheme handling is configured in Info.plist
    print("URL scheme handling configured")
  }
  
  // MARK: - Menu Bar Configuration
  private func configureMenuBar() {
    // Configure custom menu bar items
    let mainMenu = NSApp.mainMenu
    let appMenu = mainMenu?.item(at: 0)
    let submenu = appMenu?.submenu
    
    // Add custom menu items
    let web3MenuItem = NSMenuItem(title: "Web3 Tools", action: #selector(showWeb3Tools), keyEquivalent: "")
    web3MenuItem.target = self
    submenu?.insertItem(web3MenuItem, at: 3)
    
    let blockchainMenuItem = NSMenuItem(title: "Blockchain Explorer", action: #selector(showBlockchainExplorer), keyEquivalent: "")
    blockchainMenuItem.target = self
    submenu?.insertItem(blockchainMenuItem, at: 4)
  }
  
  // MARK: - Window Management
  private func configureWindowManagement() {
    // Configure window behavior
    NSApp.setActivationPolicy(.regular)
  }
  
  // MARK: - Menu Actions
  @objc private func showWeb3Tools() {
    // Handle Web3 tools menu action
    print("Web3 Tools menu selected")
  }
  
  @objc private func showBlockchainExplorer() {
    // Handle blockchain explorer menu action
    print("Blockchain Explorer menu selected")
  }
  
  // MARK: - URL Scheme Handling
  override func application(_ application: NSApplication, open urls: [URL]) {
    for url in urls {
      handleURLScheme(url: url)
    }
  }
  
  private func handleURLScheme(url: URL) {
    let scheme = url.scheme
    let host = url.host
    let path = url.path
    let query = url.query
    
    print("URL Scheme received: \(scheme)://\(host ?? "")\(path)")
    
    switch scheme {
    case "rechain":
      handleRechainURL(host: host, path: path, query: query)
    case "rechainvc":
      handleRechainVCURL(host: host, path: path, query: query)
    default:
      print("Unknown URL scheme: \(scheme)")
    }
  }
  
  private func handleRechainURL(host: String?, path: String, query: String?) {
    // Handle rechain:// URLs
    print("Handling rechain URL: \(path)")
  }
  
  private func handleRechainVCURL(host: String?, path: String, query: String?) {
    // Handle rechainvc:// URLs
    print("Handling rechainvc URL: \(path)")
  }
  
  // MARK: - Document Handling
  override func application(_ sender: NSApplication, openFile filename: String) -> Bool {
    // Handle file opening
    print("Opening file: \(filename)")
    return true
  }
  
  override func application(_ sender: NSApplication, openFiles filenames: [String]) {
    // Handle multiple file opening
    for filename in filenames {
      print("Opening file: \(filename)")
    }
  }
  
  // MARK: - Application Lifecycle
  override func applicationWillTerminate(_ notification: Notification) {
    // Cleanup before termination
    print("Application will terminate")
  }
  
  override func applicationDidBecomeActive(_ notification: Notification) {
    // Handle application becoming active
    print("Application became active")
  }
  
  override func applicationDidResignActive(_ notification: Notification) {
    // Handle application resigning active
    print("Application resigned active")
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Handle notification presentation
    completionHandler([.alert, .badge, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // Handle notification response
    let userInfo = response.notification.request.content.userInfo
    print("Notification response received: \(userInfo)")
    completionHandler()
  }
}
