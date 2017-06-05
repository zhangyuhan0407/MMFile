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
        
        let invs = MMInventoryRepo.sharedInstance.findInvs(keys: keys)
        try response.send(OCTResponse.Succeed(data: JSON(invs))).end()
        
        
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
                
                if file.contains(".") {
                    continue
                }
                
                let json = JSON.read(fromFile: "\(InventoryPath)/\(file)")!
                invs.updateValue(json, forKey: file)
            }
            
        } catch {
            fatalError()
        }

    }
    
    
    
    func findInvs(keys: [String]) -> [JSON] {
        var ret = [JSON]()
        for k in keys {
            
            
            
            
            if k.contains("Gold") {
                var json = invs["PROP_Gold"]!
                json.update(value: k.components(separatedBy: "_")[2], forKey: "count")
                ret.append(invs["PROP_Gold"]!)
            }
            
            
            else if k.contains("Silver") {
                var json = invs["PROP_Silver"]!
                json.update(value: k.components(separatedBy: "_")[2], forKey: "count")
                ret.append(invs["PROP_Silver"]!)
            }
            
            else if k.contains("CARD_Random") {
                
                let type = randomClass()
                
                
                ret.append(invs["CARD_\(type)"]!)
            }
            
            else {
                ret.append(invs[k]!)
            }
        }
        return ret
    }
    
    
    
    
}


//enum MMClass {
//    case
//}


func randomClass() -> String {
    let random = Int.random(max: 9)
    let ret: String
    switch random {
    case 0:
        ret = "FS"
    case 1:
        ret = "MS"
    case 2:
        ret = "SS"
    case 3:
        ret = "DZ"
    case 4:
        ret = "XD"
    case 5:
        ret = "SM"
    case 6:
        ret = "LR"
    case 7:
        ret = "ZS"
    case 8:
        ret = "QS"
    default:
        fatalError()
    }
    
    return ret
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
