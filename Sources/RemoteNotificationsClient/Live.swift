//
//  File.swift
//  
//
//  Created by Jiří Buček on 21.09.2022.
//

import UIKit

extension RemoteNotificationsClient {
    /// Live implementation of the RemoteNotificationClient interface.
    ///
    /// Transforms the remote notification related APIs of the `UIApplication` to the `RemoteNotificationsClient` interface
  public static let live = Self(
    isRegisteredForRemoteNotifications: { UIApplication.shared.isRegisteredForRemoteNotifications },
    registerForRemoteNotifications: { UIApplication.shared.registerForRemoteNotifications() },
    unregisterForRemoteNotifications: { await UIApplication.shared.unregisterForRemoteNotifications() }
  )
}
