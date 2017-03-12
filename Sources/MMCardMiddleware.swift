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
        
        
//        let dict: [String : Any] = ["key": key,
//                                    "id": 1,
//                                    "name": "神牛",
//                                    "rule": 1,
//                                    "area": 2,
//                                    "type": 3,
//                                    "skill1factor": 0.3,
//                                    "skill2factor": 1,
//                                    "skill1description": "",
//                                    "skill2description": "",
//                                    "ball": 1,
//                                    "category": 1,
//                                    "sp": 5,
//                                    "hp": 100,
//                                    "atk": 100,
//                                    "def": 100,
//                                    "mag": 100,
//                                    "spd": 100,
//                                    "baoji": 0,
//                                    "shanbi": 0,
//                                    "mingzhong": 0,
//                                    "gedang": 0,
//                                    "zaisheng": 0,
//                                    "xixue": 0,
//                                    "fantangwuli": 0,
//                                    "fantanfashu": 0
//        ]
//        
//        
//        let json = JSON(dict)
//        
//        print(json.description)
//        
//        try json.description.write(toFile: "\(CardPath)/\(key)", atomically: true, inAppendMode: false)
        
        
        
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
        
        for card in CARDS {
            
            guard let json = JSON.read(fromFile: "\(CardPath)/\(card)") else {
                throw OCTError.dataConvert
            }
            
            cards.updateValue(json, forKey: card)
            
        }
        
    }
    
    
}


























