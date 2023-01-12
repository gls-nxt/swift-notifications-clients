import Combine
import SwiftUI
import Dependencies
import UserNotificationsClient
import RemoteNotificationsClient

public class AppViewModel: ObservableObject {
    public init() { }
    @Published var permissionsCanBeRequested: Bool = true
    @Published var notificationMessage: String?
    @Dependency(\.remoteNotificationsClient) public var remoteNotificationsClient
    @Dependency(\.userNotificationClient) public var userNotificationsClient
    
    public func receiveNotificationMessage(_ message: String) {
        self.notificationMessage = nil
        withAnimation {
            self.notificationMessage = message
        }
    }
    
    func checkPermissionStatus() async {
        let status = await userNotificationsClient.getAuthorizationStatus()
        switch status {
        case .notDetermined:
            permissionsCanBeRequested = true
        default:
            permissionsCanBeRequested = false
        }
    }
    
    func requestNotificationsAuthorization() {
        Task { @MainActor in
            do {
                // Get the authorization status
                switch await userNotificationsClient.getAuthorizationStatus() {
                case .notDetermined:
                    // Request the authorization
                    let allowed = try await userNotificationsClient.requestAuthorization([.alert, .badge, .sound])
                    if allowed {
                        // Register the app to receive remote notifications
                        // You probably want to call this also on app start
                        // for case when the user allows the push permissions in the iOS settings
                        remoteNotificationsClient.registerForRemoteNotifications()
                    }
                    await checkPermissionStatus()
                default: return
                }
            } catch {
                print("❗️ Could not request remote notifications authorization: \(error)")
            }
        }
    }
    
    func triggerLocalPushNotification() {
        Task {
            do {
                let content = UNMutableNotificationContent()
                content.title = "Notification"
                content.body = "Local notification works"
                content.userInfo["deeplink"] = "scheme://not_really_a_deeplink"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                try await userNotificationsClient.addRequest(.init(identifier: UUID().uuidString,
                                                                           content: content,
                                                                           trigger: trigger))
                
            } catch {
                print("❗️ Error sending local push notification: \(error)")
            }
        }
    }
}
