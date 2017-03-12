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


class MMPVERewardMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let index = request.parameters["index"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let reward = MMPVERewardRepo.sharedInstance.rewards[index] else {
            try response.send(OCTResponse.InputEmpty).end()
            return
        }
        
        
        try response.send(OCTResponse.Succeed(data: reward)).end()
        
        
    }
    
}



class MMPVERewardRepo {
    
    static let sharedInstance = MMPVERewardRepo()
    
    
    var rewards = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        for _ in 0..<5 {
            do {
                try loadRewards()
                break
            } catch {
                continue
            }
        }
    }
    
    
    func loadRewards() throws {
        
        rewards = [:]
        
        for i in 1...PVE_COUNT {
            
            let key = "PVE_\(i)"
            
            guard let json = JSON.read(fromFile: "\(RewardPath)/\(key)") else {
                throw OCTError.dataConvert
            }
            
            rewards.updateValue(json, forKey: "\(i)")
            
        }
        
    }
    
    
}



class MMPVEStoryMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let index = request.parameters["index"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let story = MMPVEStoryRepo.sharedInstance.stories[index] else {
            try response.send(OCTResponse.InputEmpty).end()
            return
        }
        
        
        try response.send(OCTResponse.Succeed(data: story)).end()
        
        
    }
}


class MMPVEStoryRepo {
    static let sharedInstance = MMPVEStoryRepo()
    
    
    var stories = [String: JSON]()
    
    
    private init() {
        self.reload()
    }
    
    
    public func reload() {
        for _ in 0..<5 {
            do {
                try loadStories()
                break
            } catch {
                continue
            }
        }
    }
    
    
    func loadStories() throws {
        
        stories = [:]
        
        for i in 1...PVE_COUNT {
            
            let key = "PVE_\(i)"
            
            guard let json = JSON.read(fromFile: "\(StoryPath)/\(key)") else {
                throw OCTError.dataConvert
            }
            
            stories.updateValue(json, forKey: "\(i)")
            
        }
        
    }

}

