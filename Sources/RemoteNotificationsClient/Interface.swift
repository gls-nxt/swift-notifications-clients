//
//  RemoteNotificationsClient.swift
//  
//
//  Created by Jiří Buček on 21.09.2022.
//

import Foundation

/// Interface for a client that handles app registration for remote notifications
public struct RemoteNotificationsClient {
    
    /// A Boolean value that indicates whether the app is currently registered for remote notifications.
    public var isRegisteredForRemoteNotifications: () -> Bool
    
    /// Register the app to receive remote notifications
    public var registerForRemoteNotifications: () -> Void
    
    /// Unregister the app to receive remote notifications
    public var unregisterForRemoteNotifications: () async -> Void
}
