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


#if os(Linux)
    let CardPath = "/home/ubuntu/Developer/MMFileServer/cards"
    let UnitPath = "/home/ubuntu/Developer/MMFileServer/units"
    let DungeonPath = "/home/ubuntu/Developer/MMFileServer/dungeons"
    let InventoryPath = "/home/ubuntu/Developer/MMFileServer/invs"
    let MissionPath = "/home/ubuntu/Developer/MMFileServer/missions"
    let GuideBookPath = "/home/ubuntu/Developer/MMFileServer/guidebooks"
#else
    let CardPath = "/Users/yorg/Developer/MMFileServer/cards"
    let UnitPath = "/Users/yorg/Developer/MMFileServer/units"
    let DungeonPath = "/Users/yorg/Developer/MMFileServer/dungeons"
    let InventoryPath = "/Users/yorg/Developer/MMFileServer/invs"
    let MissionPath = "/Users/yorg/Developer/MMFileServer/missions"
    let GuideBookPath = "/Users/yorg/Developer/MMFileServer/guidebooks"
#endif


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
