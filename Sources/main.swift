


import Foundation

import Kitura

import OCTJSON

import OCTFoundation


let router = Router()




router.get("/card/:key", middleware: MMCardMiddleware())


router.get("/dungeon/:index", middleware: MMDungeonMiddleware())


router.get("/inventory/:key", middleware: MMInventoryMiddleware())


router.get("/mission/:index", middleware: MMMissionMiddleware())


//router.get("/pve/:index/characters", middleware: MMPVECharactersMiddleware())


//router.get("/pve/:index/reward", middleware: MMPVERewardMiddleware())
//
//
//router.get("/pve/:index/story", middleware: MMPVEStoryMiddleware())
//
//
//router.get("/pve/:index") { (request, response, next) in
//    
//    guard let index = request.parameters["index"],
//            var json = MMPVEStoryRepo.sharedInstance.stories[index]
//    else {
//        try response.send(OCTResponse.InputFormatError).end()
//        return
//    }
//    
//    json.update(value: MMPVERewardRepo.sharedInstance.rewards[index], forKey: "reward")
//    json.update(value: MMPVECharactersRepo.sharedInstance.chars[index], forKey: "characters")
//    
//    
//    
//    try response.send(OCTResponse.Succeed(data: json)).end()
//    
//}




//router.get("/pve/reload") { (request, response, next) in
//    MMPVERewardRepo.sharedInstance.reload()
//    
//    try response.send(OCTResponse.EmptyResult).end()
//}
//
//
//router.get("/card/reload") { (request, response, next) in
//    MMCardRepo.sharedInstance.reload()
//    
//    try response.send(OCTResponse.EmptyResult).end()
//}


router.get("/dungeon/reload") { (request, response, next) in
    
    MMDungeonRepo.sharedInstance.reload()
    
    try response.send(OCTResponse.EmptyResult).end()
    
}








router.post("/redeem/:key") { (request, response, next) in
    
    
    
    
}







Kitura.addHTTPServer(onPort: 8920, with: router)


Kitura.run()








