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
        
        self.DownloadTheSongs(songURL: DownloadSongJson["songfile"].string!)
        /*  artistname, songid, image_url, songfile, songname, genrename, albumname */
    }
    
    func DownloadTheSongs( songURL : String){
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
                
                let localURL = DefaultDownloadResponse.destinationURL
                let WebURL = DefaultDownloadResponse.response?.url
                
                print("the downloaded path == \(String(describing: localURL))\nActual URL == \(String(describing: WebURL))")
            })
    }
}

// MARK:- Tomarrow Task
// Tomaro Task - store the values in database (func DownloadTheSongURL)
// compare the WebURL and store localURL in Database
// if localURL have value show in list

class DownloadListOfSongs: UIViewController {

    var JsonObject  : [String : AnyObject] = [:]

    var mainArrayObject = [String]()
    
    @IBOutlet weak var MainTabelView: UITableView!
    
    var json : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        JsonObject["userid"] = "5" as AnyObject
        JsonObject["uuid"] = "vugiyuqgweiyfgyigwqefhgiuweqiufh" as AnyObject
        JsonObject["device"] = "ios" as AnyObject
        JsonObject["ipaddress"] = "192.168.0.0" as AnyObject
        JsonObject["pagination"] = "0" as AnyObject
        
        self.libraryMethod(dictParam: JsonObject)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
