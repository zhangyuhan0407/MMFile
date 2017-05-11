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
        
        
        guard let chars = MMDungeonRepo.sharedInstance.dungeons["\(index)"] else {
            try response.send(OCTResponse.InputEmpty).end()
            return
        }
        
        
        try response.send(OCTResponse.Succeed(data: chars)).end()
        
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
                try loadChars()
                break
            } catch {
                
            }
        }
    }
    
    
    func loadChars() throws {
        
        dungeons = [:]
        
        for i in 1...PVE_COUNT {
            
            let key = "PVE_\(i)"
            
            let json = JSON.read(fromFile: "\(DungeonPath)/\(key)")!
            
            
            dungeons.updateValue(json, forKey: "\(i)")
            
        }
        
    }
    
    
    
    
}






