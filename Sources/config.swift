//
//  config.swift
//  MMFileServer
//
//  Created by yuhan zhang on 5/17/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation




extension RouterResponse {
    
    func send(_ model: OCTResponse) -> RouterResponse {
        return self.send(model.description)
    }
    
}



extension RouterRequest {
    
    var jsonBody: JSON? {
        do {
            
            guard let s = try self.readString() else {
                return nil
            }
            
            return try JSON.deserialize(s)
            
        } catch {
            return nil
        }
    }
    
}
