//
//  StringExtensions.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import SwiftUI

extension String {
    
    // MARK: UI Strings
    static var skyTitle = "Sky Cat News (offline)"
    static var newsSection = "Latest"
    
    // MARK: UI - Geometry Reader
    static var scroll = "scroll"
    
    // MARK: UI - Stories
    static var loadingStories = "Loading News..."
    
    // MARK: UI Assets
    static var background = "Background"
    static var blob1 = "Blob"
    
    // MARK: JSON Test files
    static var sampleList = "sample_list.json"
    static var sampleStory = "sample_story1.json"
    
    // MARK: JSON Test values
    static var storyID = "1"
    static var storyHeadline = "Cat story headline"
    static var storyTeaserText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    // MARK: URL Common Components
    static var defaultScheme = "https"
    
    // MARK: URL Test Text components
    static var testRandomAPI_Host = "random-data-api.com"
    static var testRandomAPI_Path = "/api/coffee/random_coffee"
    
    // MARK: URL Test Image components
    static var testPicsumAPI_Host = "picsum.photos"
    static var testPicsumAPI_Path = "/100/100"
    
    // MARK: URL Components Live server
    static var skyCat_Host = "sky-cat-news.com"
    static var newsPath = "/news-list"
    static var storyPath = "/story"
    
    // MARK: URL Messages
    static var invalidURL = "Invalid static URL"
    
    // MARK: Accessibility Identifiers
    static var mediaItemImageIdentifier = "media_image_identifier"
    static var storiesViewIdentifier = "stories_view_identifier"
    
    // MARK: Accessibility Labels
    static var mediaItemImage = "Media Item Image"

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
    
    // MARK: UI Frame sizes
    static var navigationBarHeight = CGFloat(100)
    
    // MARK: UI Offsets
    static var navigationBarHiddenY = CGFloat(-120)
    static var navigationBarContentHasScrolledY = CGFloat(-16)
    static var blobOffsetX = CGFloat(-100)
    static var blobOffsetY = CGFloat(-400)
}

extension URL {
    
    // MARK: Live Server URLs
    
    static var newsListURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = .defaultScheme
        urlComponents.host = .skyCat_Host
        urlComponents.path = .newsPath
        return urlComponents.checkedURL
    }
    
    static func storyURL(storyID id: Int) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = .defaultScheme
        urlComponents.host = .skyCat_Host
        urlComponents.path = "\(String.storyPath)/\(id)"
        return urlComponents.checkedURL
    }
    
    // MARK: Test Server URLs
    
    static var coffeeURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = .defaultScheme
        urlComponents.host = .testRandomAPI_Host
        urlComponents.path = .testRandomAPI_Path
        return urlComponents.checkedURL
    }
    
    static var randomImageURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = .defaultScheme
        urlComponents.host = .testPicsumAPI_Host
        urlComponents.path = .testPicsumAPI_Path
        return urlComponents.checkedURL
    }
    
}

extension URLComponents {
    var checkedURL: URL {
        guard let url = self.url else {
            preconditionFailure("\(String.invalidURL) \(String(describing: self.url?.absoluteString))")
        }
        return url
    }
}
