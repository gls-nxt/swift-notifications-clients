//
//  Mocks.swift
//  
//
//  Created by Jiří Buček on 22.09.2022.
//

#if DEBUG
import XCTestDynamicOverlay

extension RemoteNotificationsClient {
    /// Failing mock object for testing purposes.
    ///
    /// Calling any property will produce a described error in tests so you can identify the source of the error.
    ///
    /// Set up this dependency for a test:
    /// 1. Start with this failing object.
    /// 2. Override only those properties that should used in the test with your test logic.
    /// 3. Calling any other property will fail the test thus pointing to a non desired dependency usage.
    public static let failing = Self(
        isRegisteredForRemoteNotifications: XCTUnimplemented("\(Self.self).isRegisteredForRemoteNotifications", placeholder: false),
        registerForRemoteNotifications: XCTUnimplemented("\(Self.self).unregisterForRemoteNotifications method not implemented.", placeholder: Void()),
        unregisterForRemoteNotifications: XCTUnimplemented("\(Self.self).unregisterForRemoteNotifications method not implemented.", placeholder: Void())
    )
    
    /// Empty mocks object
    ///
    /// Contains empty or default mocks.
    public static let noop = Self.init(isRegisteredForRemoteNotifications: { true },
                                       registerForRemoteNotifications: { },
                                       unregisterForRemoteNotifications: { })
}
#endif
