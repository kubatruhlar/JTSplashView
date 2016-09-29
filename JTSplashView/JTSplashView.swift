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
    static let screenSize = UIScreen.main.bounds.size
    
    let duration = 0.3
    let borderWidth : CGFloat = 10.0
    
    var bgColor = UIColor(red: 45.0 / 255.0, green: 61.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    var circleColor = UIColor(red: 110.0 / 255.0, green: 180.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    var vibrateAgain = true
    var completionBlock:(() -> Void)?
    
    var circlePathInitial = UIBezierPath(ovalIn: CGRect(x: screenSize.width / 2, y: screenSize.height / 2, width: 0.0, height: 0.0))
    var circlePathFinal = UIBezierPath(ovalIn: CGRect(x: (screenSize.width / 2) - 35.0, y: (screenSize.height / 2) - 35.0, width: 70.0, height: 70.0))
    var circlePathShrinked = UIBezierPath(ovalIn: CGRect(x: screenSize.width / 2 - 5.0, y: screenSize.height / 2 - 5.0, width: 10.0, height: 10.0))
    var circlePathSqueezeVertical = UIBezierPath(ovalIn: CGRect(x: (screenSize.width / 2) - 34.0, y: (screenSize.height / 2) - 36.0, width: 68.0, height: 72.0))
    var circlePathSqueezeHorizontal = UIBezierPath(ovalIn: CGRect(x: (screenSize.width / 2) - 36.0, y: (screenSize.height / 2) - 34.0, width: 72.0, height: 68.0))
    
    var baseCircleLayer = CAShapeLayer()
    var bgWithMask = UIView()
    var bgWithoutMask = UIView()
    
    // MARK: Initializers
    init() {
        super.init(frame:CGRect.zero)
        self.alpha = 0.0
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        doInit()
    }
    
    func doInit() {
        // 1x with mask and above 1x without mask BG
        bgWithMask = createBackgroundWithMask(createMaskCircleLayer())
        bgWithoutMask = createBackgroundWithMask(nil)
        
        addSubview(bgWithMask)
        addSubview(bgWithoutMask)
        createBaseCircle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(JTSplashView.addToWindow), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
    }
    
    /**
    Class function to create the splash view.
    
    This function takes three optional arguments and generate splash view above everything in keyWindow. StatusBar is hidden during the process, so you should make it visible in finish function block.
    
    :param:  backgroundColor Background color of the splash view. Default is asphalt color.
    :param:  circleColor Color of the animated circle. Default is blue color.
    :param:  circleSize Size of the animated circle. 10pt border will be added, but the size remains the same. Width should be same as height. Default is CGSize(70, 70).
    */
    class func splashViewWithBackgroundColor(_ backgroundColor: UIColor?, circleColor: UIColor?, circleSize: CGSize?) {
        
        if isVisible() {
            return
        }
        
        UIApplication.shared.isStatusBarHidden = true
        sharedInstance.alpha = 1.0
        
        // Redefine properties
        if (backgroundColor != nil) {
            sharedInstance.bgColor = backgroundColor!
        }
        
        if (circleColor != nil) {
            sharedInstance.circleColor = circleColor!
        }
        
        if (circleSize != nil) {
            let sizeWithoutBorder = CGSize(width: circleSize!.width - sharedInstance.borderWidth, height: circleSize!.height - sharedInstance.borderWidth)
            
            sharedInstance.circlePathFinal = UIBezierPath(ovalIn: CGRect(x: (JTSplashView.screenSize.width / 2) - (sizeWithoutBorder.width / 2), y: (JTSplashView.screenSize.height / 2) - (sizeWithoutBorder.height / 2), width: sizeWithoutBorder.width, height: sizeWithoutBorder.height))
            sharedInstance.circlePathSqueezeVertical = UIBezierPath(ovalIn: CGRect(x: (JTSplashView.screenSize.width / 2) - ((sizeWithoutBorder.width / 2) * 0.96), y: (JTSplashView.screenSize.height / 2) - ((sizeWithoutBorder.height / 2) * 1.04), width: sizeWithoutBorder.width * 0.96, height: sizeWithoutBorder.height * 1.04))
            sharedInstance.circlePathSqueezeHorizontal = UIBezierPath(ovalIn: CGRect(x: (JTSplashView.screenSize.width / 2) - ((sizeWithoutBorder.width / 2) * 1.04), y: (JTSplashView.screenSize.height / 2) - ((sizeWithoutBorder.height / 2) * 0.96), width: sizeWithoutBorder.width * 1.04, height: sizeWithoutBorder.height * 0.96))
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
    class func finishWithCompletion(_ completion: (() -> Void)?) {
        
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
    @objc fileprivate func addToWindow() {
        UIApplication.shared.keyWindow?.addSubview(JTSplashView.sharedInstance)
    }
    
    fileprivate func finalAnimation() {
        zoomOut()
    }
    
    fileprivate func createMaskCircleLayer() -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        maskPath.addPath(circlePathShrinked.cgPath)
        maskPath.addRect(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height));
        circleLayer.path = maskPath
        circleLayer.fillRule = kCAFillRuleEvenOdd
        circleLayer.fillColor = circleColor.cgColor
        
        return circleLayer
    }
    
    fileprivate func createBaseCircle() {
        baseCircleLayer.path = circlePathInitial.cgPath
        baseCircleLayer.fillRule = kCAFillRuleEvenOdd
        baseCircleLayer.fillColor = UIColor.clear.cgColor
        baseCircleLayer.strokeColor = circleColor.cgColor
        baseCircleLayer.lineWidth = borderWidth
        
        enlarge()
        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(JTSplashView.vibration), userInfo: nil, repeats: false)
        
        layer.addSublayer(baseCircleLayer)
    }
    
    fileprivate func createBackgroundWithMask(_ mask: CAShapeLayer?) -> UIView {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        backgroundView.backgroundColor = bgColor
        backgroundView.isUserInteractionEnabled = false
        
        if (mask != nil) {
            backgroundView.layer.mask = createMaskCircleLayer()
        }
        
        return backgroundView
    }
    
    // Animations
    @objc fileprivate func zoomIn() {
        UIView.animate(withDuration: TimeInterval(self.duration * 0.5), delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            // The rest of the transformation will not be visible due completion block alpha = 0 part. But it will look like it just continued faster
            let cornerCorrection : CGFloat = 1.25
            let multiplier = (JTSplashView.screenSize.height / self.borderWidth) * cornerCorrection
            
            self.bgWithMask.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
            self.bgWithMask.center = CGPoint(x: JTSplashView.screenSize.width / 2, y: JTSplashView.screenSize.height / 2)
            
            }) { (Bool) -> Void in
                
                // Run optional block if exists
                if (self.completionBlock != nil) {
                    self.completionBlock!()
                }
                
                self.alpha = 0.0
                self.bgWithMask.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.bgWithMask.center = CGPoint(x: JTSplashView.screenSize.width / 2, y: JTSplashView.screenSize.height / 2)
        }
    }
    
    fileprivate func zoomOut() {
        // Shrink
        let shrinkAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        shrinkAnimation.fromValue = circlePathFinal.cgPath
        shrinkAnimation.toValue = circlePathShrinked.cgPath
        shrinkAnimation.duration = duration;
        shrinkAnimation.fillMode = kCAFillModeForwards
        shrinkAnimation.isRemovedOnCompletion = false
        shrinkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        baseCircleLayer.add(shrinkAnimation, forKey: nil)
        
        Timer.scheduledTimer(timeInterval: shrinkAnimation.duration, target: self, selector: #selector(JTSplashView.fadeOut), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: shrinkAnimation.duration, target: self, selector: #selector(JTSplashView.zoomIn), userInfo: nil, repeats: false)
    }
    
    fileprivate func enlarge() {
        let enlargeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        enlargeAnimation.fromValue = circlePathInitial.cgPath
        enlargeAnimation.toValue = circlePathFinal.cgPath
        enlargeAnimation.duration = duration;
        enlargeAnimation.fillMode = kCAFillModeForwards
        enlargeAnimation.isRemovedOnCompletion = false
        baseCircleLayer.add(enlargeAnimation, forKey: nil)
    }
    
    @objc fileprivate func vibration() {
        let vibration1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration1.fromValue = circlePathFinal.cgPath
        vibration1.toValue = circlePathSqueezeVertical.cgPath
        vibration1.beginTime = 0.0
        vibration1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        vibration1.duration = duration
        
        let vibration2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration2.fromValue = circlePathSqueezeVertical.cgPath
        vibration2.toValue = circlePathSqueezeHorizontal.cgPath
        vibration2.beginTime = duration
        vibration2.duration = duration
        vibration2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let vibration3: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration3.fromValue = circlePathSqueezeHorizontal.cgPath
        vibration3.toValue = circlePathSqueezeVertical.cgPath
        vibration3.beginTime = duration * 2
        vibration3.duration = duration
        vibration3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let vibration4: CABasicAnimation = CABasicAnimation(keyPath: "path")
        vibration4.fromValue = circlePathSqueezeVertical.cgPath
        vibration4.toValue = circlePathFinal.cgPath
        vibration4.beginTime = duration * 3
        vibration4.duration = duration
        vibration4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let vibrations: CAAnimationGroup = CAAnimationGroup()
        vibrations.animations = [vibration1, vibration2, vibration3, vibration4]
        vibrations.duration = duration * 4
        vibrations.repeatCount = 1
        baseCircleLayer.add(vibrations, forKey: nil)
        
        // Vibrate one more time or trigger final animation
        if vibrateAgain {
            Timer.scheduledTimer(timeInterval: duration * 4, target: self, selector: #selector(JTSplashView.vibration), userInfo: nil, repeats: false)
        } else {
            finalAnimation()
        }
    }
    
    @objc fileprivate func fadeOut() {
        self.bgWithoutMask.alpha = 0.0
        self.baseCircleLayer.opacity = 0.0
    }
}
