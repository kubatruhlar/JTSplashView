[![Version](https://img.shields.io/cocoapods/v/JTSplashView.svg)](http://cocoapods.org/pods/JTSplashView)
[![License](https://img.shields.io/cocoapods/l/JTSplashView.svg)](http://cocoapods.org/pods/JTSplashView)
[![Platform](https://img.shields.io/cocoapods/p/JTSplashView.svg)](http://cocoapods.org/pods/JTSplashView)

# JTSplashView

Create the beautiful splash view with **JTSplashView**.

<h3 align="center">
  <img src="https://github.com/kubatru/JTSplashView/blob/master/Screens/default.gif" alt="Default Example 1" height="568"/>
<img src="https://github.com/kubatru/JTSplashView/blob/master/Screens/examples.png" alt="Examples" height="568"/>
</h3>


## Installation
There are two ways to add the **JTSplashView** library to your project. Add it as a regular library or install it through **CocoaPods**.

`pod 'JTSplashView'`

You may also quick try the example project with

`pod try JTSplashView`

**Library requires target iOS 7.0 and above**

> **Designed for Portrait mode only.**


## Usage and Customization

It is designed as a singleton so you do not have to care about instances. Just call `splashViewWithBackgroundColor(, circleColor:, circleSize:)` and in the right time dismiss it with `finish()`

### Simple programmatic example:
```swift
JTSplashView.splashViewWithBackgroundColor(nil, circleColor: nil, circleSize: nil)
```

And **dismiss** with:
```swift
JTSplashView.finishWithCompletion { () -> Void in
            UIApplication.sharedApplication().statusBarHidden = false
        }
```

## Changelog

### v1.0.0 - 07.29.15
- [**NEW**] Initial commit

## Author
This library is open-sourced by [Jakub Truhlar](http://kubatruhlar.cz).
    
## License
The MIT License (MIT)
Copyright © 2015 Jakub Truhlar