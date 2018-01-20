//
//  DownloadListOfSongs.swift
//  Realm-Swift
//
//  Created by OmniProTech on 18/01/18.
//  Copyright © 2018 Omnipro Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

protocol DownloadAction {
    func DownloadTheSongURL(SongURL : IndexPath)
}

class TabellistCell : UITableViewCell {
    
    var array = [String: AnyObject]()
    
    var indexPath = NSIndexPath()
    
    var downloadAction : DownloadAction? = nil
    
    @IBOutlet weak var TitleLabel : UILabel!
    @IBOutlet weak var DownloadActionBtn: UIButton!
    
    @IBAction func DownloadTheSongAct(_ sender: Any) {
        self.downloadAction?.DownloadTheSongURL(SongURL: indexPath as IndexPath)
    }
    
}

extension DownloadListOfSongs : DownloadAction {
    
    func DownloadTheSongURL(SongURL: IndexPath) {
        
        let DownloadSongJson = json[SongURL.row]
        
        insertObject(AlbumName: DownloadSongJson["albumname"].string!,ArtistName: DownloadSongJson["artistname"].string!,ImageURL: DownloadSongJson["image_url"].string!,SongName: DownloadSongJson["songname"].string!,GenreType: DownloadSongJson["genrename"].string!,SongURL: DownloadSongJson["songfile"].string!,SongID: DownloadSongJson["songid"].string! )
        
        
    }
    
    func insertObject( AlbumName : String, ArtistName : String, ImageURL : String, SongName : String, GenreType : String, SongURL : String, SongID : String ){
        
        let songDetails = DownloadSongsModel()
        
        var SongURLAppend : String = "http://omniprotechnologies.com/dev/musicapp/dev/iosdownloads.php?song=\(SongURL)"
        
        if AlbumName != "" {
            songDetails.Album = AlbumName
        }
        
        if ArtistName != "" {
            songDetails.Artist = ArtistName
        }
        
        if ImageURL != "" {
            
            let url = NSURL(string: ImageURL)!
            
            if let imgData = NSData(contentsOf: url as URL) {
                // Storing image in documents folder (Swift 2.0+)
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
               
                let writePath = (documentsPath as NSString).appendingPathComponent("SongImage\(SongID).jpg")

                imgData.write(toFile: writePath, atomically: true)

                songDetails.Image = writePath
            }
            
        }
        
        if SongName != "" {
            songDetails.Title = SongName
        }
        
        if GenreType != "" {
            songDetails.genre = GenreType
        }
        
        if SongID != "" {
            
            songDetails.SongID = SongID
            
            let SongsCount = realm.objects(DownloadSongsModel.self).filter("SongID == %@", SongID)
            print(SongsCount.count)
            
            SongURLAppend += "/\(SongsCount.count)"
            
            if SongURLAppend != "" {
                
                songDetails.DownloadUrl = SongURLAppend
            }
        }
        
        try! realm.write() {
            realm.add(songDetails)
            print(SongURLAppend)
            self.DownloadTheSongs(songURL: SongURLAppend)
        }
    }
    
    func DownloadTheSongs( songURL : String){
        
//        let theFileName = (songURL as NSString).lastPathComponent
//
//        let pathExtention = (songURL as NSString).pathExtension
//        let pathPrefix = (songURL as NSString).deletingLastPathComponent
//
//
//        print("print the URL \(theFileName) - \(pathExtention) - \(pathPrefix)")
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(
            songURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print(progress)
            }).response(completionHandler: { (DefaultDownloadResponse) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                
                let localURL = DefaultDownloadResponse.destinationURL!
                let WebURL =  DefaultDownloadResponse.response?.url?.absoluteString
                
                let songDetails = self.RealmObject.filter("DownloadUrl = %@", WebURL!)
                
                let realm = try! Realm()
                if let workout = songDetails.first {
                    try! realm.write {
                        
                        workout.LocalUrl = "\(String(describing: localURL))"
                    }
                }
                
                print("the downloaded path == \(String(describing: localURL))\nActual URL == \(String(describing: WebURL))")
            })
    }
}

// MARK:- Tomarrow Task
// need to list the Songs & Play song & change download button progress.

class DownloadListOfSongs: UIViewController {

    var JsonObject  : [String : AnyObject] = [:]
    
    let RealmObject = realm.objects(DownloadSongsModel.self)

    var mainArrayObject = [String]()
    
    @IBOutlet weak var MainTabelView: UITableView!
    
    var json : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Realm.Configuration.defaultConfiguration.fileURL ?? "*** No URL ***")

        JsonObject["userid"]        = "5" as AnyObject
        JsonObject["uuid"]          = "vugiyuqgweiyfgyigwqefhgiuweqiufh" as AnyObject
        JsonObject["device"]        = "ios" as AnyObject
        JsonObject["ipaddress"]     = "192.168.0.0" as AnyObject
        JsonObject["pagination"]    = "0" as AnyObject
        
        self.libraryMethod(dictParam: JsonObject)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InsertTheValues(){
        
    }

    func libraryMethod(dictParam : Dictionary<String, AnyObject>){
        
        let url = "http://omniprotechnologies.com/dev/musicapp/dev/webservices/Songs_library/songslist_fetch"
        
        Alamofire.request(url, method: .post, parameters: dictParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                
                if let JSONData = response.result.value{
                    
                    self.json = JSON(Data: response.data as Any)
                    let status = self.json["status"]
                    guard status == "Success" else{
                        let responceMessage = self.json["message"]
                        print(responceMessage)
                        return
                    }
                    
                    self.json = JSON(JSONData as! [String : AnyObject])
                    self.json = self.json["songs"]
                    for _ in self.json{
                        
                        let valueofArtist = self.json[self.mainArrayObject.count]["songname"].string
                        self.mainArrayObject.append(valueofArtist!)
                    }
                    
                    self.MainTabelView.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "")
                break
            }
        }
    }

}




extension DownloadListOfSongs : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard mainArrayObject.count != 0 else {
            return 0
        }
        
        return mainArrayObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TabellistCell
        
        cell.downloadAction = self
        cell.indexPath = indexPath as NSIndexPath
        
        guard mainArrayObject.count != 0 else {
            
            cell.TitleLabel.text = "sample txt"
            return cell
        }
        
        cell.TitleLabel.text = mainArrayObject[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(self.json[indexPath.item])
    }
    
}
