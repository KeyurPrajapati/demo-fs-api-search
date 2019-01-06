//
//  Common.swift
//  DemoRetrofit
//
//  Created by KEYUR PRAJAPATI on 06/01/19.
//  Copyright © 2019 keyur. All rights reserved.
//

import Foundation

extension Dictionary where Key: Hashable, Value: Any {
    func getValue(forKeyPath components : Array<Any>) -> Any? {
        var comps = components;
        let key = comps.remove(at: 0)
        if let k = key as? Key {
            if(comps.count == 0) {
                return self[k]
            }
            if let v = self[k] as? Dictionary<AnyHashable,Any> {
                return v.getValue(forKeyPath : comps)
            }
        }
        return nil
    }
}
