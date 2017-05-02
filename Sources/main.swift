


import Foundation

import Kitura

import OCTJSON
import OCTFoundation


let router = Router()


#if os(Linux)
let CardPath = "/root/Developer/MMFileServer/card"
let CharacterPath = "/root/Developer/MMFileServer/characters"
let RewardPath = "/root/Developer/MMFileServer/reward"
let StoryPath = "/root/Developer/MMFileServer/story"
let DungeonPath = "/root/Developer/MMFileServer/dungeons"
#else
let CardPath = "/Users/yorg/Developer/MMFileServer/cards"
let CharacterPath = "/Users/yorg/Developer/MMFileServer/characters"
let RewardPath = "/Users/yorg/Developer/MMFileServer/reward"
let StoryPath = "/Users/yorg/Developer/MMFileServer/story"
let DungeonPath = "/Users/yorg/Developer/MMFileServer/dungeons"
#endif


let PVE_COUNT = 16
let CARDS = ["fs_bingshuang", "fs_huoyan", "fs_aoshu",
             "ss_emo", "ss_huimie", "ss_tongku",
             "ms_shensheng", "ms_jielv", "ms_anying",
             "dz_cisha", "dz_zhandou", "dz_minrui",
             "xd_xiong", "xd_mao", "xd_niao", "xd_zhiliao",
             "lr_shengcun", "lr_sheji", "lr_shouwang",
             "sm_yuansu", "sm_zengqiang", "sm_zhiliao",
             "zs_wuqi", "zs_kuangbao", "zs_fangyu",
             "qs_chengjie", "qs_fangyu", "qs_zhiliao"]




router.get("/card/:key", middleware: MMCardMiddleware())


router.get("/dungeon/:index", middleware: MMDungeonMiddleware())


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








