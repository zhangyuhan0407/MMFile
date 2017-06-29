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
            
            let json = MMCardRepo.sharedInstance.findAll()
            
            try response.send(OCTResponse.Succeed(data: JSON(json))).end()
            
            return
        }
        
        
        else if key.contains("-") {
            let keys = key.components(separatedBy: "-")
            
            let ret = MMCardRepo.sharedInstance.findCards(keys: keys)
            
            
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
            return
        }
        
        
        
        else {
            
            let json = MMCardRepo.sharedInstance.findCard(key: key)
        
            try response.send(OCTResponse.Succeed(data: JSON([json]))).end()
            
            return
            
        }
        
        
        
        
    }
    
}





class MMCardRepo {
    
    static let sharedInstance = MMCardRepo()
    
    
    private var cards = [String: JSON]()
    
    private var allCards = [JSON]()
    
    
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
    
    
    
    func findAll() -> [JSON] {
        if self.allCards.count != 0 {
            return self.allCards
        }
        
        
        for (k, v) in self.cards {
            if k.contains("npc") {
                continue
            }
            self.allCards.append(v)
        }
        
        return self.allCards
    }
    
    
    func findCard(key: String) -> JSON {
        return cards[key]!
    }
    
    
    func findCards(keys: [String]) -> [JSON] {
        return keys.map { findCard(key: $0) }
    }
    
    
}


























