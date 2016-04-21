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
    @IBOutlet var navigationBar: UINavigationBar!
    
    func loadWebpage() {
        let randURL : String = getNewsURL()
        let url = NSURL(string: randURL)
        let request = NSURLRequest(URL: url!)
        let newsTitles = NSUserDefaults.standardUserDefaults().objectForKey("healthlinePageTitles") as! NSDictionary

        navigationBar.topItem!.title = newsTitles.objectForKey(randURL) as? String
        webview.loadRequest(request)
    }
       override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loading..."
        loadWebpage()
    }
    
    func getNewsURL() -> String {
        let newsUrls = NSUserDefaults.standardUserDefaults().objectForKey("healthlinePages")
        let random = Int(arc4random_uniform(UInt32(newsUrls!.count)))
        let randURL = newsUrls![random]

        return randURL as! String
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
