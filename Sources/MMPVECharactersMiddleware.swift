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


class MMPVECharactersMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let index = request.parameters["index"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
//        
//        
//        let cells2: [Int]
//        let cards2: [String]
//        
//        let a = Int(index)!
//        
//        switch a {
//        case 1: //
//            cells2 = [4, 5, 6, 9]
//            cards2 = ["xuanwu", "xuanwu", "xuanwu", "fengbo"]
//        case 2: //
//            cells2 = [4, 6, 13]
//            cards2 = ["xuanwu", "xuanwu", "fengbo"]
//        case 3:
//            cells2 = [4, 6, 9, 13]
//            cards2 = ["xuanwu", "xuanwu", "xuanwu", "fengbo"]
//        case 4:
//            cells2 = [1, 2, 4, 7, 8, 11, 13, 14]
//            cards2 = ["xuanwu", "xingtian", "change", "taotie", "fenghou", "suanyu", "houyi", "fengbo"]
//        case 5:
//            cells2 = [0, 3, 5, 6, 8, 11, 13, 14]
//            cards2 = ["xuanwu", "xingtian", "change", "taotie", "fenghou", "suanyu", "houyi", "fengbo"]
//        case 6:
//            cells2 = [1, 5, 6, 7, 8, 9, 10, 15]
//            cards2 = ["xuanwu", "fenghou", "taotie", "change", "xingtian", "houyi", "fengbo", "suanyu"]
//        case 7:
//            cells2 = [0, 1, 2, 6, 7, 11, 12, 15]
//            cards2 = ["xuanwu", "fenghou", "taotie", "change", "xingtian", "houyi", "fengbo", "suanyu"]
//        case 8:
//            cells2 = [0, 2, 5, 7, 10, 12, 13, 15]
//            cards2 = ["xuanwu", "xingtian", "taotie", "fenghou", "fengbo", "change", "houyi", "suanyu"]
//        case 9:
//            cells2 = [0, 3, 5, 6, 9, 10, 12, 15]
//            cards2 = ["xuanwu", "fenghou", "taotie", "change", "xingtian", "houyi", "fengbo", "suanyu"]
//        case 11: //云垂
//            cells2 = [1, 2, 4, 7, 8, 11, 12, 15]
//            cards2 = ["xuanwu", "xingtian", "taotie", "fengbo", "houyi", "fenghou", "change", "suanyu"]
//        case 12: //虎翼
//            cells2 = [0, 1, 2, 7, 9, 11, 12, 15]
//            cards2 = ["xuanwu", "xingtian", "taotie", "fengbo", "houyi", "fenghou", "change", "suanyu"]
//        case 13: //蛇盘
//            cells2 = [0, 4, 5, 6, 9, 10, 11, 15]
//            cards2 = ["xuanwu", "fengbo", "taotie", "xingtian", "houyi", "fenghou", "suanyu", "change"]
//        case 14: //风扬
//            cells2 = [1, 5, 6, 7, 8, 9, 10, 15]
//            cards2 = ["xuanwu", "fenghou", "taotie", "change", "xingtian", "houyi", "fengbo", "suanyu"]
//        default:
//            cells2 = [0, 3, 5, 6, 9, 10, 12, 15]
//            cards2 = ["xuanwu", "xingtian", "taotie", "fenghou", "houyi", "fengbo", "change", "suanyu"]
//        }
//        
//        
//        var jsons = [JSON]()
//        for i in 0..<cells2.count {
//            let obj = ["cardkey": cards2[i], "position": cells2[i]] as [String : Any]
//            let json = JSON(obj)
//            jsons.append(json)
//        }
//        
//        let ret = JSON(jsons)
//        
//        print(ret.description)
//        
//        try ret.description.write(toFile: "\(CharPath)/PVE_\(index)", atomically: true, inAppendMode: false)
//        
        
        guard let chars = MMPVECharactersRepo.sharedInstance.chars[index] else {
            try response.send(OCTResponse.InputEmpty).end()
            return
        }
        
        
        try response.send(OCTResponse.Succeed(data: chars)).end()
        
    }
    
}




class MMPVECharactersRepo {
    
    static let sharedInstance = MMPVECharactersRepo()
    
    
    var chars = [String: JSON]()
    
    
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
        
        chars = [:]
        
        for i in 1...PVE_COUNT {
            
            let key = "PVE_\(i)"
            
            guard let json = JSON.read(fromFile: "\(CharacterPath)/\(key)") else {
                throw OCTError.dataConvert
            }
            
            chars.updateValue(json, forKey: "\(i)")
            
        }
        
    }
    
    
    
    
}






