# ``UserNotificationsClient``

Client that can be used as a dependency to manage notification-related activities for your app. 

## Overview

Basically just `UNUserNotificationCenter` transformed into a dependency that can easily mocked and tested. 
This particular type of dependency makes use of `structs` and `closures` to define its interface instead of `protocols`. This mechanism allows to override the interface implementation easily for better mocking and testing.

## Topics

### Essentials

- <doc:Testing>

### Subtopic
