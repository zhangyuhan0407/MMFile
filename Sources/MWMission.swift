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
        
        guard let params = request.parameters["index"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        if params == "all" {
            
            let jsons = MMMissionRepo.sharedInstance.findAllMissions()
            
            try response.send(OCTResponse.Succeed(data: JSON(jsons))).end()
            
            return
            
        }
        
        
        else if params.contains("-") {
            
            let keys = params.components(separatedBy: "-")
            
            let jsons = MMMissionRepo.sharedInstance.findMissions(keys: keys)
            
            
            try response.send(OCTResponse.Succeed(data: JSON(jsons))).end()
            
            return
        }
            
        
        else {
            
            let json = MMMissionRepo.sharedInstance.findMission(key: params)
            
            try response.send(OCTResponse.Succeed(data: JSON([json]))).end()
            
            return
        }
        
        
    }
    
    
}








class MMMissionRepo {
    
    static let sharedInstance = MMMissionRepo()
    
    
    var missions = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        loadMissions()
    }
    
    
    func loadMissions() {
        
        missions = [:]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: MissionPath)
            
            for file in files {
                
                if file.contains(".") {
                    continue
                }
                
                let json = JSON.read(fromFile: "\(MissionPath)/\(file)")!
                missions.updateValue(json, forKey: file)
            }
            
        } catch {
            fatalError()
        }
        
    }
    
    
   
    
    func findMission(key: String) -> JSON {
        
        let missionIndex = Int(key)!/1000000
        let bossIndex = (Int(key)!%1000000)/10000
        let slotIndex = Int(key)!%10000
        
        
        print("mission index: \(missionIndex)")
        print("boss index: \(bossIndex)")
        print("slot index: \(slotIndex)")
        
        
        var json = self.missions["mission_\(missionIndex)"]!
        
        json.update(value: key, forKey: "key")
        json.update(value: Int(key)!, forKey: "index")
        
        let boss = json["boss"][0].string!
        
        let character = json["characters"]["\(bossIndex)"]
        let charJSON = JSON([boss: character] as [String: Any])
        json["characters"] = charJSON
        
        
        let slot = json["slots"]["\(slotIndex)"]
        let slotJSON = JSON([boss: slot] as [String: Any])
        json["slots"] = slotJSON
        
        
        return json
    }
    
    
    func findMissions(keys: [String]) -> [JSON] {
        
        
        var ret = [JSON]()
        for k in keys {
            var v = MMMissionRepo.sharedInstance.findMission(key: "\(k)")
            v.update(value: Int(k)!, forKey: "index")
            ret.append(v)
        }
        
        return ret
    }
    
    
    func findAllMissions() -> [JSON] {
        
        var jsons = [JSON]()
        let _ = MMMissionRepo.sharedInstance.missions.map {
            (k, v) -> String in
            jsons.append(v)
            return k
        }
        
        
        return jsons
        
    }
    
    
}





