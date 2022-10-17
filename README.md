# ✉️️ NotificationsClients
![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange) ![Platforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)

A set of dependencies to easily implement remote or local notifications in your Swift app. 

### Dependencies included
Two dependencies included:
- **UserNotificationsClient** - Manages notification-related activities for your app. Basically just `UNUserNotificationCenter` and its delegate transformed into a testable async dependency.

- **RemoteNotificationsClient** - Handles app registration for remote notifications. `UIApplication`'s remote notifications API transformed into a testable async dependency.

Every client has its own target inside this SPM package called `NotificationsClients`. These clients are usually used in conjunction when implementing the remote notifications, thus I put them inside one package.

### Dependency format
Both dependencies use `structs` with `closure` properties instead of protocols to define their interface. This makes for easy mocking and testing. This format is inspired by [PointFree](https://www.pointfree.co/) composable architecture. 
The interface is `async await`. The `UNUserNotificationCenterDelegate` is transformed from a delegate pattern to an `AsyncStream` of delegate events which is much more readable in the target code. 

## 📝 Requirements

iOS 13  
Swift 5.7

## 📦 Installation

### Swift Package Manager
Copy this repository URL, and add the repo into your Package Dependencies:
```
https://github.com/nodes-ios/notificationsClients
```

## 💻 Usage

### Integrating the clients in your dependencies / environment
For production code, just use the `.live()` static property. 

❗️ IMPORTANT❗️
 You must call the.`.live()`  of `UserNotificationsClient` syncronously before the app delegate's `didFinishWithLaunching` returns. This makes sure the correct delegate is assigned to the `UNUserNotificationCenter.current()` and therefore the app can react to push notifications when opened from suspended state. 
```swift
import UserNotificationsClient
import RemoteNotificationsClient

func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
) -> Bool {
    // Set up Dependencies
    setupAppEnvironment()
    return true
}

func setupAppEnvironment() {
    let environment = AppEnvironment(remoteNotificationsClient: RemoteNotificationsClient.live(),
                                     userNotificationsClient: UserNotificationsClient.live())
}
```

### Requesting the push notifications authorization
```swift
func requestPushAuthorization() async {
    do {
        // Get the authorization status
        switch await environment.userNotificationsClient.getAuthorizationStatus() {
        case .notDetermined:
            // Request the authorization
            let allowed = try await environment.userNotificationsClient.requestAuthorization([.alert, .badge, .sound])
            if allowed {
                // Register the app to receive remote notifications
                // You probably want to call this also on app start
                // for case when the user allows the push permissions in the iOS settings
                environment.remoteNotificationsClient.registerForRemoteNotifications()
            }
        default: return
        }
    } catch {
        print("❗️ Could not request remote notifications authorization: \(error)")
    }
}
```

### Receiving remote notifications
Listen to the async stream of notification events. 
```swift
 // Listen to incoming notification events
 // Call this in the app delegate preferably
    Task {
        for await event in environment.userNotificationsClient.delegate() {
            handleNotificationEvent(event)
        }
    }
    
    func handleNotificationEvent(_ event: UserNotificationClient.DelegateEvent) {
        switch event {
        case .willPresentNotification(_, let completion):
            // Notification presented when the app is in foregroud
            // Decide how to present it depending on the context
            // Pass the presentation options to the completion
            // If you do not pass anythig, the notification will not be presented
            completion([.banner, .sound, .list, .badge])
        case .didReceiveResponse(let response, let completion):
            // User tapped on the notification
            // Is triggered both when the app is in foreground and background
            handleNotificationResponse(response)
            completion()
        case .openSettingsForNotification:
            return
        }
    }
```
### Testing
See the `Testing` DocC article inside the targets.


## Why the heck is Firebase not integrated in this already? 🔥
Two reasons: 
1. `FirebaseMessaging` works unreliably outside the app's main target. You really want to set it up inside your app delegate. 
2. This is a generic implementation that should work regardless the push notifications source.

If you want to quickly integrate `FirebaseMessaging` with this, is most cases you just need to: 
- Configure Firebase
- Assign the Messaging delegate
- Send the Firebase token to your backend

```swift
import Firebase
import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    func startFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Send the Firebase token to your backend here
    }
}
```









