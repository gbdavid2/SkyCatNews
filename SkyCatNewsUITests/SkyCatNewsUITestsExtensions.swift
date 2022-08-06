//
//  SkyCatNewsUITestsExtensions.swift
//  SkyCatNewsUITests
//
//  Created by David Garces on 06/08/2022.
//


import SwiftUI

extension String {
    
    // MARK: UI Strings
    static var skyTitle = "Sky Cat News"
    
    // MARK: UI - Geometry Reader
    static var scroll = "scroll"
    
    // MARK: UI Assets
    static var background = "Background"
    static var blob1 = "Blob"
    
}

extension Double {
    // MARK: UI Font
    static var titleSmall = 22.0
    static var titleLarge = 34.0
    
    // MARK: UI Opacity
    static var titleFaded = 0.7
    static var titleStrong = 1.0
}

extension CGFloat {
    // MARK: UI General padding
    static var generalHorizontal = CGFloat(20)
    
    // MARK: UI Padding
    static var titleHorizontal = CGFloat(20)
    static var titleTop = CGFloat(24)
    
    // MARK: Frame sizes
    static var navigationBarHeight = CGFloat(100)
    
    // MARK: Offsets
    static var navigationBarHiddenY = CGFloat(-120)
    static var navigationBarContentHasScrolledY = CGFloat(-16)
}
