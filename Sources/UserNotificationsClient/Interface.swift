//
//  UserNotificationClient.swift
//  
//
//  Created by Jiří Buček on 22.09.2022.
//

import Foundation
import UserNotifications
import Dependencies

/// Interface for a client that manages notification-related activities for your app.
///
/// Basically just a testable interface for UNUserNotificationCenter APIs.
public struct UserNotificationClient {
    public typealias NotificationID = String
    public typealias NotificationRequestID = String
    
    ///  Schedules a delivery of a local notification
    public var addRequest: @Sendable (UNNotificationRequest) async throws -> Void
    
    /// Async stream of delegate events sent by a notification delegate
    public var delegate: @Sendable () -> AsyncStream<DelegateEvent>
    
    /// The app's ability to schedule and receive local and remote notifications.
    public var getAuthorizationStatus: @Sendable () async -> UNAuthorizationStatus
    
    /// Removes your app’s notifications from Notification Center that match the specified identifiers.
    public var removeDeliveredNotifications: @Sendable ([NotificationID]) async -> Void
    
    /// Removes your app’s local notifications that are pending and match the specified identifiers.
    public var removePendingRequests: @Sendable ([NotificationRequestID]) async -> Void
    
    /// Requests the user’s authorization to allow local and remote notifications for your app.
    public var requestAuthorization: @Sendable (UNAuthorizationOptions) async throws -> Bool
}

extension UserNotificationClient {
    /// Each case represents a UNNotificationCenterDelegate method translated into an enum case 
    public enum DelegateEvent {
        case didReceiveResponse(UNNotificationResponse, completionHandler: @Sendable () -> Void)
        case openSettingsForNotification(UNNotification?)
        case willPresentNotification(UNNotification, completionHandler: @Sendable (UNNotificationPresentationOptions) -> Void)
    }
}

extension UserNotificationClient: DependencyKey {
  public static let liveValue = UserNotificationClient.live()
  #if DEBUG
  public static let previewValue = UserNotificationClient.noop
  public static let testValue = UserNotificationClient.failing
  #endif
}


public extension DependencyValues {
  var userNotificationClient: UserNotificationClient {
    get { self[UserNotificationClient.self] }
    set { self[UserNotificationClient.self] = newValue }
  }
}
