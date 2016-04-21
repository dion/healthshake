//
//  LaunchScreenVC.swift
//  HealthShake
//
//  Created by Dion Yang on 4/20/16.
//  Copyright © 2016 Healthline.com. All rights reserved.
//

import UIKit
import AVFoundation

class LaunchScreenVC: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer = AVAudioPlayer()
    
    func getApiData() {
        let urlList = NSMutableArray()
        let titleDictionary = NSMutableDictionary()
        
        let url = NSURL(string: "https://api2.healthline.com/api/service/2.0/news/list?partnerId=31a86f67-b1b6-4fd7-8b98-8caeee8d3078&publishedSince=200")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if jsonResult.count > 0 {
                        if let items = jsonResult["data"] as? NSArray {
                            
                            for item in items {
                                if let title = item["title"] as? String {
                                    if let canonicalurl = item["canonicalurl"] as? String {
                                        
                                        urlList.addObject(canonicalurl)
                                        titleDictionary.setValue(title, forKey: canonicalurl)
                                    }
                                }
                            }
                            NSUserDefaults.standardUserDefaults().setObject(urlList, forKey: "healthlinePages")
                            NSUserDefaults.standardUserDefaults().setObject(titleDictionary, forKey: "healthlinePageTitles")
                        }
                    }
                    
                } catch {
                    print("JSON serialization failed")
                }
                
            }
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("healthlinePages") == nil && NSUserDefaults.standardUserDefaults().objectForKey("healthlinePageTitles") == nil {
            print("getting api data")
            getApiData()
        }

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        do {
            try playSound("Dice_Shake_Multiple_short2", fileExtension: "wav")
        } catch {
            return
        }
        print("segueing")
        performSegueWithIdentifier("goToMain", sender: self)
    }
    
    func playSound(fileName: String, fileExtension: String) throws {
        
        let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(dispatchQueue, { let mainBundle = NSBundle.mainBundle()
            
            let filePath = mainBundle.pathForResource("\(fileName)", ofType:"\(fileExtension)")
            
            if let path = filePath{
                let fileData = NSData(contentsOfFile: path)
                
                do {
                    /* Start the audio player */
                    self.audioPlayer = try AVAudioPlayer(data: fileData!)
                    
                    guard let player : AVAudioPlayer? = self.audioPlayer else {
                        return
                    }
                    
                    /* Set the delegate and start playing */
                    player!.delegate = self
                    if player!.prepareToPlay() && player!.play() {
                        /* Successfully started playing */
                    } else {
                        /* Failed to play */
                    }
                    
                } catch {
                    //self.audioPlayer = nil
                    return
                }
                
            }
            
        })
        
    }

}
