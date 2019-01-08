//
//  MQTTManage.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/8.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import Foundation
import CocoaMQTT

let MQTTMessageNoti = "MQTTMessageNotification"

class MQTTManager {
    let defaultHost = "47.107.49.84"
    
    static let instance = MQTTManager()
    
    var mqtt: CocoaMQTT?
    
     init() {
        self.mqttSetting()
    }
    
    func connect() {
        mqtt?.connect()
    }
    
    func disconnect() {
        mqtt?.disconnect()
    }
    
    func sendMessage(_ message: String, withTopic topic:String?) {
        let _topic = topic ?? "streetl/"
        mqtt?.publish(_topic, withString: message, qos: .qos1)
    }
    
    private func mqttSetting() {
        
        let clientID = UIDevice.current.identifierForVendor?.uuidString ?? "ios-device"
        // mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 1883)
        mqtt = CocoaMQTT(clientID: clientID , host: defaultHost, port: 1883)
        //mqtt!.username = "admin"
        //mqtt!.password = "password"
        mqtt!.username = "admin"
        mqtt!.password = "password"
        mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
    }
}

extension MQTTManager : CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ack: \(ack)")
        
        if ack == .accept {
            mqtt.subscribe("streetl/+", qos: CocoaMQTTQOS.qos1)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        print("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("message: \(String(describing: message.string?.description)), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("message: \(String(describing: message.string?.description)), id: \(id)")
        
        let name = NSNotification.Name(rawValue:MQTTMessageNoti)
        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqtt did ping")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqtt did receive pong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqtt did disconnect \(err.debugDescription)")
    }
}
