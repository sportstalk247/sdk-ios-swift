# Sportstalk 24/7 iOS SDK

## Usage

The Sportstalk SDK is a helpful wrapper around the [Sportstalk API](https://apiref.sportstalk247.com/?version=latest)

The set of SDKs and source (iOS, Android, and JS) is here: [https://github.com/sportstalk247/](https://github.com/sportstalk247/)

```bash
pod 'SportsTalk_iOS_SDK', :git=> 'https://github.com/sportstalk247/sdk-ios-swift.git'

```

You will need to register with SportsTalk and get an API Key in order to use sportstalk functions.

## GETTING STARTED: Setting up the SDK

This Sportstalk SDK is meant to power custom chat applications.  Sportstalk does not enforce any restricitons on your UI design, but instead empowers your developers to focus on the user experience without worrying about the underlying chat behavior.

Sportstalk is an EVENT DRIVEN API. When new talk events occur, the SDK will trigger appropriate callbacks, if set.

```swift
import SportsTalk_iOS_SDK

// First you'll need to create a ClientConfig class that you can use later on
let config = ClientConfig(appId: "YourAppId", authToken: "YourApiKey", endpoint: "Your URL")
let client = UserClient(config: config)

// You can set config to have your own endpoint or use the default endpoint like so
let config = ClientConfig(appId: "YourAppId", authToken: "YourApiKey")
```

## Callback function overview
Each and every api function has its callback, when the api is called you will get the response in the callback. You can use this to remove loading screens, hide advertisements, and so on.

### Creating/Updating a user
Invoke this API method if you want to create a user or update an existing user.

When users send messages to a room the user ID is passed as a parameter. When you retrieve the events from a room, the user who generated the event is returned with the event data, so it is easy for your application to process and render chat events with minimal code.

```swift
import SportsTalk_iOS_SDK

let client = UserClient(config: config)

// Almost all api is designed to have a request and response model.

func createUser() {
    // To create a request, make use of the Services convenience class
    let request = UserRequest.CreateUpdateUser(
        userid: "SomeUserId",
        handle: "Sam",
        displayname: "Sam",
        pictureurl: URL(string: dummyUser?.pictureurl ?? ""),
        profileurl: URL(string: dummyUser?.profileurl ?? "")
    )

    client.createOrUpdateUser(request) { (code, message, kind, user) in
        // where; code: Int?, message: String?, kind: String?, user: User?
        // Save user
    }
}
```

### Joining a Room
```swift
let client = ChatClient(config: config)

func JoinRoom(_ room: ChatRoom, as user: User) {
    let request = ChatRequest.JoinRoom(
        roomid: room.id!,
        // To join as Authenticated user, include the user to your request
        userid: user.userid!,
        displayname: user.displayname  
    )

    client.joinRoomAuthenticated(request) { (code, message, _, response) in
        // where response is model called JoinChatRoomResponse
        // Process response
    }
}
```

### Joining a Room using Custom ID
```swift
let client = ChatClient(config: config)

func JoinRoom(_ room: ChatRoom, as user: User) {
    let request = ChatRequest.JoinRoomByCustomId(
        customid: room.customid!,
        userid: user.userid!,
        displayname: user.displayname
    )

    client.joinRoomByCustomId(request) { (code, message, _, response) in
        // where response is model called JoinChatRoomResponse
        // Process response
    }
}
```

### Get room updates
To manually get room updates, use `ChatClient().getUpdates(request:completionHandler)`

```swift
let client = ChatClient(config: config)

func getUpdates(_ room: ChatRoom) {
    let request = ChatRequest.GetUpdates(
        roomid: room.id!
    )

    client.getUpdates(request) { (code, message, _, response) in
        // where response is model called GetUpdatesResponse
        // Get an array of events from response.events
    }
}
```

### Start/Stop Getting Event Updates
Get periodic updates from room by using ```client.startListeningToChatUpdates(config:completionHandler)```

Only new events will be emitted, so it is up to you to collect the new events.

To stop getting updates, simply call `client.stopListeningToChatUpdates(roomid)` anytime.

Note: 
Updates are received every 500 milliseconds.

Losing reference to ```client``` will stop the eventUpdates

```swift
let client = ChatClient(config: config)
var events = [Event]()

func receiveUpdates(from room: ChatRoom) {
    let eventUpdatesConfig = ChatRequest.StartListeningToChatUpdates(roomid: room.id!)
    client.startListeningToChatUpdates(config: eventUpdatesConfig) { (code, message, _, event) in
        if let event = event {
            events.append(event)
        }
        
        // Debug pulse
        print("------------")
        print(code ==  200 ? "pulse success" : "pulse failed")
        print((event?.count ?? 0) > 0 ? "received \(event?.count) event" : "No new events")
        print("------------")
    }
}

func stopUpdates(from room: ChatRoom) {
    // Ideally call this on viewDidDisappear() and deinit()
    let roomid = room.id!
    client.stopListeningToChatUpdates(roomid)
}
```

### Sending A Message
Use **SAY** command to send a message to the room. 
example: ```SAY Hello World!``` or simply ```Hello World!```


Perform **ACTIONS** by using / character
example: ```/dance nicole ```

User sees: ```You dance with Nicole```

Nicole sees: ```(user) dances with you```

Everyone else sees: ```(user) dances with Nicole```

This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room

```swift
let client = ChatClient(config: config)

func send(message: String, to room: ChatRoom, as user: User) {
    // See for list of commands
    let request = ChatRequest.ExecuteChatCommand(
        roomId: room.id!,
        command: "SAY \(message)",
        userid: dummyUser!.userid!
    )

    client.executeChatCommand(request) { (code, message, _, response) in
        // where response is model called ExecuteChatCommandResponse
        // Process response
    }
}
```

For use of these events in action, see the demo page: [https://www.sportstalk247.com/demo.html](https://www.sportstalk247.com/demo.html)

## Conversations and Comments
```swift
let client = CommentClient(config: config)

func getConversations() {
    let request = CommentRequest.ListConversations()

    client.listConversations(request) { (code, message, _, response) in
        // where response is model called ListConversationsResponse
        // Get an array of conversations from response.conversations
    }
}
```

## The Bare Minimum
The only critical events that you need to handle are `ExecuteChatCommand` which will be called for each new chat event, `ExecuteAdminCommand` which will handle messages from administrators, `PurgeUserMessages` which will be called when purge commands are issued to clear messages that violate content policy.

You will probably also want to use `ExecuteChatCommand` to show/hide any loading messages.

The easiest way to see how these event works is to see the demo page: https://www.sportstalk247.com/demo.html

# Chat Application Best Practices
* Do not 'fire and forget' chat messages.  Most chat applications require some level of moderation.  Your UI should make sure to keep track of message metadata such as:
* Message ID
* User Handle for each message.
* User ID for each message.  In the event of moderation or purge events,  your app will need to be able to find and remove purged messages.
* Timestamp
* Use the promises from sendCommand, sendReply, etc, to show/hide some sort of indication that the message is being sent.
* Make sure you handle errors for sending messages in case of network disruption. For instance, `client.sendCommand('message').catch(handleErrorInUiFn)`
* Enable/Disable debug mode with SportsTalkSDK.shared.debugMode = true/false

# Migration Guide

Changed repository from [Gitlab](https://gitlab.com/sportstalk247/sdk-ios-swift) to [Github](https://github.com/sportstalk247/sdk-ios-swift), hence, dependency module identifier changed:
From:
```ruby
#pod 'SportsTalk_iOS_SDK', :git=> 'https://gitlab.com/sportstalk247/sdk-ios-swift.git', :tag => '1.7.6'
```
To:
```kotlin
pod 'SportsTalk_iOS_SDK', :git=> 'https://github.com/sportstalk247/sdk-ios-swift.git', :tag => '1.8.0'
```

SDK Version bumped from version `1.7.6`(previously hosted on Gitlab) to version `1.8.0`(now hosted on Github).
* No feature changes made. Only documentation and readme updates were made on version `1.8.0`.

# Copyright & License
Copyright (c) 2023 Sportstalk 24/7
