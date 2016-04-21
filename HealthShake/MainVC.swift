//
//  MainVC.swift
//  HealthShake
//
//  Created by STUART DODGSHON on 4/20/16.
//  Copyright © 2016 Healthline.com. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var webview: UIWebView!
    var audioPlayer = AVAudioPlayer()
    
    func loadWebpage() {
        let randURL : String = getNewsURL()
        let url = NSURL(string: randURL)
        let request = NSURLRequest(URL: url!)
        webview.loadRequest(request)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebpage()
    }
    
    func getNewsURL() -> String {
        
        let newsUrls = [
            "http://www.healthline.com/health-news/air-pollution-what-are-we-breathing-and-how-bad-is-it-for-us-102115",
            "http://www.healthline.com/health-news/stanford-researchers-unveil-artificial-skin-that-can-feel-and-heal-101515",
            "http://www.healthline.com/health-news/woman-who-blinded-herself-with-drain-cleaner-brings-attention-to-unusual-condition-100715",
            "http://www.healthline.com/health-news/almost-everything-you-thought-you-knew-about-birth-order-is-wrong-101915",
            "http://www.healthline.com/health-news/colorectal-cancer-striking-younger-people-more-often-100815",
            "http://www.healthline.com/health-news/kids-more-likely-to-get-mental-healthcare-from-family-doctor-than-specialists-101215",
            "http://www.healthline.com/health-news/screen-time-hurts-more-than-kids-eyes-101215",
            "http://www.healthline.com/health-news/dengue-outbreaks-increase-with-climate-change-101215",
            "http://www.healthline.com/health-news/tougher-alcohol-policies-lead-to-fewer-cirrhosis-deaths-101515",
            "http://www.healthline.com/health-news/wide-range-of-pesticides-contribute-to-dwindling-bee-population-101315",
            "http://www.healthline.com/health-news/kids-more-likely-to-get-mental-healthcare-from-family-doctor-than-specialists-101215"
        ]
        
        let random = Int(arc4random_uniform(UInt32(newsUrls.count)))
        let randURL = newsUrls[random]

        return randURL
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
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        do {
            try playSound("Dice_Shake_Multiple_short2", fileExtension: "wav")
        } catch {
            return
        }
        loadWebpage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
