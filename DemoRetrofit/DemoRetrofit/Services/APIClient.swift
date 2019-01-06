//
//  Response.swift
//  DemoRetrofit
//
//  Created by KEYUR PRAJAPATI on 05/01/19.
//  Copyright © 2019 keyur. All rights reserved.
//

import Foundation

let BaseURL = "https://api.foursquare.com/v2/"

class APIClient {
  
    static var shared = APIClient()

    func loadFSResponse(strPath: String,handler: @escaping (_ response:[Response]?,_ error:ErrorHandle?)->()){
        guard let gitUrl = URL(string: "\(BaseURL)\(strPath)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard error == nil else {
                handler(nil,nil)
                return
            }
            guard let content = data else {
                print("not returning data")
                handler(nil,nil)
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as! [String:AnyObject]
                let codeType = json.getValue(forKeyPath: ["meta","code"]) as? Int
                if (codeType != nil) {
                    if codeType == 200 {
                        let venues = json.getValue(forKeyPath: ["response","venues"])
                        if (venues != nil) {
                            var model = [Response]()
                            let jsonD = try JSONSerialization.data(withJSONObject: venues as Any, options: [])
                            model = try! JSONDecoder().decode([Response].self, from: jsonD)
                            DispatchQueue.main.async {
                                handler(model,nil)
                            }
                        }
                    }else {
                        let jsonD = try JSONSerialization.data(withJSONObject: json["meta"] as Any, options: [])
                        let model = try! JSONDecoder().decode(ErrorHandle.self, from: jsonD)
                        DispatchQueue.main.async {
                            handler(nil,model)
                        }
                    }
                }else {
                    handler(nil,nil)
                }
            } catch {
                fatalError("json error: \(error)")
            }
            
            }.resume()
    }
}


