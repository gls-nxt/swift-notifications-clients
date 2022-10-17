//
//  UserNotificationClient.swift
//  
//
//  Created by Jiří Buček on 22.09.2022.
//

import Foundation
import UserNotifications

extension UserNotificationClient {
    
    /// Transforms the UNUserNotificationCenter APIs into the async UserNotificationClient interface
    ///
    /// ❗️ IMPORTANT ❗️
    ///
    /// Always call this static func in the `AppDelegate`'s `didFinishWithLaunching` method (syncronously).
    ///
    /// This makes sure the implemented `UserNotificationsDelegate` object is assigned to the `UNUserNotificationCenter.current().delegate`
    /// before the `didFinishLaunching` method returns. This way the app can react to the push notifications even when opened from a suspended state.
    /// - Returns: Working implementation of the UserNotificationClient
    public static func live() -> Self {
        let notificationDelegate = UserNotificationClient.UserNotificationsDelegate()
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.delegate = notificationDelegate
        let delegate = AsyncStream { continuation in
            notificationDelegate.continuation = continuation
            continuation.onTermination = { _ in }
        }
        
        return Self(addRequest: { try await userNotificationCenter.add($0) },
                    delegate: { delegate },
                    getAuthorizationStatus: {
            await userNotificationCenter.notificationSettings().authorizationStatus
        },
                    removeDeliveredNotifications: {
            userNotificationCenter.removeDeliveredNotifications(withIdentifiers: $0)
        },
                    removePendingRequests: {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: $0)
        },
                    requestAuthorization: {
            try await userNotificationCenter.requestAuthorization(options: $0)
        }
        )
    }
    
}

extension UserNotificationClient {
    public class UserNotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
        var continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation?
        
        deinit {
            print("🍏 DEINIT")
        }
        
        public func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            self.continuation?.yield(
                .didReceiveResponse(response) { completionHandler() }
            )
        }
        
        public func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            openSettingsFor notification: UNNotification?
        ) {
            self.continuation?.yield(
                .openSettingsForNotification(notification)
            )
        }
        
        public func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            self.continuation?.yield(
                .willPresentNotification(notification) { completionHandler($0) }
            )
        }
    }
}
