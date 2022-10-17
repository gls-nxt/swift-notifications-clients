# ``RemoteNotificationsClient``

Client that can be used as a dependency to handle remote notification registation tasks. 

## Overview

Basically just `UIApplication` remote notifications related APIs transformed into a dependency.
This particular type of dependency makes use of `structs` and `closures` to define its interface instead of `protocols`. This mechanism allows to override the interface implementation easily for better mocking and testing.

## Topics

### Essentials

- <doc:Testing>

### Subtopic
