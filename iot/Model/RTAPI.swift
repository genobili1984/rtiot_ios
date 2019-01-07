//
//  RTApi.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/3.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import Foundation
import Moya

let RTAPIProvider = MoyaProvider<RTApi>(plugins: [NetworkLoggerPlugin(verbose: true)])

public enum RTApi  {
    case login(username: String, passwd:String)
    case deviceList(enterpriseID: String)
    
}

extension RTApi : TargetType {
    public var baseURL : URL {
        return URL(string: "http://47.107.49.84:8085")!
    }
    
    public var path: String {
        switch self {
        case .login:
            return "/islogin"
        case .deviceList:
            return "/wapSearchEquipment"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        switch self {
        case .login:
            return "{}".data(using: String.Encoding.utf8)!
        case .deviceList:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .login(let username, let passwd):
            return .requestParameters(parameters: ["userName": username, "password":passwd], encoding: URLEncoding.default)
        case .deviceList(let enterpriseID):
            return .requestParameters(parameters: ["enterprise": enterpriseID], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type":"application/x-www-form-urlencoded"]       
    }
    
   
}



extension Moya.Response {
    func mapNSDictioary() throws -> NSDictionary  {
        let any = try self.mapJSON()
        guard let dic = any as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        return dic
    }
}
