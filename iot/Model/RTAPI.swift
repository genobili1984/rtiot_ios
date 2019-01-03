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
    
}

extension RTApi : TargetType {
    public var baseURL : URL {
        return URL(string: "http://35.201.253.132:4151")!
    }
    
    public var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .login:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .login(let username, let passwd):
            return .requestParameters(parameters: ["username": username, "password":passwd], encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type":"application/json"]
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
