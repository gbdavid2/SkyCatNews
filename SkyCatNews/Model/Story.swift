//
//  File.swift
//  SkyCatNews
//
//  Created by David Garces on 11/08/2022.
//

import Foundation

protocol NewsRepresentable {
    func getMediaType() -> MediaItem.MediaItemType
}

struct Story: NewsRepresentable, TimeReportable {
    let id: Int
    let headline: String
    var updated: Date
    let teaserText: String
    let teaserImage: NewsImage

    func getMediaType() -> MediaItem.MediaItemType {
        return .story
    }
}

struct DetailedStory: NewsRepresentable, TimeReportable {
    let id: Int
    let headline: String
    var updated: Date
    let heroImage: NewsImage
    let content: [StoryRepresentable]
    
    func getMediaType() -> MediaItem.MediaItemType {
        return .story
    }
}

protocol StoryRepresentable {
}

struct NewsImage: StoryRepresentable {
    let imageURL: URL
    let accessibilityText: String
}
struct NewsParagraph: StoryRepresentable {
    let text: String
}

struct WebLink: NewsRepresentable, TimeReportable {
    let headline: String
    var updated: Date
    let url: URL
    let teaserImage: NewsImage
    
    func getMediaType() -> MediaItem.MediaItemType {
        return .weblink
    }
}

struct Advert: NewsRepresentable {
    
    let url: URL
    
    func getMediaType() -> MediaItem.MediaItemType {
        return .advert
    }
}

protocol TimeReportable {
    /// `updated` is a Date that will constantly keep updating when we refresh and retrieve data from the server. We will either the creation date or the modified date (if we have a modified date value and this value is later than the creation date)
    var updated: Date { get set }
    
}
extension TimeReportable {
    
    /// - returns: The minutes or hours (if more than 60m) that this story was updated based on the client timezone.
    private func getUpdatedTime() -> String {
        let result = Calendar.calculateTimeFromDate(fromDate: updated)
        var component = ""
        switch result.component {
        case .minute:
            component = "m"
        case .hour:
            component = "h"
        default:
            component = "d"
        }
        return "\(result.time)\(component)"
    }
    
    func getFullUpdateText() -> String {
        return "\(String.updated) \(getUpdatedTime()) \(String.ago)"
    }
    
    func getShortUpdateText() -> String {
        return "\(getUpdatedTime()) \(String.ago)"
    }

    
}

