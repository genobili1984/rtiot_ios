//
//  iotModel.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/4.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import Foundation

struct UserInfo : Codable {
    var enterPriseID : String
    var sex : Int32
    var userRole: String
    var userID : String
    var userName: String
}

extension UserInfo {
    enum CodingKeys : String, CodingKey {
        case enterPriseID  = "enterpriseId"
        case sex
        case userRole = "userCode"
        case userID = "userId"
        case userName
    }
}

struct LoginResult : Codable  {
    var result : String
    var retCode: Int32
    let userInfo : UserInfo
}

extension LoginResult {
    enum CodingKeys: String, CodingKey {
        case result
        case retCode = "dataCode"
        case userInfo = "loginUser"
    }
}


protocol DeviceInfo : Codable {
    var equipmentType : String?  {get set}   //设备类型
    var equipmentID : String? {get set}      //设备ID
    var equipmentCode : String? {get set}    //设备编号
    var gatewayID : String? {get set}        //网关
    var enterpriseID : String? {get set}     //企业ID
    var enterpriseName : String? {get set}   //企业名
    var installLocation : String? {get set}  //安装地址
    var installTime : String? {get set}      //安装时间
    var latitude : String? {get set}         //经度
    var longitude : String? {get set}        //维度
    var position  : String? {get set}        //地址
    var state : String? {get set}            //状态
    var fault : String? {get set}            //是否故障
}

struct CameraInfo : DeviceInfo {
    var equipmentType : String?
    var equipmentID : String?
    var equipmentCode : String?
    var gatewayID : String?
    var enterpriseID : String?
    var enterpriseName : String?
    var installLocation : String?
    var installTime : String?
    var latitude : String?
    var longitude : String?
    var position  : String?
    var state : String?
    var fault : String?
    var lampIsOpen : Bool?
    var videoID : String?
}

extension CameraInfo {
    enum CodingKeys : String, CodingKey {
        case equipmentType
        case equipmentID = "equipmentId"
        case equipmentCode
        case gatewayID = "gatewayId"
        case enterpriseID = "enterpriseId"
        case enterpriseName
        case installLocation = "installation"
        case installTime = "installtime"
        case latitude
        case longitude
        case position
        case state
        case fault
        case lampIsOpen = "lampIsopen"
        case videoID = "videoId"
    }
}

struct LampInfo : DeviceInfo {
    var equipmentType : String?
    var equipmentID : String?
    var equipmentCode : String?
    var gatewayID : String?
    var enterpriseID : String?
    var enterpriseName : String?
    var installLocation : String?
    var installTime : String?
    var latitude : String?
    var longitude : String?
    var position  : String?
    var state : String?
    var fault : String?
    var lampIsOpen : Bool?
    var brightNess : String?
}

extension LampInfo {
    enum CodingKeys : String, CodingKey {
        case equipmentType
        case equipmentID = "equipmentId"
        case equipmentCode
        case gatewayID = "gatewayId"
        case enterpriseID = "enterpriseId"
        case enterpriseName
        case installLocation = "installation"
        case installTime = "installtime"
        case latitude
        case longitude
        case position
        case state
        case fault
        case lampIsOpen = "lampIsopen"
        case brightNess = "lampBrightness"
    }
}

struct SewerCoverInfo  : DeviceInfo {
    var equipmentType : String?
    var equipmentID : String?
    var equipmentCode : String?
    var gatewayID : String?
    var enterpriseID : String?
    var enterpriseName : String?
    var installLocation : String?
    var installTime : String?
    var latitude : String?
    var longitude : String?
    var position  : String?
    var state : String?
    var fault : String?
}

extension SewerCoverInfo {
    enum CodingKeys : String, CodingKey {
        case equipmentType
        case equipmentID = "equipmentId"
        case equipmentCode
        case gatewayID = "gatewayId"
        case enterpriseID = "enterpriseId"
        case enterpriseName
        case installLocation = "installation"
        case installTime = "installtime"
        case latitude
        case longitude
        case position
        case state
        case fault
    }
}

struct ParkingInfo : DeviceInfo {
    var equipmentType : String?
    var equipmentID : String?
    var equipmentCode : String?
    var gatewayID : String?
    var enterpriseID : String?
    var enterpriseName : String?
    var installLocation : String?
    var installTime : String?
    var latitude : String?
    var longitude : String?
    var position  : String?
    var state : String?
    var fault : String?
    var parkingIsOwn : Bool
}

extension ParkingInfo {
    enum CodingKeys : String, CodingKey {
        case equipmentType
        case equipmentID = "equipmentId"
        case equipmentCode
        case gatewayID = "gatewayId"
        case enterpriseID = "enterpriseId"
        case enterpriseName
        case installLocation = "installation"
        case installTime = "installtime"
        case latitude
        case longitude
        case position
        case state
        case fault
        case parkingIsOwn = "parkingIsown"
    }
}

struct WaterLevelInfo : DeviceInfo {
    var equipmentType : String?
    var equipmentID : String?
    var equipmentCode : String?
    var gatewayID : String?
    var enterpriseID : String?
    var enterpriseName : String?
    var installLocation : String?
    var installTime : String?
    var latitude : String?
    var longitude : String?
    var position  : String?
    var state : String?
    var fault : String?
    var waterLine : String
}

extension WaterLevelInfo {
    enum CodingKeys : String, CodingKey {
        case equipmentType
        case equipmentID = "equipmentId"
        case equipmentCode
        case gatewayID = "gatewayId"
        case enterpriseID = "enterpriseId"
        case enterpriseName
        case installLocation = "installation"
        case installTime = "installtime"
        case latitude
        case longitude
        case position
        case state
        case fault
        case waterLine = "waterWaterline"
    }
}

struct YonacoInfo : DeviceInfo {
    var equipmentType : String?
    var equipmentID : String?
    var equipmentCode : String?
    var gatewayID : String?
    var enterpriseID : String?
    var enterpriseName : String?
    var installLocation : String?
    var installTime : String?
    var latitude : String?
    var longitude : String?
    var position  : String?
    var state : String?
    var fault : String?
    var yonacoDirection : String
    var yonacoHumidity : String
    var yonacoPM : String
    var yonacoRainfall: String
    var yonacoSpeed: String
}

extension YonacoInfo {
    enum CodingKeys : String, CodingKey {
        case equipmentType
        case equipmentID = "equipmentId"
        case equipmentCode
        case gatewayID = "gatewayId"
        case enterpriseID = "enterpriseId"
        case enterpriseName
        case installLocation = "installation"
        case installTime = "installtime"
        case latitude
        case longitude
        case position
        case state
        case fault
        case yonacoDirection = "yanacoDirection"
        case yonacoHumidity = "yanacoHumidity"
        case yonacoPM = "yanacoPm"
        case yonacoRainfall = "yanacoRainfall"
        case yonacoSpeed = "yanacoSpeed"
    }
}

/*
{
    "branch": {
        "subject": 5,
        "total_students": 110,
        "total_books": 150
    },
    "Subject": [
    {
    "subject_id": 301,
    "name": "EMT",
    "pratical": false,
    "pratical_days": [
    "Monday",
    "Friday"
    ]
    },
    {
    "subject_id": 302,
    "name": "Network Analysis",
    "pratical": true,
    "pratical_days": [
    "Tuesday",
    "Thursday"
    ]
    }
    ]
}
*/


struct Branch : Codable {
    var subject : Int32
    var totalStudents : Int32
    var totalBooks : Int32
}

extension Branch {
    enum CodingKeys: String, CodingKey {
        case subject
        case totalStudents = "total_student"
        case totalBooks = "total_books"
    }
}

struct Subject : Codable {
    let subject_id: Int
    let name: String
    let pratical: Bool
    let pratical_days: [String]
}

struct Students : Codable {
    let branch:Branch
    let subject : [Subject]
}
