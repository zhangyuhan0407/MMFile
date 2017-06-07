//
//  MMPVECharactersMiddleware.swift
//  MMFileServer
//
//  Created by yuhan zhang on 1/28/17.
//
//

import Kitura
import Foundation
import OCTJSON
import OCTFoundation


class MMDungeonMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let index = request.parameters["index"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        if index == "all" {
            let dict = MMDungeonRepo.sharedInstance.dungeons.map({ (k,v) -> [String: Any] in
                return ["key": k,
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
        
        
        guard let dungeon = MMDungeonRepo.sharedInstance.dungeons["dungeon_\(index)"] else {
            try response.send(OCTResponse.InputEmpty).end()
            return
        }
        
        
        
        try response.send(OCTResponse.Succeed(data: dungeon)).end()
        
    }
    
}




class MMDungeonRepo {
    
    static let sharedInstance = MMDungeonRepo()
    
    
    var dungeons = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        for _ in 0..<5 {
            do {
                try loadDungeons()
                break
            } catch {
                
            }
        }
    }
    
    
    private func loadDungeons() throws {
        
        dungeons = [:]
        
        
        let files = try FileManager.default.contentsOfDirectory(atPath: DungeonPath)
        
        for file in files {
            if file.contains(".") {
                continue
            }
            let json = JSON.read(fromFile: "\(DungeonPath)/\(file)")!
            dungeons.updateValue(json, forKey: file)
        }

        
    }
    
    
    
    
}






