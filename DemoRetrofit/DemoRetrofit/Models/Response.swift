//
//  Response.swift
//  DemoRetrofit
//
//  Created by KEYUR PRAJAPATI on 05/01/19.
//  Copyright © 2019 keyur. All rights reserved.
//

import Foundation


struct Response:Codable {
    var id:String = ""
    var name:String = ""
    var location:Location?
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.location =  Location(dictionary["location"] as! [String : Any])
    }
}
struct Location: Codable {
    var distance:Double = 0
    var formattedAddress:[String]
    var address:String?
    init(_ dictionary: [String: Any]) {
        self.distance = dictionary["distance"] as? Double ?? 0
        self.formattedAddress = dictionary["formattedAddress"] as! [String]
        self.address = dictionary["address"] as? String ?? ""
    }
}
struct ErrorHandle: Codable {
    var code:Int = 0
    var requestId:String
    var errorType:String?
    var errorDetail:String?
    init(_ dictionary: [String: Any]) {
        self.code = dictionary["code"] as! Int
        self.requestId = dictionary["requestId"] as! String
        self.errorType = dictionary["errorType"] as? String ?? ""
        self.errorDetail = dictionary["errorDetail"] as? String ?? ""
    }
}
