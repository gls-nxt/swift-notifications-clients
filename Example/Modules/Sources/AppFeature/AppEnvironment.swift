import Combine
import XCTestDynamicOverlay
import RemoteNotificationsClient
import UserNotificationsClient

public struct AppEnvironment {
    
    public let remoteNotificationsClient: RemoteNotificationsClient
    public let userNotificationsClient: UserNotificationClient

    public init(
        remoteNotificationsClient: RemoteNotificationsClient,
        userNotificationsClient: UserNotificationClient
    ) {
        self.remoteNotificationsClient = remoteNotificationsClient
        self.userNotificationsClient = userNotificationsClient
    }
}
