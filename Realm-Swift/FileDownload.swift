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

var audioPlayer : AVAudioPlayer!

class FileDownload: UIViewController {
    
    @IBOutlet weak var SongCountField: UITextField!
    var SongDesArray : Array = [""]
    
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
    
    
    @IBAction func playSongAction(_ sender: Any) {
        
//        guard SongDesArray.isEmpty else {
//            return
//        }
        
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
