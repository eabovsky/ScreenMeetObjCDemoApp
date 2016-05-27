//
//  ScreenMeet.swift
//  ScreenMeet
//
//  Created by IMakhnyk on 5/23/16.
//  Copyright © 2016 Projector. All rights reserved.
//

import Foundation
import UIKit

public class ScreenMeet: NSObject {

    let apiKey: String
    let environment: EnvironmentType

    public let socketService = SocketService()

    public init(apiKey: String, environment: EnvironmentType = .SANDBOX) {
        self.apiKey = apiKey
        self.environment = environment
        super.init()
        socketService.root = self
        BackendClient.root = self
        BackendClient.getWebsiteConfig()
        BackendClient.initAnalyticSender()
    }
    
    
    public func authenticate(username: String, password: String, callback: (status: CallStatus) -> Void) {
        BackendClient.loginUser(username, password: password, bearer: nil, callback: callback)
    }
    
    public func authenticate(bearerToken: String, callback: (status: CallStatus) -> Void) {
        BackendClient.loginUser(nil, password: nil, bearer: bearerToken, callback: callback)
    }
    
    public func getBearerToken() -> String! {
        if (BackendClient.user == nil) || (BackendClient.user["bearer"] == nil) {
            return nil
        }
        return BackendClient.user["bearer"] as! String!
    }
    
    public func createUser(email: String, username: String, password: String, callback: (status: CallStatus) -> Void) {
        BackendClient.registerUser(username, email: email, password: password, callback: callback)
    }
    
    public func updateUser(email: String! = nil, username: String! = nil, password: String! = nil, callback: (status: CallStatus) -> Void) {
        BackendClient.updateProfile(email, name: username, password: password, callback: callback)
    }
    
    public func isUserLoggedIn() -> Bool {
        return getBearerToken() != nil
    }
    
    public func logoutUser() {
        BackendClient.logout()
    }
    
    public func getResetPasswordURL(email: String) -> String {
        let baseUrl: String = (BackendClient.webConfig["default_brand"]!["url_prefix"] as? String)!
        let url = "\(baseUrl)/#/reset_password?email=\(email)"
        return url
    }
    
    public func getRoomName() -> String! {
        return BackendClient.room["room_id"] as! String!
    }
    
    public func getUserId() -> String! {
        return String(BackendClient.user["id"])
    }
    
    public func getUserName() -> String! {
        return BackendClient.user["name"] as! String!
    }
    
    public func getUserEmail() -> String! {
        return BackendClient.user["email"] as! String!
    }
    
    public func setRoomName(roomName: String, callback: (status: CallStatus) -> Void) {
        BackendClient.setRoomName(roomName, callback: callback)
    }

    public func getRoomUrl(config: StreamConfig = StreamConfig(), callback: (roomUrl: String!, status: CallStatus) -> Void) {
        BackendClient.getInviteText(config, callback: {link, status in callback(roomUrl: link, status: status)})
    }
    
    public func isSubscriptionValid() -> Bool {
        //TODO
        return isUserLoggedIn()
    }
    
    public func startStream(source: UIView, config: StreamConfig = StreamConfig(), callback: (status: CallStatus) -> Void) {
        socketService.startScreenSharing(config)
        socketService.screenshoter.setCurrentView(source)
    }

    public func switchStreamSource(newSource: UIView) {
        socketService.screenshoter.setCurrentView(newSource)
    }
    
    public func pauseStream() {
        if (getStreamState() == .ACTIVE) {
            socketService.isPaused = true
        } else {
            //TODO print warning
        }
    }
    
    public func resumeStream() {
        if (getStreamState() == .PAUSED) {
            socketService.isPaused = false
        } else {
            //TODO print warning
        }
    }

    public func stopStream() {
        if (getStreamState() != .STOPPED) {
            socketService.stopScreenSharing()
        } else {
            //TODO print warning
        }
    }

    public func getStreamState() -> StreamStateType {
        if (socketService.screenSharingEnabled){
            if (socketService.isPaused){
                return .PAUSED
            } else {
                return .ACTIVE
            }
        }
        return .STOPPED
    }
    
    public func getViewerCount() -> Int {
        if (socketService.screenSharingEnabled){
            return socketService.attendeeList.count
        }
        return 0
    }
    
    public func getViewers() -> [ScreenMeetViewer] {
        var vs: [ScreenMeetViewer] = []
        if (socketService.screenSharingEnabled){
            for a in socketService.attendeeList {
                vs.append(ScreenMeetViewer(data: a))
            }
        }
        return vs
    }
    
    public func kickViewer(id: String) {
        socketService.kickAttendee(id)
    }
    
    public func setQuality(quality: Int = 50) {
        socketService.screenshoter.imageQuality = quality
    }
    
    var viewerJoinedHandler: ((viewer: ScreenMeetViewer) -> Void)! = nil
    
    public func onViewerJoined(callback: ((viewer: ScreenMeetViewer) -> Void)!) {
        viewerJoinedHandler = callback
    }

    var viewerLeftHandler: ((viewer: ScreenMeetViewer) -> Void)! = nil

    public func onViewerLeft(callback: ((viewer: ScreenMeetViewer) -> Void)!) {
        viewerLeftHandler = callback
    }

    var disconnectedHandler: ((reason: DisconnectedReason) -> Void)! = nil
    
    public func onDisconnected(callback: ((reason: DisconnectedReason) -> Void)!) {
        disconnectedHandler = callback
    }
}

public class StreamConfig: NSObject {

    public let password: String!
    public let askForName: Bool
 
    public init(password: String! = nil, askForName: Bool = false) {
        self.password = password
        self.askForName = askForName
    }

}

public class ScreenMeetViewer: NSObject {
    public let id: String
    public let name: String
    public let latency: Int
    public init(id: String, name: String, latency: Int) {
        self.id = id
        self.name = name
        self.latency = latency
    }
    
    init(data: NSDictionary){
        self.id = data["id"]! as! String
        self.name = data["name"]! as! String
        //TODO get latency data
        self.latency = 0 //data["latency"]! as! Int
    }
}

public enum EnvironmentType: String {
    case SANDBOX = "https://qa-api-v2.screenmeet.com/api/v2/"
    case PRODUCTION = "https://api-v2.screenmeet.com/api/v2/"
}

public enum StreamStateType: String {
    case ACTIVE = "active"
    case PAUSED = "paused"
    case STOPPED = "stopped"
}


public enum DisconnectedReason: String {
    case SERVER_ERROR = "Unexpected server error"
    case NETWORK_ERROR = "Network connection lost"
    case STARTED_ON_OTHER_DEVICE = "Stream started from another device"
}

public enum CallStatus: String {
    case SUCCESS = "success"
    case ALREADY_HAS_ACCOUNT = "Already has account"
    case INVALID_EMAIL = "Invalid e-mail address"
    case DUPLICATE_EMAIL = "Duplicate e-mail address"
    case INVALID_ROOM_NAME = "Invalid room name (eg, illegal characters)"
    case DUPLICATE_ROOM_NAME = "Duplicate room name (name is already taken)"
    case INVALID_API_KEY = "Invalid API key"
    case AUTH_ERROR = "Authentication error (invalid user auth)"
    case NETWORK_ERROR = "Unexpected server communication error (network issues, API server issue, etc)"
    case INVALID_SUBSCRIPTION = "Invalid subscription (user needs to purchase ScreenMeet subscription)"
}


