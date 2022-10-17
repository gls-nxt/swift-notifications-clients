# Testing

## Preparing the dependency for a test

The main advantage of using this dependency structure is the simplicity of overriding its properties. This is very useful for testing.

Usually you want to start with the ``UserNotificationClient/failing`` object and override only those properties that you intend to use in the test. Calling any other properties will make the test fail, thus recognizing an unintended use of the dependency.

Simple example: 

```swift
func sillyTestExample async {
  var client = UserNotificationClient.failing
  client.getAuthorizationStatus = {
    return .notDetermined
  }

  await viewModel.onAppear()
  // Calling any other closure on the client apart from the one overriden will make the test fail here

  XCAssertTrue(viewModel.authorizationPromtDisplayed)
}
```



