//
//  DownloadSongsModel.swift
//  Realm-Swift
//
//  Created by OmniProTech on 12/01/18.
//  Copyright © 2018 Omnipro Technologies. All rights reserved.
//

import RealmSwift

class DownloadSongsModel: Object {

    dynamic var url: String = ""
    
    dynamic var Id          = ""    // songid
    dynamic var Title       = ""    // songname
    dynamic var Artist      = ""    // artistname
    dynamic var Album       = ""    // albumname
    dynamic var genre       = ""    // genrename
    dynamic var Description = ""    //
    dynamic var DownloadUrl = ""    // songfile
    dynamic var LocalUrl    = ""    //  ----- docuent directory file url
    dynamic var Image : NSData?     // image_url

    dynamic var isDownloading = false

}

// All properties must be primitives, NSString, NSDate, NSData, NSNumber, RLMArray, RLMLinkingObjects, or subclasses of RLMObject
