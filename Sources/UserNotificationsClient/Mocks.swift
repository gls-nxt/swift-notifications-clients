//
//  Mocks.swift
//
//
//  Created by Jiří Buček on 22.09.2022.

#if DEBUG
import XCTestDynamicOverlay

extension UserNotificationClient {
    /// Failing mock object for testing purposes.
    ///
    /// Calling any property will produce a described error in tests so you can identify the source of the error.
    ///
    /// Set up this dependency for a test:
    /// 1. Start with this failing object.
    /// 2. Override only those properties that should used in the test with your test logic.
    /// 3. Calling any other property will fail the test thus pointing to a non desired dependency usage.
    public static let failing = Self.init(addRequest: unimplemented("\(Self.self).addRequest"),
                                          delegate: unimplemented("\(Self.self).delegate", placeholder: .fatalFail),
                                          getAuthorizationStatus: unimplemented("\(Self.self).getAuthorizationStatus",placeholder: .denied),
                                          removeDeliveredNotifications: unimplemented("\(Self.self).removeDeliveredNotifications", placeholder: Void()),
                                          removePendingRequests: unimplemented("\(Self.self).removePendingRequests", placeholder: Void()),
                                          requestAuthorization: unimplemented("\(Self.self).requestAuthorization", placeholder: false))

    /// Empty mocks object
    ///
    /// Contains empty or default mocks.
    public static let noop = Self.init(addRequest: { _ in },
                                       delegate: {  AsyncStream(unfolding: { .openSettingsForNotification(nil)})},
                                       getAuthorizationStatus: { .authorized },
                                       removeDeliveredNotifications: { _ in },
                                       removePendingRequests: { _ in },
                                       requestAuthorization: { _ in true })
}

extension AsyncStream {
    /// Throws a fatal error when called
    static var fatalFail: Self { fatalError() }
}
#endif

