//
//  MMMissionMiddleware.swift
//  MMFileServer
//
//  Created by yuhan zhang on 5/25/17.
//
//


import Kitura
import Foundation
import OCTJSON
import OCTFoundation


class MMMissionMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let index = request.parameters["index"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        if index == "all" {
            let dict = MMMissionRepo.sharedInstance.missions.map({ (k,v) -> [String: Any] in
                return ["key": "mission_\(k)",
                        "icon": v["icon"].string!,
                        "title": v["title"].string!,
                        "story": v["story"].string!,
                        "index": v["index"].int!]
            })
            
            
            var jsons = [JSON]()
            for d in dict {
                jsons.append(JSON(d))
            }
            
            
            
            try response.send(OCTResponse.Succeed(data: JSON(jsons))).end()
            return
            
        }
        
        
        guard let dungeon = MMMissionRepo.sharedInstance.missions["mission_\(index)"] else {
            try response.send(OCTResponse.InputEmpty).end()
            return
        }
        
        
        
        
        
        try response.send(OCTResponse.Succeed(data: dungeon)).end()
        
    }
    
}



class MMMissionRepo {
    
    static let sharedInstance = MMMissionRepo()
    
    
    var missions = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        loadInvs()
    }
    
    
    func loadInvs() {
        
        missions = [:]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: MissionPath)
            
            for file in files {
                let json = JSON.read(fromFile: "\(MissionPath)/\(file)")!
                missions.updateValue(json, forKey: file)
            }
            
        } catch {
            fatalError()
        }
        
    }
    
    
    
    func findInvs(keys: [String]) -> [JSON] {
        var ret = [JSON]()
        for k in keys {
            ret.append(missions[k]!)
        }
        return ret
    }
    
    
    
    
}





