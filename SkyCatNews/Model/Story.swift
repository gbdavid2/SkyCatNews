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

    let headline: String
    var updated: Date
    var creationDateOnly: Bool
    let teaserText: String
    let teaserImage: NewsImage
    // let heroImage: NewsImage
    // let content: [StoryRepresentable]
    
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
    var creationDateOnly: Bool
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
    
    /// If we have a modified date value and the value is later than the creation date, then `creationDateOnly = false` otherwise, it should be set to `true`
    var creationDateOnly: Bool { get set }
    
}
extension TimeReportable {
    
    /// - returns: Either "Created" or "Updated" based on the contents of the variable `creationDateOnly`
    private func getUpdatedText() -> String {
        return creationDateOnly ? .created: .updated
    }
    
    /// - returns: The minutes or hours (if more than 60m) that this story was updated based on the client timezone.
    private func getUpdatedTime() -> String {
        let result = Calendar.calculateTimeFromDate(fromDate: updated)
        let component = result.component == .minute ? "m" : "h"
        return "\(result.time) \(component)"
    }
    
    func getFullUpdateText() -> String {
        return "\(getUpdatedText()) \(getUpdatedTime()) \(String.ago)"
    }

    func getUpdatedDate(creationDate: String, modifiedDate: String) -> (updatedDate: Date, creationDateOnly: Bool) {
        // by default we assume it is not creationDateOnly if modifiedDate has a value
        let creationDateOnly = modifiedDate == ""
        
        let creationDate = Date.convert(fromString: creationDate)
        let modifiedDate = Date.convert(fromString: modifiedDate)
        
        guard let resultCreationDate = creationDate else {
            preconditionFailure(.invalidCreationDate)
        }
        
        if let resultModifiedDate = modifiedDate, Date.minutesBetweenDates(resultCreationDate, resultModifiedDate) > 0 {
            return (resultModifiedDate, false)
        } else {
            return (resultCreationDate, true)
        }
    }
    
    
}

