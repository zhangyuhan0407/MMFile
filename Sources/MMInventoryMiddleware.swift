//
//  MMPVERewardMiddleware.swift
//  MMFileServer
//
//  Created by yuhan zhang on 1/28/17.
//
//

import Kitura
import Foundation
import OCTJSON
import OCTFoundation


class MMInventoryMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        let keys = key.components(separatedBy: "-")
        var jsons = [JSON]()
        for k in keys {
            jsons.append(MMInventoryRepo.sharedInstance.invs[k]!)
        }
        
//        guard let reward = MMInventoryRepo.sharedInstance.invs[key] else {
//            try response.send(OCTResponse.InputEmpty).end()
//            return
//        }
        
        
        try response.send(OCTResponse.Succeed(data: JSON(jsons))).end()
        
        
    }
    
}



class MMInventoryRepo {
    
    static let sharedInstance = MMInventoryRepo()
    
    
    var invs = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        loadInvs()
    }
    
    
    func loadInvs() {
        
        invs = [:]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: InventoryPath)
            
            for file in files {
                let json = JSON.read(fromFile: "\(InventoryPath)/\(file)")!
                invs.updateValue(json, forKey: file)
            }
            
        } catch {
            fatalError()
        }

    }
    
    
}


//
//class MMPVEStoryMiddleware: RouterMiddleware {
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let index = request.parameters["index"] else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        guard let story = MMPVEStoryRepo.sharedInstance.stories[index] else {
//            try response.send(OCTResponse.InputEmpty).end()
//            return
//        }
//        
//        
//        try response.send(OCTResponse.Succeed(data: story)).end()
//        
//        
//    }
//}
//
//
//class MMPVEStoryRepo {
//    
//    static let sharedInstance = MMPVEStoryRepo()
//    
//    var stories = [String: JSON]()
//    
//    
//    private init() {
//        self.reload()
//    }
//    
//    
//    public func reload() {
//        for _ in 0..<5 {
//            do {
//                try loadStories()
//                break
//            } catch {
//                continue
//            }
//        }
//    }
//    
//    
//    func loadStories() throws {
//        
//        stories = [:]
//        
//        for i in 1...PVE_COUNT {
//            
//            let key = "PVE_\(i)"
//            
//            guard let json = JSON.read(fromFile: "\(StoryPath)/\(key)") else {
//                throw OCTError.dataConvert
//            }
//            
//            stories.updateValue(json, forKey: "\(i)")
//            
//        }
//        
//    }
//
//}
//
