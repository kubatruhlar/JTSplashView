//
//  JTSplashView.swift
//  JTSplashView Example
//
//  Created by Jakub Truhlar on 25.07.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

import UIKit

class JTSplashView: UIView {
    
    // MARK: Properties
    static let sharedInstance = JTSplashView()
    static let screenSize = UIScreen.mainScreen().bounds.size
    
    let duration = 0.3
    let borderWidth : CGFloat = 10.0
    
    var bgColor = UIColor(red: 45.0 / 255.0, green: 61.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    var circleColor = UIColor(red: 110.0 / 255.0, green: 180.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    var vibrateAgain = true
    var completionBlock:(() -> Void)?
    
    var circlePathInitial = UIBezierPath(ovalInRect: CGRect(x: screenSize.width / 2, y: screenSize.height / 2, width: 0.0, height: 0.0))
    var circlePathFinal = UIBezierPath(ovalInRect: CGRect(x: (screenSize.width / 2) - 35.0, y: (screenSize.height / 2) - 35.0, width: 70.0, height: 70.0))
    var circlePathShrinked = UIBezierPath(ovalInRect: CGRect(x: screenSize.width / 2 - 5.0, y: screenSize.height / 2 - 5.0, width: 10.0, height: 10.0))
    var circlePathSqueezeVertical = UIBezierPath(ovalInRect: CGRect(x: (screenSize.width / 2) - 34.0, y: (screenSize.height / 2) - 36.0, width: 68.0, height: 72.0))
    var circlePathSqueezeHorizontal = UIBezierPath(ovalInRect: CGRect(x: (screenSize.width / 2) - 36.0, y: (screenSize.height / 2) - 34.0, width: 72.0, height: 68.0))
    
    var baseCircleLayer = CAShapeLayer()
    var bgWithMask = UIView()
    var bgWithoutMask = UIView()
    
    // MARK: Initializers
    init() {
        super.init(frame:CGRectZero)
        self.alpha = 0.0
        UIApplication.sharedApplication().delegate?.window??.makeKeyAndVisible()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    func doInit() {
        // 1x with mask and above 1x without mask BG
        bgWithMask = createBackgroundWithMask(createMaskCircleLayer())
        bgWithoutMask = createBackgroundWithMask(nil)
        
        addSubview(bgWithMask)
        addSubview(bgWithoutMask)
        createBaseCircle()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addToWindow"), name: UIWindowDidBecomeVisibleNotification, object: nil)
    }
    
    /**
    Class function to create the splash view.
    
    This function takes three optional arguments and generate splash view above everything in keyWindow. StatusBar is hidden during the process, so you should make it visible in finish function block.
    
    :param:  backgroundColor Background color of the splash view. Default is asphalt color.
    :param:  circleColor Color of the animated circle. Default is blue color.
    :param:  circleSize Size of the animated circle. 10pt border will be added, but the size remains the same. Width should be same as height. Default is CGSize(70, 70).
    */
    class func splashViewWithBackgroundColor(backgroundColor: UIColor?, circleColor: UIColor?, circleSize: CGSize?) {
        
        if isVisible() {
            return
        }
        
        UIApplication.sharedApplication().statusBarHidden = true
        sharedInstance.alpha = 1.0
        
        // Redefine properties
        if (backgroundColor != nil) {
            sharedInstance.bgColor = backgroundColor!
        }
        
        if (circleColor != nil) {
            sharedInstance.circleColor = circleColor!
        }
        
        if (circleSize != nil) {
            var sizeWithoutBorder = CGSizeMake(circleSize!.width - sharedInstance.borderWidth, circleSize!.height - sharedInstance.borderWidth)
            
            sharedInstance.circlePathFinal = UIBezierPath(ovalInRect: CGRect(x: (JTSplashView.screenSize.width / 2) - (sizeWithoutBorder.width / 2), y: (JTSplashView.screenSize.height / 2) - (sizeWithoutBorder.height / 2), width: sizeWithoutBorder.width, height: sizeWithoutBorder.height))
            sharedInstance.circlePathSqueezeVertical = UIBezierPath(ovalInRect: CGRect(x: (JTSplashView.screenSize.width / 2) - ((sizeWithoutBorder.width / 2) * 0.96), y: (JTSplashView.screenSize.height / 2) - ((sizeWithoutBorder.height / 2) * 1.04), width: sizeWithoutBorder.width * 0.96, height: sizeWithoutBorder.height * 1.04))
            sharedInstance.circlePathSqueezeHorizontal = UIBezierPath(ovalInRect: CGRect(x: (JTSplashView.screenSize.width / 2) - ((sizeWithoutBorder.width / 2) * 1.04), y: (JTSplashView.screenSize.height / 2) - ((sizeWithoutBorder.height / 2) * 0.96), width: sizeWithoutBorder.width * 1.04, height: sizeWithoutBorder.height * 0.96))
        }
        
        sharedInstance.doInit()
    }
    
    // MARK: Public functions
    
    /**
    Class function to hide the splash view.
    
    This function hide the splash view. Should be called in the right time after the app is ready.
    */
    class func finish() {
        finishWithCompletion(nil)
    }
    
    /**
    Class function to hide the splash view with completion handler.
    
    This function hide the splash view and call the completion block afterward. Should be called in the right time after the app is ready.
    
    :param: completion The completion block
    */
    class func finishWithCompletion(completion: (() -> Void)?) {
        
        if !isVisible() {
            return
        }
        
        if (completion != nil) {
            sharedInstance.completionBlock = completion
        }
        
        sharedInstance.vibrateAgain = false;
    }
    
    /**
    Class function obtains the splashView visibility state.
    
    This function will tell you if the splashView is visible or not.
    
    :returns: Bool Tells us if is the splashView visible.
    */
    class func isVisible() -> Bool {
        return (sharedInstance.alpha != 0.0)
    }
    
    // MARK: Private functions
    @objc private func addToWindow() {
        UIApplication.sharedApplication().keyWindow?.addSubview(JTSplashView.sharedInstance)
    }
    
    private func finalAnimation() {
        zoomOut()
    }
    
    private func createMaskCircleLayer() -> CAShapeLayer {
        var circleLayer = CAShapeLayer()
        var maskPath = CGPathCreateMutable()
        CGPathAddPath(maskPath, nil, circlePathShrinked.CGPath)
        CGPathAddRect(maskPath, nil, CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        circleLayer.path = maskPath
        circleLayer.fillRule = kCAFillRuleEvenOdd
        circleLayer.fillColor = circleColor.CGColor
        
        return circleLayer
    }
    
    private func createBaseCircle() {
        baseCircleLayer.path = circlePathInitial.CGPath
        baseCircleLayer.fillRule = kCAFillRuleEvenOdd
        baseCircleLayer.fillColor = UIColor.clearColor().CGColor
        baseCircleLayer.strokeColor = circleColor.CGColor
        baseCircleLayer.lineWidth = borderWidth
        
        enlarge()
        NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("vibration"), userInfo: nil, repeats: false)
        
        layer.addSublayer(baseCircleLayer)
    }
    
    private func createBackgroundWithMask(mask: CAShapeLayer?) -> UIView {
        var backgroundView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        backgroundView.backgroundColor = bgColor
        backgroundView.userInteractionEnabled = false
        
        if (mask != nil) {
            backgroundView.layer.mask = createMaskCircleLayer()
        }
        
        return backgroundView
    }
    
    // Animations
    @objc private func zoomIn() {
        UIView.animateWithDuration(NSTimeInterval(self.duration * 0.5), delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            // The rest of the transformation will not be visible due completion block alpha = 0 part. But it will look like it just continued faster
            var cornerCorrection : CGFloat = 1.25
            var multiplier = (JTSplashView.screenSize.height / self.borderWidth) * cornerCorrection
            
            self.bgWithMask.transform = CGAffineTransformMakeScale(multiplier, multiplier)
            self.bgWithMask.center = CGPointMake(JTSplashView.screenSize.width / 2, JTSplashView.screenSize.height / 2)
            
            }) { (Bool) -> Void in
                
                // Run optional block if exists
                if (self.completionBlock != nil) {
                    self.completionBlock!()
                }
                
                self.alpha = 0.0
                self.bgWithMask.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.bgWithMask.center = CGPointMake(JTSplashView.screenSize.width / 2, JTSplashView.screenSize.height / 2)
        }
    }
    
    private func zoomOut() {
        // Shrink
        var shrinkAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        shrinkAnimation.fromValue = circlePathFinal.CGPath
        shrinkAnimation.toValue = circlePathShrinked.CGPath
        shrinkAnimation.duration = duration;
        shrinkAnimation.fillMode = kCAFillModeForwards
        shrinkAnimation.removedOnCompletion = false
        shrinkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        baseCircleLayer.addAnimation(shrinkAnimation, forKey: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(shrinkAnimation.duration, target: self, selector: Selector("fadeOut"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(shrinkAnimation.duration, target: self, selector: Selector("zoomIn"), userInfo: nil, repeats: false)
    }
    
    private func enlarge() {
        var enlargeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        enlargeAnimation.fromValue = circlePathInitial.CGPath
        enlargeAnimation.toValue = circlePathFinal.CGPath
        enlargeAnimation.duration = duration;
        enlargeAnimation.fillMode = kCAFillModeForwards
        enlargeAnimation.removedOnCompletion = false
        baseCircleLayer.addAnimation(enlargeAnimation, forKey: nil)
    }
    
    @objc private func vibration() {
        var vibration1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration1.fromValue = circlePathFinal.CGPath
        vibration1.toValue = circlePathSqueezeVertical.CGPath
        vibration1.beginTime = 0.0
        vibration1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        vibration1.duration = duration
        
        var vibration2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration2.fromValue = circlePathSqueezeVertical.CGPath
        vibration2.toValue = circlePathSqueezeHorizontal.CGPath
        vibration2.beginTime = duration
        vibration2.duration = duration
        vibration2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        var vibration3: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration3.fromValue = circlePathSqueezeHorizontal.CGPath
        vibration3.toValue = circlePathSqueezeVertical.CGPath
        vibration3.beginTime = duration * 2
        vibration3.duration = duration
        vibration3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        var vibration4: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration4.fromValue = circlePathSqueezeVertical.CGPath
        vibration4.toValue = circlePathFinal.CGPath
        vibration4.beginTime = duration * 3
        vibration4.duration = duration
        vibration4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        var vibrations: CAAnimationGroup = CAAnimationGroup()
        vibrations.animations = [vibration1, vibration2, vibration3, vibration4]
        vibrations.duration = duration * 4
        vibrations.repeatCount = 1
        baseCircleLayer.addAnimation(vibrations, forKey: nil)
        
        // Vibrate one more time or trigger final animation
        if vibrateAgain {
            NSTimer.scheduledTimerWithTimeInterval(duration * 4, target: self, selector: Selector("vibration"), userInfo: nil, repeats: false)
        } else {
            finalAnimation()
        }
    }
    
    @objc private func fadeOut() {
        self.bgWithoutMask.alpha = 0.0
        self.baseCircleLayer.opacity = 0.0
    }
}