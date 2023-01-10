import SwiftUI
import SwiftUINavigation

public struct AppView: View {
    @ObservedObject var viewModel: AppViewModel

    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            VStack {
                if let message = viewModel.notificationMessage {
                    VStack {
                        Text("Notification data received:")
                        Text(message)
                            .foregroundColor(.red)
                    }
                    .padding(12)
                }
                
                Group {
                    Button("Request Notifications Permissions") {
                        viewModel.requestNotificationsAuthorization()
                    }.disabled(!viewModel.permissionsCanBeRequested)
                    
                    Button("Send local push") {
                        viewModel.triggerLocalPushNotification()
                    }
                }
                .buttonStyle(.bordered)
                .padding(6)
            }.task {
                await viewModel.checkPermissionStatus()
            }
            .navigationTitle("NotificationsClients")
        }
    }
}
