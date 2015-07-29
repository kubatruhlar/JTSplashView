//
//  ViewController.swift
//  JTSplashView Example
//
//  Created by Jakub Truhlar on 25.07.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JTSplashView.splashViewWithBackgroundColor(nil, circleColor: nil, circleSize: nil)
        
        // Simulate state when we want to hide the splash view
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("hideSplashView"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideSplashView() {
        JTSplashView.finishWithCompletion { () -> Void in
            UIApplication.sharedApplication().statusBarHidden = false
        }
    }

}