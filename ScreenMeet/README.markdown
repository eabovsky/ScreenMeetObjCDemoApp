# ScreenMeet SDK
- Adding the ScreenMeet SDK to your project
- Quick start
- Intialization
- Authentication
    - Username and Password
    - Bearer Access Tokens
- Meeting Controls
    - Configuration
    - Getting Current Stream State
    - Meeting URL
    - Starting a stream
    - Stopping a stream
    - Pausing and Resuming a stream
- Meeting Events
    - Viewers Joining
    - Viewers Leaving
    - On stream state changed
- ScreenMeet User Management
    - Getting User Information
    - Updating User Info or password
    - Getting the Bearer Token
    - Validating Subscription status
- Advanced Usage
    - Image pre-processing


## Adding the ScreenMeet SDK to your project
- Download `ScreenMeetSDK.framework` *(link TBD)*
- Drag and drop `ScreenMeetSDK.framework` into your Xcode project
- Add `ScreenMeetSDK.framework to embed frameworks` (Build Phases -> Embed Frameworks)

## Quick start
- Make sure that the main class-instance to communicate with SDK is called `ScreenMeet`.
- Make sure you added `import ScreenMeetSDK` to any swift files that will use SDK.

Basic ScreenMeet SDK usage workflow:

1.Initialize the shared instance object:
```swift
ScreenMeet.initSharedInstance('{yourAPIkey}')
```

2.Authenticate the user:
```swift
ScreenMeet.sharedInstance().authenticate(token: 'yourAuthToken', callback: {status in
    if (status == .SUCCESS) {
        print("User is authenticated with token")
        print("The bearer token is \(ScreenMeet.sharedInstance().getBearerToken())")
    } else {
        print("User is not authenticated. Reason: \(status)")
    }
})
```

3.Get join meeting URL
```swift
let myRoomUrl = ScreenMeet.sharedInstance().getRoomUrl()
```

4.Start meeting stream
```swift
ScreenMeet.sharedInstance().startStream(callback: {status in
    if (status == .SUCCESS) {
        print("Meeting stream started.")
    } else {
        print("Error: \(status)")
    }
})
```

5.Stop meeting stream
```swift
ScreenMeet.sharedInstance().stopStream()
```

## Initialization

### ScreenMeet Shared Object Instance
The primary API to ScreenMeet is the ScreenMeet Shared Object Instance. To use the API, just reference the static shared instance of `ScreenMeet`. This will allow you to access the ScreenMeet SDK API functions from anywhere in your code.

> `ScreenMeet.sharedInstance()`

### Set your API Key

In order to use the ScreenMeet SDK, you will need to initialize it with the API key which was provided to you by ScreenMeet.

To initialize the shared instance, call `ScreenMeet.initSharedInstance('{yourAPIkey}', .SANDBOX)`

> `public static func initSharedInstance(apiKey: String, environment: EnvironmentType = .SANDBOX)`

Parameters:
- **apiKey** - A string which is used to identify and authorize the developer
- **environment** - Enum [SANDBOX or PRODUCTION]. Defualt is SANDBOX


## Authentication

In order to start a Screen Sharing stream, the user must first be authenticated. ScreenMeet users can be authenticated in two ways:
1. Via a username and password combination
2. With a bearer token

### Authenticate user via username and password

To authenticate user with their ScreenMeet username and password, call `ScreenMeet.sharedInstance().authenticate(username, password, callback)`. As a best practice, we recommend that you do not store the username and password in your app. If you would like to implement automatic authentication in your app, please use the bearer token which can be acquired once username/password authentication has been performed.

> `public func authenticate(username: String, password: String, callback: (status: CallStatus) -> Void)`

Parameters:

- **username** Username of user
- **password** Password of user
- **callback** Is called when operation is finished with result in status variable

Authenticate user sample swift code
```swift
ScreenMeet.sharedInstance().authenticate(username: "testUser", password: "secret", callback: {status in
    if (status == .SUCCESS) {
        print("User authenticated")
        print("Bearer token is \(ScreenMeet.sharedInstance().getBearerToken())")
    } else {
        print("User is not authenticated. Reason: \(status)")
    }
})
```

### Authentication via bearer access token
A user can also be authenticated via a bearer token. A bearer token is available via the `ScreenMeet.sharedInstance().getBearerToken()` call after a user has been authenticated via username and password. An access token can also be acquired by the user via the screenmeet website and pasted into your app directly, depending on your implementation. A token which is returned via `ScreenMeet.sharedInstance().getBearerToken()` will become invalid when the user changes their password. A token that is provided by the user directly might become invalid if the user chooses to revoke it.

To implement automatic authentication, we recommend that you store bearer token value in your application's local storage, and use it to authenticate the user automatically after their first auth has been performed.
Parameters:

- **token** Users bearer token
- **callback** Is called when operation is finished with result in status variable

Authenticate user swift sample
```swift
ScreenMeet.sharedInstance().authenticate(token: bearerToken, callback: {status in
    if (status == .SUCCESS) {
        print("User has been authenticated with token: \(token)")
    } else {
        print("User is not authenticated. Reason: \(status)")
    }
})
```

## Meeting Controls

### Configuring meeting options
By default, meetings are open for anyone to attend via the URL with one click and auto-assigned viewer names. This configuration can be altered to better suit the security requirements of your application and users. A meeting can be configured to require a password to join, and/or to ask the viewers to type in their names before joining the meeting. In order to configure the meeting settings, use the following method:

> `ScreenMeet.sharedInstance().setMeetingConfig(password: String!, askForName: Bool, callback: (status: CallStatus) -> Void)`

Parameters:
- **password** (String optional) Password to join the meeting. Use **Nil** if password is not required
- **askForName** (Bool) Ask name for every new joined viewer

Sample:
```swift
ScreenMeet.sharedInstance().setMeetingConfig(password: "secret", askForName: true, callback: {status in
    if (status == .SUCCESS) {
        print("Meeting config changed")
    } else {
        print("Meeting config was not changed. Reason: \(status)")
    }
})
```
You can also retreive the current settings by calling `ScreenMeet.sharedInstance().getMeetingConfig()`:

```swift
let meetingConfig = ScreenMeet.sharedInstance().getMeetingConfig()
```

### Getting the stream state
You can access the current state of the meeting by using the method `ScreenMeet.sharedInstance().getStreamState()` which will return the `StreamStateType` ENUM.

### Meeting URL
In order for viewers to join the host's meeting, the host will need to communicate their meeting URL to the viewers. Each ScreenMeet user has a dedicated meeting URL. The URL can be changed by the user if they choose. Call the `getRoomUrl` method to retreive the user's meeting URL.

> `ScreenMeet.sharedInstance().getRoomUrl()`

Sample:
```swift
let myRoomUrl = ScreenMeet.sharedInstance().getRoomUrl()
```

### Start meeting stream
Once a user is authenticated, you can start a stream by calling `startStream`. You will need to pass a callback function, which will indicate a success or fail result. A stream might fail to start if the user's subscription is invalid or if there are network connectivie issues. Please refer to the list of error states at the end of this document.

To start stream use `startStream(callback)`
> `public func startStream(callback: (status: CallStatus) -> Void)`

Parameters:
- **callback** Is called when operation is finished with result in status variables

Sample:
```swift
ScreenMeet.sharedInstance().startStream(callback: {status in
    if (status == .SUCCESS) {
        print("Meeting stream started.")
    } else {
        print("Error: \(status)")
    }
})
```

### Stop meeting stream
To stop meeting stream call `stopStream()`
> public func stopStream()

Sample:
```swift
ScreenMeet.sharedInstance().stopStream()
```

### Pause/Resume stream
Pause the active stream. Keeps the meeting open but stops the capturing/streaming.
> `public func pauseStream()`

resume meeting stream
> `public func resumeStream()`

Sample:
```swift
ScreenMeet.sharedInstance().pauseStream()
...
ScreenMeet.sharedInstance().resumeStream()
```

### Switch the UIView for streaming
You can change the source of the UI content being shared by calling `setStreamSource(newSource)` during a streaming session.
Use nil to do fullscreen screen streaming.
> public func setStreamSource(newSource: UIView)

Sample:
```swift
ScreenMeet.sharedInstance().setStreamSource(newUIView)
```

### Get viewers list
To get list of all connected viewers currently in the meeting call `getViewers()`, which will return a collection of `ScreenMeetViewer` Objects.
> `public func getViewers() -> [ScreenMeetViewer]`

> `public class ScreenMeetViewer: NSObject`

ScreenMeetViewer object resource:

- **id** Unique viewer identificator
- **name** Viewer name
- **latency** The delay, in seconds, of how long it’s taking the user’s stream to reach the viewer

Sample:
```swift
let viewers = ScreenMeet.sharedInstance().getViewers()
```

### Kick viewer out
To remove a viewer from the meeting, use `kickViewer(id)`
> `public func kickViewer(id: String)`

Parameter **id** is ID of viewer to kick

Swift code sample:
```swift
ScreenMeet.sharedInstance().kickViewer(idToKick)
```

## Meeting Events

You can add event listeners for several events which can happen during the course of a meeting, such as detecting when viewers join or leave the meeting, or detecting a disconnection event.

### On viewer join meeting
To handle event when viewer joins the meeting use `onViewerJoined(callback)`
> `public func onViewerJoined(callback: ((viewer: ScreenMeetViewer) -> Void)!)`

_Note:_ Use **callback** = nil to remove handler

Sample:
```swift
ScreenMeet.sharedInstance().onViewerJoined(callback: {viewer in
	print("Viewer \(viewer.name) joined meeting")
})
```

### On viewer left meeting
To handle event when viewer leaves the meeting use onViewerLeft(callback)
> `public func onViewerLeft(callback: ((viewer: ScreenMeetViewer) -> Void)!)`

_Note:_ Use **callback** = nil to remove handler

Sample:
```swift
ScreenMeet.sharedInstance().onViewerLeft(callback: {viewer in
	print("Viewer \(viewer.name) left meeting")
})
```

### On stream state changed
Set on stream state changed handler. Use nil to remove handler
> `public func onStreamStateChanged(callback: ((newState: StreamStateType, reason: StreamStateChangedReason) -> Void)!)`

Parameter **callback** Is called when stream state is changed with new state and reason

Sample:
```swift
ScreenMeet.sharedInstance().onStreamStateChanged({newState, reason in
    print("Stream state was changed to \(newState), reason: \(reason)")
})
```


## User Management
The following set of functions is used to handle user information. Users can be created programmatically if you already collect some of the user information in your application to create a transparent and seamless integration for the end-user.

### Get user info
> `public func isUserLoggedIn() -> Bool`

Returns: Is user authenticated

> `public func getUserId() -> String!`

Returns: Unique User identifier

> `public func getUserName() -> String!`

Returns: Username of authenticated user

> `public func getUserEmail() -> String!`

Returns: Email of authenticated user


### Room Name
To get room name use getRoomName()
> `public func getRoomName() -> String!`

To change room name use setRoomName(roomName, callback)
> `public func setRoomName(roomName: String, callback: (status: CallStatus) -> Void)`

Parameters:

- **roomName**	New root name
- **callback**	Is called when operation is finished with result in status variable

Sample:
```swift
let roomName = ScreenMeet.sharedInstance().getRoomName()
...
ScreenMeet.sharedInstance().setRoomName(newRoomName, callback: {status in
     if (status == .SUCCESS) {
         print("Room name changed")
     } else {
         print("Room name was not changed. Reason: \(status)")
     }
})
```

### Bearer token
After user is authenticated or create method `getBearerToken()` returns bearer token. This bearer token is linked to the user's password, and will change
if the user changes their password.

> `public func getBearerToken() -> String!`

_Note:_ Returns nil if user is not authenticated

```swift
let bearerToken = ScreenMeet.sharedInstance().getBearerToken()
```

To implement user autologin you can store bearerToken value, and after use it to authenticate user by `authenticate(token, callback)` method
Parameters:

- **token** User's bearer token
- **callback** Is called when operation is finished with result in status variable


### Create user

To create a new ScreenMeet user, call `ScreenMeet.sharedInstance().createUser(email, username, password, callback)`. The callback will either receive a success state or an error if user creation was unsuccessful.

> `public func createUser(email: String, username: String, password: String, callback: (status: CallStatus) -> Void)`


Parameters:

- **email** Email of user
- **username** Username of user
- **password** Password of user
- **callback** Is called when operation is finished with result in status variable

Create user swift sample
```swift
ScreenMeet.sharedInstance().createUser("user@email.com", username: "testUser", password: "secret", callback: {status in
    if (status == .SUCCESS) {
        print("User created")
        print("Bearer token is \(ScreenMeet.sharedInstance().getBearerToken())")
    } else {
        print("User is not created. Reason: \(status)")
    }
})
```

### Update user
To update user profile use `updateUser(email, username, password, callback)`.

> public func updateUser(email: String! = nil, username: String! = nil, password: String! = nil, callback: (status: CallStatus) -> Void)

Parameters

- **email** New email value. Use nil in case you dont need to update email value.
- **username** New username value. Use nil in case you dont need to update username value.
- **password** New password value. Use nil in case you dont need to update password value.
- **callback**	Is called when operation is finished with result in status variable

_Note:_ User must be authenticated, otherwise an error will be produced.

_Note:_ If the password is changed, the bearer token will be updated.

Sample:
```swift
ScreenMeet.sharedInstance().updateUser(email, username: name, password: pass, callback: {status in
    if (status == .SUCCESS) {
    	print("User updated")
    	//if you change user password new bearer token will be returned
        print("Bearer token is \(ScreenMeet.sharedInstance().getBearerToken())")
    } else {
        print("User is not updated. Reason: \(status)")
    }
})
```

### Forgot/Reset password
To get link to reset the user's ScreenMeet password webpage use `getResetPasswordURL(email)`
> `public func getResetPasswordURL(email: String) -> String`

Parameters:
- **email** Email to reset password

Sample:
```swift
let linkToResetPassword = ScreenMeet.sharedInstance().getResetPasswordURL(email)
```

### Logout
Logs out the authenticated user. If current stream is in progress stops stream. Will clear bearer token from the object.
> `public func logoutUser()`

Sample:
```swift
ScreenMeet.sharedInstance().logoutUser()
```


## Error Codes and Enums

### Enums
EnvironmentType

- SANDBOX: Used for testing application.
- PRODUCTION: Used for final application.


CallStatus

- SUCCESS: Operation finished with success
- ALREADY_HAS_ACCOUNT: User already has account
- INVALID_EMAIL: Invalid e-mail address
- DUPLICATE_EMAIL: Duplicate e-mail address
- INVALID_ROOM_NAME: Invalid room name (eg, illegal characters)
- STREAM_ALREADY_STARTED: Stream is already started
- DUPLICATE_ROOM_NAME: Duplicate room name (name is already taken)
- INVALID_API_KEY: Invalid API key
- AUTH_ERROR: Authentication error (invalid user auth)
- NETWORK_ERROR: Unexpected server communication error (network issues, API server issue, etc)
- INVALID_SUBSCRIPTION: Invalid subscription (user needs to purchase ScreenMeet subscription)


StreamStateType

- ACTIVE: Stream is active
- PAUSED: Stream is paused
- STOPPED: Stream is stopped


StreamStateChangedReason

- API_CALL: Stream state changed by calling API
- SERVER_ERROR: Unexpected server error
- NETWORK_ERROR: Network connection lost
- STARTED_ON_OTHER_DEVICE: Stream started from another device

## Advanced Usage

### Image processor
Set image processor to change image before send it stream. Use nil to remove handler. Processor should return new image that will be sent to stream
>public func setImageProcessor(processor: ((sourceImage: UIImage) -> UIImage)!)

Parameter **callback** Is called when new frame image appears before send it to stream.

_Note:_ use nil to remove image processor

It can be used for (but not limited):

- adding watermarks for meeting stream
- blur some part of screen
- change size of the image

Sample:
```swift
ScreenMeet.sharedInstance().setImageProcessor({sourceImage in
    let resultImage = doSomeChangesWithSourceImage(sourceImage)
    return resultImage
})
```