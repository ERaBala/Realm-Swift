//
//  DownloadSongsModel.swift
//  Realm-Swift
//
//  Created by OmniProTech on 12/01/18.
//  Copyright © 2018 Omnipro Technologies. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class DownloadSongsModel: Object {

    var url: String
    
    var songId: String = ""
    var songTitle = ""
    var songArtist = ""
    var songAlbum = ""
    var songDiscription = ""
    var songDownloadUrl = ""
    var songImg = ""

    var isDownloading = false
    var progress: Float = 0.0
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}
