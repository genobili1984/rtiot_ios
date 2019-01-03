//
//  StringExtension.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/3.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var MD5:String {
        get {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            
            if let d = self.data(using: String.Encoding.utf8) {
                _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                    CC_MD5(body, CC_LONG(d.count), &digest)
                }
            }
            
            return (0..<length).reduce("") {
                $0 + String(format: "%02x", digest[$1])
            }
//            let messageData = self.data(using: .utf8)
//            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH) )
//            _ = digestData.withUnsafeBytes{ digestBytes in
//                messageData.withUnsafeBytes { messageBytes in
//                    CC_MD5(messageBytes, CC_LONG(messageData?.count ?? 0), digestBytes)
//                }
//            }
//            return digestData.map{String(format:"%02hhx", $0)}.joined()
        }
    }
}
