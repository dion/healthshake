//
//  MainVC.swift
//  HealthShake
//
//  Created by STUART DODGSHON on 4/20/16.
//  Copyright © 2016 Healthline.com. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

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
