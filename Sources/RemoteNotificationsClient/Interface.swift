//
//  RemoteNotificationsClient.swift
//  
//
//  Created by Jiří Buček on 21.09.2022.
//

import Foundation
import Dependencies

/// Interface for a client that handles app registration for remote notifications
public struct RemoteNotificationsClient {
    
    /// A Boolean value that indicates whether the app is currently registered for remote notifications.
    public var isRegisteredForRemoteNotifications: () -> Bool
    
    /// Register the app to receive remote notifications
    public var registerForRemoteNotifications: () -> Void
    
    /// Unregister the app to receive remote notifications
    public var unregisterForRemoteNotifications: () async -> Void
}


extension RemoteNotificationsClient: DependencyKey {
  public static let liveValue = RemoteNotificationsClient.live
  #if DEBUG
  public static let previewValue = RemoteNotificationsClient.noop
  public static let testValue = RemoteNotificationsClient.failing
  #endif
}


public extension DependencyValues {
  var remoteNotificationsClient: RemoteNotificationsClient {
    get { self[RemoteNotificationsClient.self] }
    set { self[RemoteNotificationsClient.self] = newValue }
  }
}
