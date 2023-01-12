//
//  AppDelegate.swift
//  InStoreApp
//
//  Created by Jakob Mygind on 15/11/2021.
//

import AppFeature
import Combine
import Dependencies
import SwiftUI
import UserNotificationsClient
import RemoteNotificationsClient

@main
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var userClient: UserNotificationClient?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        self.startApp()
    }
}

// MARK: - Dependencies setup

extension SceneDelegate {
    fileprivate func startApp() {
        // Set the user and remote notifications clients
        // The user notification client needs to be initialized here at the app start
        // to assign the UNNotificationCenter delegate soon enough to react to events
        // coming from the notifications that opened the app
        let remoteNotificationsClient = RemoteNotificationsClient.live
        let userNotificationsClient = UserNotificationClient.live()

        let vm = withDependencies {
            $0.remoteNotificationsClient = remoteNotificationsClient
            $0.userNotificationClient = userNotificationsClient
        } operation: {
            AppViewModel()
        }

        let appView = AppView(viewModel: vm)
        
        // Listen to the notification events and handle them
        Task {
            for await event in userNotificationsClient.delegate() {
                handleNotificationEvent(event, appViewModel: vm)
            }
        }
        
        // Register for remote notifications if the user granted the permissions
        Task {
            let allowed = await (userNotificationsClient.getAuthorizationStatus() == .authorized)
            if allowed {
                remoteNotificationsClient.registerForRemoteNotifications()
            }
        }

        self.window?.rootViewController = UIHostingController(rootView: appView)
        self.window?.makeKeyAndVisible()
    }
    
    /// Handles the incoming notification events
    /// - Parameters:
    ///   - event: Notification event. They match the UNNotificationCenterDelegate methods
    ///   - appViewModel:AppViewModel to handle the notification events
    func handleNotificationEvent(_ event: UserNotificationClient.DelegateEvent,
                                 appViewModel: AppViewModel) {
        switch event {
        case .willPresentNotification(_, let completion):
            // Notification presented when the app is in FOREGROUND
            // Decide how to present it depending on the context
            // Pass the presentation options to the completion
            // If you do not pass anythig, the notification will not be presented
            completion([.banner, .sound, .list, .badge])
        case .didReceiveResponse(let response, let completion):
            // User tapped on the notification
            // Is triggered both when the app is in foreground and background
            
            // Read the user info
            if let deeplink = response.notification.request.content.userInfo["deeplink"] as? String {
                appViewModel.receiveNotificationMessage(deeplink)
            }
            
            // Make sure to always run the completion
            completion()
            return
        case .openSettingsForNotification:
            return
        }
    }
}
