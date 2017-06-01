//
//  MMCardMiddleware.swift
//  MMFileServer
//
//  Created by yuhan zhang on 1/28/17.
//
//

import Kitura
import Foundation
import OCTJSON
import OCTFoundation


class MMCardMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
   
        if key == "all" {
            try response.send(OCTResponse.Succeed(data: JSON(MMCardRepo.sharedInstance.cards))).end()
            return
        }
        
        
        if key.contains("-") {
            let keys = key.components(separatedBy: "-")
            var ret = [JSON]()
            
            for k in keys {
                let card = MMCardRepo.sharedInstance.cards[k]!
                ret.append(card)
            }
            
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
            return
        }
        
        
        
        guard let card = MMCardRepo.sharedInstance.cards[key] else {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        
        
        try response.send(OCTResponse.Succeed(data: card)).end()
        
    }
    
}





class MMCardRepo {
    
    static let sharedInstance = MMCardRepo()
    
    
    var cards = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        for _ in 0..<5 {
            do {
                try loadCards()
                break
            } catch {
                
            }
        }
    }
    
    
    func loadCards() throws {
        
        cards = [:]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: CardPath)
            
            for file in files {
                if file.contains(".") {
                    continue
                }
                let json = JSON.read(fromFile: "\(CardPath)/\(file)")!
                cards.updateValue(json, forKey: file)
            }
            
            
            let npcfiles = try FileManager.default.contentsOfDirectory(atPath: UnitPath)
            
            for file in npcfiles {
                if file.contains(".") {
                    continue
                }
                let json = JSON.read(fromFile: "\(UnitPath)/\(file)")!
                cards.updateValue(json, forKey: file)
            }
            
            
        } catch {
            fatalError()
        }
        
    }
    
    
}


























