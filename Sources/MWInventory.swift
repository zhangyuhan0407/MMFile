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
    
    
    private var invs = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        loadInvs()
    }
    
    
    private func loadInvs() {
        
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
    
    
    func findInv(key: String) -> JSON {
        
        let k = key
        
        guard let ret = invs[k] else {
            
            let ret2: JSON
            if k.contains("Gold") {
                
                var json = invs["PROP_Gold"]!
                json.update(value: k.components(separatedBy: "_")[2], forKey: "count")
                ret2 = json
                
            }
                
                
            else if k.contains("Silver") {
                
                var json = invs["PROP_Silver"]!
                json.update(value: k.components(separatedBy: "_")[2], forKey: "count")
                ret2 = json
                
            }
                
                
            else if k.contains("CARD_Random") {
                
                let type = randomClass()
                
                ret2 = invs["CARD_\(type)"]!
                
            }
                
                
            else {
                
                
                if k.contains("INV_Misc") && k.components(separatedBy: "_").count > 4 {
                    ret2 = invs[k.components(separatedBy: "_").dropLast().joined(separator: "_")]!
                }
                else {
                    fatalError()
                }
                
                
            }
            
            return ret2
        }
        
        
        return ret
        
        
    }
    
    
    func findInvs(keys: [String]) -> [JSON] {
        var ret = [JSON]()
        for k in keys {
            ret.append(findInv(key: k))
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



