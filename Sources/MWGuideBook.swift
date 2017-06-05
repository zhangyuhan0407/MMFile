//
//  MWGuideBook.swift
//  MMFileServer
//
//  Created by yuhan zhang on 6/5/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation


class MMGuideBookMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let type = request.parameters["type"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        let books = MMGuideBookRepo.sharedInstance.findBooks(forType: type)
        
        
    
        try response.send(OCTResponse.Succeed(data: JSON(books))).end()
        
    }

    
    
}




class MMGuideBookRepo {
    
    
    static let sharedInstance = MMGuideBookRepo()
    
    
    private var books = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        loadBooks()
    }
    
    
    func loadBooks() {
        
        books = [:]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: GuideBookPath)
            
            for file in files {
                
                if file.contains(".") {
                    continue
                }
                
                let json = JSON.read(fromFile: "\(GuideBookPath)/\(file)")!
                missions.updateValue(json, forKey: file)
            }
            
        } catch {
            fatalError()
        }
        
    }
    
    
    
    func findBooks(keys: [String]) -> [JSON] {
        var ret = [JSON]()
        for k in keys {
            ret.append(books[k]!)
        }
        return ret
    }
    
    
    func findBooks(forType type: String) -> [JSON] {
        
        var ret = [JSON]()
        
        if type == "all" {
            for book in books {
                ret.append(book.value)
            }
            return ret
        }
        
        
        for book in books {
            if book.key.contains(type) {
                ret.append(book.value)
            }
        }
        
        return ret
    }
    

    
}










