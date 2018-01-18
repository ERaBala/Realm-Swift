//
//  FileDownload.swift
//  Realm-Swift
//
//  Created by OmniProTech on 17/01/18.
//  Copyright © 2018 Omnipro Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import MediaPlayer

var audioPlayer : AVAudioPlayer!

class FileDownload: UIViewController {
    
    @IBOutlet weak var SongCountField: UITextField!
    var SongDesArray : Array = [""]
    
    @IBOutlet weak var AlbumImage: UIImageView!
    @IBOutlet weak var ArtistName: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.DownloadTheSongs(songURL: "http://omniprotechnologies.com/dev/musicapp/dev/album_uploads/songs/1514551919Kalimba.mp3")
        self.DownloadTheSongs(songURL: "http://omniprotechnologies.com/dev/musicapp/dev/album_uploads/songs/1515495315SampleAudio1.mp3")
        self.DownloadTheSongs(songURL: "http://omniprotechnologies.com/dev/musicapp/dev/album_uploads/songs/vickytestingfile.mp3")
        self.DownloadTheSongs(songURL: "http://omniprotechnologies.com/dev/musicapp/dev/album_uploads/songs/1515042863Sleep_Away.mp3")
        
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
                print(DefaultDownloadResponse.destinationURL ?? "Problem in get the destination URL")
                
                let stringUrl = DefaultDownloadResponse.destinationURL
                self.SongDesArray.append((stringUrl?.path)!)
                
            })
    }
    
    
    // MARK:- Get details From the local (NOTE: NEED TO CHECK THE MP3 PATH)
    func ShowDetails(audioPath : URL){
    
        let mp3Path : String? = Bundle.main.path(forResource: "1515042863Sleep_Away", ofType: "mp3")
        
        let url = URL(fileURLWithPath: mp3Path ?? "")
        
        let asset: AVAsset? = AVURLAsset(url: url, options: nil)
        
        for format: String in (asset?.availableMetadataFormats)! {
         
            for item: AVMetadataItem in (asset?.metadata(forFormat:format))! {
         
                if (item.commonKey == "artwork") {
         
                    let data = ((item.value as? [AnyHashable: Any])?["data"]) as? Data
                    let img = UIImageView(image: UIImage(data: data ?? Data()))

                    continue
         
                }
         
                print("\(item)")
         
            }
        }
        print(String(format: "> Duration = %.2f seconds", CMTimeGetSeconds((asset?.duration)!)))

  /*
        // ============================
        let playerItem = AVPlayerItem.init(url: audioPath)
        
        let metadataList = playerItem.asset.metadata

        for item in metadataList {
            
            guard let key = item.commonKey, let value = item.value else{
                continue
            }
            
            switch key {
            case "title" : SongCountField.text = value as? String
            case "artist": ArtistName.text = (value as? String)!
            case "artwork" where value is NSData : AlbumImage.image = UIImage(data: (value as! NSData) as Data)
            default:
                continue
            }
        }*/
    }
    
    
    // MARK:- Get All MP3 songs List
    func CheckMP3(){
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func playSongAction(_ sender: Any) {
        
        let urlss = URL(string : "file:///Users/omnipro2/Library/Developer/CoreSimulator/Devices/7CC2057B-F950-4BE7-9D09-A60110430C8C/data/Containers/Data/Application/6FCE29CF-DD37-46A5-A24B-F7051E624458/Documents/1515042863Sleep_Away.mp3")
        self.ShowDetails(audioPath: urlss as! URL)
        
        guard SongDesArray.isEmpty, (self.SongCountField.text?.isEmpty)! else {
            return
        }
        
        self.CheckMP3()
        
        let theNumber = self.SongCountField.text
        let destinationUrl = self.SongDesArray[Int(theNumber!)!]
        let url = NSURL(string: destinationUrl)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url! as URL)
            
            guard let player = audioPlayer else { return }

            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    
}
