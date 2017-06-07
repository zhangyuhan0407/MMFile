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
        
        if books.count == 0 {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
    
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
    
    
    private func loadBooks() {
        
        books = [:]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: GuideBookPath)
            
            for file in files {
                
                if file.contains(".") {
                    continue
                }
                
                var json = JSON.read(fromFile: "\(GuideBookPath)/\(file)")!
                let materials = json["materials"].array!
                var newMaterials = [JSON]()
                for m in materials {
                    let k = m["key"].string!
                    let count = m["count"].int!
                    
                    var misc = MMInventoryRepo.sharedInstance.findInv(key: k)
                    misc["count"] = JSON(count)
                    newMaterials.append(misc)
                    
                }

                
                json["materials"] = JSON(newMaterials)
                
                books.updateValue(json, forKey: file)
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
            if book.key.lowercased().contains(type.lowercased()) {
                ret.append(book.value)
            }
        }
        
        return ret
    }
    

    
}










